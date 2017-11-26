//
//  SuccessfulPostViewController.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/20/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SuccessfulPostController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var finish: UIButton!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var input: [String]?
    
    // MARK: Lifecycle Function
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finish.layer.cornerRadius = 5.0
        
        let location = StudentInformation.translatedCoords
        let student = UdacityClient.sharedInstance().userInfo
        
        let coordinate = CLLocationCoordinate2D(latitude: location![0], longitude: location![1])
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(student!["first_name"]!) \(student!["last_name"]!)"
        annotation.subtitle = input![1]
        
        map.addAnnotation(annotation)
        zoomOnPin(coordinate)
    }
    
    func zoomOnPin(_ coordinate: CLLocationCoordinate2D) {
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    func alertFailure() {
        indicator.stopAnimating()
        let alert = UIAlertController(title: "Posting Error", message:
            "There was an error posting your location.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Button Actions
    
    @IBAction func post(_ sender: Any) {
        indicator.startAnimating()
        
        ParseClient.sharedInstance().postStudentInfo(input!) { (success, error) in
            guard success else {
                print(error!)
                updateInMain {
                    self.alertFailure()
                }
                return
            }
            
            updateInMain {
                self.indicator.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
