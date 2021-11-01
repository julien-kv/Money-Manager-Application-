//
//  LoginViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 29/10/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet var UserNametextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var BgView: UIView!
    @IBOutlet var SIgnInButton: UIButton!
    var textFieldSet = TextFieldSetup()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupBg()
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignupScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupScreen")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
