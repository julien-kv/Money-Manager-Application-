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
    var loginviewmodel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserNametextField.delegate=self
        PasswordTextField.delegate=self
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
        loginviewmodel.navigateToSignUpFromLoginvc(self: self)
    }
    
    @IBAction func didTapGoogleSignIn(_ sender: Any) {
        loginviewmodel.setupGoogleLogin(vc: self)
    }

    @IBAction func didTapSignInButton(_ sender: Any) {
        if (loginviewmodel.areTextFieldsEmpty(UserNameTextField: UserNametextField,PwdTextField: PasswordTextField)){
            loginviewmodel.showEmptyTextfieldAlert(vc: self)
            return
        }
        else{
            self.loginviewmodel.navigateToDashBoard(username: UserNametextField.text)
        }
    }
    
    @IBAction func didTapFBSignIn(_ sender: Any) {
        loginviewmodel.setupFbLogin(vc: self)
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

extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(textField.text != ""){
            return true
        }
        else{
            textField.placeholder = "Type Something"
            return false
        }
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
