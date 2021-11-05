//
//  SignUpViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 29/10/21.
//

import UIKit
import GoogleSignIn

class SignUpViewController: UIViewController {
    
    @IBOutlet var BgView: UIView!
    @IBOutlet var UserNameTextField: UITextField!
    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PwdTextField: UITextField!
    @IBOutlet var pwdConfirmTextField: UITextField!
    @IBOutlet var SignUpButton: UIButton!
    var textfieldSet = TextFieldSetup()
    
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
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let storyboard = UIStoryboard(name: "MoneyManagerDashboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashBoard")
            self.navigationController?.pushViewController(vc, animated: true)
          }
    }
    @IBAction func didTapFacebookLogin(_ sender: Any) {
    }
    @IBAction func didTapSignUp(_ sender: Any) {
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
