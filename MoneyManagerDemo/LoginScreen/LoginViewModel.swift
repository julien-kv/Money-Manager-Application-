//
//  LoginViewModel.swift
//  MoneyManagerDemo
//
//  Created by Julien on 01/11/21.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import NVActivityIndicatorView
import CoreData

class LoginViewModel{
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var email:String?
    var tempArray:[User] = []
    
    func navigateToDashBoard(username:String? = nil){
        let storyboard = UIStoryboard(name: "MoneyManagerDashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "tabbarcontroller") as! DashboardTabbarVC
        defaults.set(username, forKey: "username")
        self.CreateNewUser(email: username!)
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    func CreateNewUser(email:String){
        do{
        tempArray = try context.fetch(User.fetchRequest())
        }catch{
            
        }
        if tempArray .firstIndex(where: {$0.usename == email}) != nil {
           // do something with foo
            return
        } else {
           // item could not be found
            let newPerson = User(context: self.context)
            newPerson.usename = email
            do{
                try self.context.save()
            }catch{
                
            }
        }
   }
    func areTextFieldsEmpty(UserNameTextField:UITextField,PwdTextField:UITextField)->Bool{
        if(UserNameTextField.text==""  || PwdTextField.text == "" ){
            return true
        }
        else{
            return false
        }
    }
    func showEmptyTextfieldAlert(vc:UIViewController){
        let alert = UIAlertController(title: "Input Fields can't be empty!!",message: "ALl the fields must be filled",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .cancel))
        vc.present(alert, animated: true)
    }
    func setupGoogleLogin(vc: UIViewController){
        let activityViewIndicator = LoadingIndicator.addIndicator(view: vc.view,type: .ballClipRotateMultiple)
        activityViewIndicator.startAnimating()
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: vc) { user, error in
            guard error == nil else {
                activityViewIndicator.stopAnimating()
                return }
            activityViewIndicator.stopAnimating()
            self.navigateToDashBoard(username: user?.profile?.email)
        }
    }
    func navigateToSignUpFromLoginvc(self:UIViewController){
        
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
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupFbLogin(vc:UIViewController){
        let activityViewIndicator = LoadingIndicator.addIndicator(view: vc.view,type: .ballClipRotateMultiple)
        activityViewIndicator.startAnimating()
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["public_profile", "email"], from: vc) { [weak self] (result, error) in
            // Check for error
            guard error == nil else {
                // Error occurred
                print(error!.localizedDescription)
                return
            }
            
            // Check for cancel
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                activityViewIndicator.stopAnimating()
                return
            }
            // Check the result
            guard let accessToken = FBSDKLoginKit.AccessToken.current else { return }
            let graphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                          parameters: ["fields": "email, name"],
                                                          tokenString: accessToken.tokenString,
                                                          version: nil,
                                                          httpMethod: .get)
            graphRequest.start { (connection, result, error) -> Void in
                if error == nil {
                    guard let json = result as? NSDictionary else{
                        return
                    }
                    if let email=json["email"] as? String{
                        print(email)
                        activityViewIndicator.stopAnimating()
                        
                        self?.navigateToDashBoard(username: email)
                    }
                }
                else {
                    
                }
            }
        }
   
    }
    

}
