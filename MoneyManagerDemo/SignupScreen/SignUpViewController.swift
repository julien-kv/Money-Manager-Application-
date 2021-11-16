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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        textfieldSet.setButton(btn: SignUpButton)
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func didTapGoogleLoginButton(_ sender: Any) {
        activityViewIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityViewIndicator.stopAnimating()
            GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
                guard error == nil else { return }
                self.navigateToDashBoard()
              }
                }
    }
    func navigateToDashBoard(){
        let storyboard = UIStoryboard(name: "MoneyManagerDashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
       
        
    }
    @IBAction func didTapFacebookLogin(_ sender: Any) {
        activityViewIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityViewIndicator.stopAnimating()
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
                self?.navigateToDashBoard()
                }
       
        }
    }
    @IBAction func didTapSignUp(_ sender: Any) {
        let person = addUser()
        
        
        
 
        
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
