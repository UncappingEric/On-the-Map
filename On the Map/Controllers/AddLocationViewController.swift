//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/14/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var linkInput: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var postButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postButton.layer.cornerRadius = 5.0
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showPost" {
            errorLabel.text = ""
            enableUI(enable: false)
            
            if locationInput.text != "" && linkInput.text != "" {
                //post info
                enableUI(enable: true)
                return true
            }
            
            enableUI(enable: true)
            errorLabel.text = "Missing location and/or link."
            return false
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPost" {
            let controller = segue.destination as! SuccessfulPostController
            controller.locationInput = locationInput.text
            controller.linkInput = linkInput.text
        }
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
