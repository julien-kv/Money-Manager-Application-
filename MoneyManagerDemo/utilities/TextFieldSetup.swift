//
//  TextFieldSetup.swift
//  MoneyManagerDemo
//
//  Created by Julien on 01/11/21.
//

import Foundation
import UIKit

class TextFieldSetup{
    var gradiant: CAGradientLayer = {
        //Gradiant for the background view
        let blue = UIColor(red: 69/255, green: 127/255, blue: 202/255, alpha: 1.0).cgColor
        let purple = UIColor(red: 166/255, green: 172/255, blue: 236/255, alpha: 1.0).cgColor
        let gradiant = CAGradientLayer()
        gradiant.colors = [purple, blue]
        gradiant.startPoint = CGPoint(x: 0.5, y: 0.18)
        return gradiant
    }()
    func setButton(btn:UIButton){
        btn.layer.cornerRadius=15.0
    }
    func setTextFieldImage(imgString:String,txtField:UITextField){
        //person,lock
        txtField.leftViewMode = UITextField.ViewMode.always
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let imageView = UIImageView(frame: CGRect(x: 10, y: 0, width: 20, height: 20))
        let image = UIImage(systemName: imgString)
        imageView.image = image
        mainView.addSubview(imageView)
        txtField.leftView = mainView
    }
    func setuptextFieldForUserNameAndPassword(txtField:UITextField,placeHolder:String){
        txtField.layer.borderWidth=1.0
        txtField.attributedPlaceholder = NSAttributedString(
            string: placeHolder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)
                         , NSAttributedString.Key.font : UIFont(name: "Lato", size: 17)!]
        )
        txtField.layer.cornerRadius = 15.0
        txtField.textColor=UIColor.white
        txtField.layer.borderColor = UIColor.white.withAlphaComponent(0.5).cgColor
        
    }
    func gradient(view:UIView,BgView:UIView) {
        //Add the gradiant to the view:
        gradiant.frame = view.bounds
        BgView.layer.insertSublayer(gradiant, at: 0)
        
    }
}
