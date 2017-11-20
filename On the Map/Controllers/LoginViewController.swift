//
//  LoginViewController.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/6/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    let signUpPageUrl = "https://www.udacity.com/account/auth#!/signup"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func openURL(_ sender: Any) {
        UIApplication.shared.open(URL(string: signUpPageUrl)!, options: [String: Any](), completionHandler: nil)
    }
    
    @IBAction func login(_ sender: Any) {
        enableUI(enable: false)
        errorLabel.text = ""
        
        if (emailField.text?.isEmpty)! || (passwordField.text?.isEmpty)! {
            enableUI(enable: true)
            errorLabel.text = "Please enter email and/or password."
        }
        
        //authenticate user
        let input: [String] = [self.emailField.text!, self.passwordField.text!]
        UdacityClient.sharedInstance().authenticate(input, hostView: self)
    }
    
    func loginComplete() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "TabBarNav")
        enableUI(enable: true)
        present(controller!, animated: true, completion: nil)
    }
    
    func enableUI(enable: Bool) {
        emailField.isEnabled = enable
        emailField.alpha = enable ? 1.0 : 0.5
        passwordField.isEnabled = enable
        passwordField.alpha = enable ? 1.0 : 0.5
        loginButton.isEnabled = enable
        loginButton.alpha = enable ? 1.0 : 0.5
    }
    
}

