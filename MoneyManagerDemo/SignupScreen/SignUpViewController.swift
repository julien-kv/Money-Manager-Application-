//
//  SignUpViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 29/10/21.
//

import UIKit

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
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTapGoogleLoginButton(_ sender: Any) {
    }
    @IBAction func didTapFacebookLogin(_ sender: Any) {
    }
    @IBAction func didTapSignUp(_ sender: Any) {
    }
    @IBAction func didTapSignIn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginScreen")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}
