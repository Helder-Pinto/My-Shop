//
//  LoginViewController.swift
//  MyShop
//
//  Created by Apple on 28/04/2019.
//  Copyright © 2019 Helder Pinto. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginBtn.layer.cornerRadius = 8
        loginBtn.layer.borderWidth = 1
        loginBtn.layer.borderColor =  UIColor.blue.cgColor
        
        
        signUpBtn.layer.cornerRadius = 8
        signUpBtn.layer.borderWidth = 1
        signUpBtn.layer.borderColor =  UIColor.white.cgColor
       
    }
    

    //MARK: IBActions
    
    @IBAction func signInPressed(_ sender: Any) {
    }
    
    @IBAction func forgotBtnPressed(_ sender: Any) {
    }
    
}
