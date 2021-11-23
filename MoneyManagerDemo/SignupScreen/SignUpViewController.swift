//
//  SignUpViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 29/10/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import CoreData

class SignUpViewController: UIViewController {
    
    @IBOutlet var BgView: UIView!
    @IBOutlet var UserNameTextField: UITextField!
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PwdTextField: UITextField!
    @IBOutlet var pwdConfirmTextField: UITextField!
    @IBOutlet var SignUpButton: UIButton!
    lazy var activityViewIndicator = LoadingIndicator.addIndicator(view: self.view,type: .ballClipRotateMultiple)
    var textfieldSet = TextFieldSetup()
    var userObjectArray:[NSManagedObject] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var email:String?
    var tempArray:[User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNameTextField.delegate=self
        EmailTextField.delegate=self
        PwdTextField.delegate=self
        pwdConfirmTextField.delegate=self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        textfieldSet.gradient(view: view, BgView: BgView)
        navigationController?.setNavigationBarHidden(true, animated: true)
        textfieldSet.setuptextFieldForUserNameAndPassword(txtField: UserNameTextField, placeHolder: "Full Name")
        textfieldSet.setuptextFieldForUserNameAndPassword(txtField: EmailTextField, placeHolder: "Email")
        textfieldSet.setuptextFieldForUserNameAndPassword(txtField: PwdTextField, placeHolder: "Password")
        textfieldSet.setuptextFieldForUserNameAndPassword(txtField: pwdConfirmTextField, placeHolder: "Confirm Password")
        
        textfieldSet.setTextFieldImage(imgString: "person", txtField: UserNameTextField)
        textfieldSet.setTextFieldImage(imgString: "lock", txtField: PwdTextField)
        textfieldSet.setTextFieldImage(imgString: "lock", txtField: pwdConfirmTextField)
        textfieldSet.setTextFieldImage(imgString: "envelope", txtField: EmailTextField)
        PwdTextField.isSecureTextEntry = true
        pwdConfirmTextField.isSecureTextEntry = true
        
        
        textfieldSet.setButton(btn: SignUpButton)
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func didTapGoogleLoginButton(_ sender: Any) {
        activityViewIndicator.startAnimating()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            self.activityViewIndicator.stopAnimating()
            self.navigateToDashBoard(username: user?.profile?.email)
        }
    }
   
    
    func CreateNewUser(email:String){
        do{
        tempArray = try context.fetch(User.fetchRequest())
        }catch{
        }
        if tempArray .firstIndex(where: {$0.usename == email}) != nil {
           // do something with foo
            return
        } else {
           // item could not be found
            let newPerson = User(context: self.context)
            newPerson.usename = email
            do{
                try self.context.save()
            }catch{
                
            }
        }
    }
    func navigateToDashBoard(username:String? = nil){
        let storyboard = UIStoryboard(name: "MoneyManagerDashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! DashboardTabbarVC
        defaults.set(username, forKey: "username")
        self.CreateNewUser(email: username!)
        
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        
        
    }
    func areTextFieldsEmpty()->Bool{
        if(UserNameTextField.text==""  || EmailTextField.text == "" || PwdTextField.text == "" || pwdConfirmTextField.text == ""){
            return true
        }
        else{
            return false
        }
    }
    func showEmptyTextfieldAlert(){
        let alert = UIAlertController(title: "Input Fields can't be empty!!",message: "ALl the fields must be filled",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .cancel))
        self.present(alert, animated: true)
    }
    @IBAction func didTapFacebookLogin(_ sender: Any) {
        if (areTextFieldsEmpty()){
            showEmptyTextfieldAlert()
            return
        }
        else{
            activityViewIndicator.startAnimating()
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["public_profile", "email"], from: self) { [weak self] (result, error) in
                // Check for error
                guard error == nil else {
                    // Error occurred
                    print(error!.localizedDescription)
                    return
                }
                
                // Check for cancel
                guard let result = result, !result.isCancelled else {
                    print("User cancelled login")
                    self?.activityViewIndicator.stopAnimating()
                    return
                }
                // Check the result
                guard let accessToken = FBSDKLoginKit.AccessToken.current else { return }
                let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                              parameters: ["fields": "email, name"],
                                                              tokenString: accessToken.tokenString,
                                                              version: nil,
                                                              httpMethod: .get)
                graphRequest.start { (connection, result, error) -> Void in
                    if error == nil {
                        guard let json = result as? NSDictionary else{
                            return
                        }
                        if let email=json["email"] as? String{
                            print(email)
                            self?.activityViewIndicator.stopAnimating()
                            
                            self?.navigateToDashBoard(username: email)
                        }
                    }
                    else {
                        
                    }
                }
            }
        }
        
       
    }
    @IBAction func didTapSignUp(_ sender: Any) {
        navigateToDashBoard(username: EmailTextField.text)
    }
    func addUser()-> NSManagedObject?{
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return nil
                }
        
        // 1
        let managedContext =
        appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
        NSEntityDescription.entity(forEntityName: "User",
                                   in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(EmailTextField.text, forKeyPath: "username")
        
        
        // 4
        do {
            try managedContext.save()
            self.userObjectArray.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        return person
    }
    @IBAction func didTapSignIn(_ sender: Any) {
        var flag = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                flag=true
                break
            }
        }
        if(!flag){
            let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginScreen")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //
}

extension SignUpViewController:UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            return true
        }
        else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
