//
//  SettingsPageViewmodel.swift
//  MoneyManagerDemo
//
//  Created by Julien on 24/11/21.
//

import Foundation
import UIKit
import GoogleSignIn
import FBSDKLoginKit

class SettingsPageViewmodel{
    var textfieldobj=TextFieldSetup()
    let defaults = UserDefaults.standard
    
    
    func doLogout(){
        GIDSignIn.sharedInstance.signOut()
        LoginManager().logOut()
        self.defaults.set(false, forKey: "loggedIn")
    }
}
