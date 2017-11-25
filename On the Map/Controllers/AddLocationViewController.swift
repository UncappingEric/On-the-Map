//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/14/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var linkInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationInput.delegate = self
        linkInput.delegate = self
        postButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func findLocation(_ sender: Any) {
        errorLabel.text = ""
        enableUI(enable: false)
        
        if locationInput.text == "" || linkInput.text == "" {
            enableUI(enable: true)
            errorLabel.text = "Missing location and/or link."
            return
        }
        
        let input = locationInput.text!
        
        indicator.startAnimating()
        
        ParseClient.sharedInstance().translateLocation(input) { (success, error) in
            guard success else {
                print(error!)
                self.alertFailure()
                return
            }
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SuccessfulPostController") as! SuccessfulPostController
            controller.input = [self.locationInput.text!, self.linkInput.text!]
            
            updateInMain {
                self.indicator.stopAnimating()
                self.enableUI(enable: true)
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func alertFailure() {
        indicator.stopAnimating()
        enableUI(enable: true)
        let alert = UIAlertController(title: "Location Error", message:
            "There was an error finding your location.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func enableUI(enable: Bool) {
        locationInput.isEnabled = enable
        locationInput.alpha = enable ? 1.0 : 0.5
        linkInput.isEnabled = enable
        linkInput.alpha = enable ? 1.0 : 0.5
        postButton.isEnabled = enable
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
