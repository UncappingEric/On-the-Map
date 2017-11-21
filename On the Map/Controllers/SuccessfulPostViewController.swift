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
    
    var locationInput: String?
    var linkInput: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        finish.layer.cornerRadius = 5.0
        
        ParseClient.sharedInstance().postStudentInfo(self)
    }
    
    func zoomOnPin(_ coordinate: CLLocationCoordinate2D) {
        indicator.stopAnimating()
        let span = MKCoordinateSpanMake(5, 5)
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
    
    @IBAction func leave(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
