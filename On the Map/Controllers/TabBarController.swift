//
//  TabBarController.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/14/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TabBarController: UITabBarController {
    
    var table: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table   = (viewControllers![1] as? TableViewController)?.tableView
        
        ParseClient.sharedInstance().getPostedData() { (success, error, results) in
            guard success else {
                print(error!)
                StudentInformation.locations = [StudentInformation]()
                updateInMain {
                    self.showFailureAlert()
                }
                return
            }
            self.storeAndShow(results!)
        }
    }
    
    func storeAndShow(_ dictionary: [[String: Any]]) {
        self.getMap().removeAnnotations(ParseClient.sharedInstance().annotations)
        ParseClient.sharedInstance().storeStudentLocations(dictionary)
        ParseClient.sharedInstance().generateAnnotations()
        
        ParseClient.sharedInstance().getStudentLocation({ (success, error) in
        })
        
        updateInMain {
            self.getMap().addAnnotations(ParseClient.sharedInstance().annotations)
            self.table?.reloadData()
        }
    }
    
    func getMap() -> MKMapView {
        return ((viewControllers![0] as? MapController)?.mapView)!
    }
    
    @IBAction func refresh() {
        getMap().removeAnnotations(ParseClient.sharedInstance().annotations)
        
        ParseClient.sharedInstance().getPostedData() { (success, error, results) in
            guard success else {
                print(error!)
                StudentInformation.locations = [StudentInformation]()
                updateInMain {
                    self.showFailureAlert()
                }
                return
            }
            self.storeAndShow(results!)
        }
    }
    
    func showFailureAlert() {
        let alert = UIAlertController(title: "Data Error", message:
            "Error retriving data.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout() {
        UdacityClient.sharedInstance().logOff { (success, error) in
            guard success else {
                print(error!)
                let alert = UIAlertController(title: "Logoff Error", message:
                    "There was an issue logging off.", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            updateInMain {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
