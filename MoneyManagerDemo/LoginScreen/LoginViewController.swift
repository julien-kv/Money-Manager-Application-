//
//  LoginViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 29/10/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import NVActivityIndicatorView
import CoreData

class LoginViewController: UIViewController{
    @IBOutlet var UserNametextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var BgView: UIView!
    @IBOutlet var SIgnInButton: UIButton!
    var textFieldSet = TextFieldSetup()
    lazy var activityViewIndicator = LoadingIndicator.addIndicator(view: self.view,type: .ballClipRotateMultiple)
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var email:String?
    var tempArray:[User] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        self.navigationController?.isNavigationBarHidden = true
        setupBg()
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        var flag = false
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: SignUpViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                flag=true
                break
            }
        }
        if(!flag){
            let storyboard = UIStoryboard(name: "SignupScreen", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignupScreen")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func didTapGoogleSignIn(_ sender: Any) {
        activityViewIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityViewIndicator.stopAnimating()
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                guard error == nil else { return }
                self.navigateToDashBoard(username: user?.profile?.email)
            }
        }
    }
    func CreateNewUser(email:String){
        do{
        tempArray = try context.fetch(User.fetchRequest())
        }catch{
            
        }
        if let foo = tempArray .firstIndex(where: {$0.usename == email}) {
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
    @IBAction func didTapSignInButton(_ sender: Any) {
        activityViewIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityViewIndicator.stopAnimating()
            self.navigateToDashBoard(username: self.UserNametextField.text)
        }
    }
    
    @IBAction func didTapFBSignIn(_ sender: Any) {
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
                return
            }
            // Successfully logged in
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
                        self?.navigateToDashBoard(username: email)                        }
                }
                else {
                    
                }
            }
            
            //  self?.navigateToDashBoard(username: self?.email)
        }
        
    }
    
    
    func setupBg(){
        textFieldSet.setuptextFieldForUserNameAndPassword(txtField: UserNametextField,placeHolder: "User Name")
        textFieldSet.setuptextFieldForUserNameAndPassword(txtField: PasswordTextField,placeHolder: "Password")
        textFieldSet.gradient(view: self.view, BgView: BgView)
        textFieldSet.setTextFieldImage(imgString: "person", txtField: UserNametextField)
        textFieldSet.setTextFieldImage(imgString: "lock", txtField: PasswordTextField)
        textFieldSet.setButton(btn: SIgnInButton)
        PasswordTextField.isSecureTextEntry = true
        
    }
}
