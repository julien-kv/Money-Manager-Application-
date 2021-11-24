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
    var textfieldSet = TextFieldSetup()
    var signupviewmodel = SignupViewmodel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNameTextField.delegate=self
        EmailTextField.delegate=self
        PwdTextField.delegate=self
        pwdConfirmTextField.delegate=self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        setTextfieldView()
    }
    

    @IBAction func didTapBackButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func didTapGoogleLoginButton(_ sender: Any) {
        signupviewmodel.setupGoogleLogin(vc: self)
    }
    
 
    @IBAction func didTapFacebookLogin(_ sender: Any) {
        signupviewmodel.setupFbLogin(vc: self)
    }
    
    @IBAction func didTapSignUp(_ sender: Any) {
                if (signupviewmodel.areTextFieldsEmpty(UserNameTextField: UserNameTextField, EmailTextField: EmailTextField, PwdTextField: PwdTextField, pwdConfirmTextField: pwdConfirmTextField)){
        
                    signupviewmodel.showEmptyTextfieldAlert(vc: self)
                    return
                }
                else{
                    self.signupviewmodel.navigateToDashBoard(username: EmailTextField.text)
                }
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
    func setTextfieldView(){
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
