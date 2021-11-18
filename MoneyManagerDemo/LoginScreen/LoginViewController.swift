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

class LoginViewController: UIViewController{
    @IBOutlet var UserNametextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var BgView: UIView!
    @IBOutlet var SIgnInButton: UIButton!
    var textFieldSet = TextFieldSetup()
    lazy var activityViewIndicator = LoadingIndicator.addIndicator(view: self.view,type: .ballClipRotateMultiple)
    let defaults = UserDefaults.standard

    
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
                self.navigateToDashBoard()
              }
                }
    }
    func navigateToDashBoard(username:String? = nil){
        let storyboard = UIStoryboard(name: "MoneyManagerDashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! DashboardTabbarVC
        vc.username = UserNametextField.text
        defaults.set(username, forKey: username!)
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

    
    func setupBg(){
        textFieldSet.setuptextFieldForUserNameAndPassword(txtField: UserNametextField,placeHolder: "User Name")
        textFieldSet.setuptextFieldForUserNameAndPassword(txtField: PasswordTextField,placeHolder: "Password")
        textFieldSet.gradient(view: self.view, BgView: BgView)
        textFieldSet.setTextFieldImage(imgString: "person", txtField: UserNametextField)
        textFieldSet.setTextFieldImage(imgString: "lock", txtField: PasswordTextField)
        textFieldSet.setButton(btn: SIgnInButton)
        
    }
}
