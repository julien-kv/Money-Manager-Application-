//
//  LoadingIndicator.swift
//  MoneyManagerDemo
//
//  Created by Julien on 09/11/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

class LoadingIndicator{
    static func addIndicator(view:UIView,type:NVActivityIndicatorType) -> NVActivityIndicatorView{
        let activityViewIndicator = NVActivityIndicatorView(frame: view.frame, type: type, color: UIColor.white,padding: 100)
        view.addSubview(activityViewIndicator)
        activityViewIndicator.backgroundColor = .clear.withAlphaComponent(0.5)
        return activityViewIndicator
        
    }
}
