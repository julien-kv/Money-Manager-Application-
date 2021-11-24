//
//  WelcomeScreenViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 01/11/21.
//

import UIKit

class WelcomeScreenViewController: UIViewController {
    @IBOutlet var BgView: UIView!
    
    @IBOutlet var TitleLabel: UILabel!
    @IBOutlet var LoginButton: UIButton!
    @IBOutlet var SignUpButton: UIButton!
    
    var txtset = TextFieldSetup()
    lazy var activityViewIndicator = LoadingIndicator.addIndicator(view: self.view,type: .ballGridPulse)


    override func viewDidLoad() {
        super.viewDidLoad()
        txtset.gradient(view: view, BgView: BgView)
        setButtonCornerRadius()
    
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func didTapLoginButton(_ sender: Any) {
        activityViewIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityViewIndicator.stopAnimating()
            let storyboard = UIStoryboard(name: "LoginScreen", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginScreen")
            self.navigationController?.pushViewController(vc, animated: true)
                }
    }
    @IBAction func didTapSignUpButton(_ sender: Any) {
        activityViewIndicator.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.activityViewIndicator.stopAnimating()
            let storyboard = UIStoryboard(name: "SignupScreen", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SignupScreen")
            self.navigationController?.pushViewController(vc, animated: true)
                }
    }
    
    func setButtonCornerRadius(){
        LoginButton.layer.cornerRadius = 15.0
        SignUpButton.layer.cornerRadius = 15.0
    }

}
