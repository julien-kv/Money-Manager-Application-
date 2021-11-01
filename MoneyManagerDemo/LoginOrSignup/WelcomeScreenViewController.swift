//
//  WelcomeScreenViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 01/11/21.
//

import UIKit

class WelcomeScreenViewController: UIViewController {
    @IBOutlet var BgView: UIView!
    
    @IBOutlet var LoginButton: UIButton!
    @IBOutlet var SignUpButton: UIButton!
    
    var txtset = TextFieldSetup()

    override func viewDidLoad() {
        super.viewDidLoad()
        txtset.gradient(view: view, BgView: BgView)
        setButtonCornerRadius()
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "loginScreen")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func didTapSignUpButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "SignupScreen", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignupScreen")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func setButtonCornerRadius(){
        LoginButton.layer.cornerRadius = 15.0
        SignUpButton.layer.cornerRadius = 15.0
    }

}
