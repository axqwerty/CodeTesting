//
//  BaseViewController.swift
//  CodeTest
//
//  Created by Alex on 12/7/2023.
//

import UIKit
import ProgressHUD

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLoading() {
        view.isUserInteractionEnabled = false
        ProgressHUD.animationType = .horizontalCirclesPulse
        ProgressHUD.colorAnimation = UIColor(red: 92, green: 171, blue: 103)
        ProgressHUD.colorHUD = .clear
        ProgressHUD.colorBackground = .clear
        ProgressHUD.show()
    }
    
    func hideLoading() {
        self.view.isUserInteractionEnabled = true
        ProgressHUD.dismiss()
    }
}
