//
//  ViewController.swift
//  MoneyManagerDemo
//
//  Created by Julien on 28/10/21.
//

import UIKit

class ViewController: UIViewController {
    var onBoardVC: OnBoardViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onBoardVC = OnBoardViewController()
        view.addSubview(onBoardVC.view)
        

    }

}




