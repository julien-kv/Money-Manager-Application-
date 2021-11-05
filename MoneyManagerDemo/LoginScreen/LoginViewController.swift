//
//  LoginViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 29/10/21.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet var UserNametextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var BgView: UIView!
    @IBOutlet var SIgnInButton: UIButton!
    var textFieldSet = TextFieldSetup()
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
        //navigationController?.popViewController(animated: true)
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
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let storyboard = UIStoryboard(name: "MoneyManagerDashboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "DashBoard")
            self.navigationController?.pushViewController(vc, animated: true)
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
