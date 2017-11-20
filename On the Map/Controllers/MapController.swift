//
//  MapController.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/14/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
    
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("callout")
        if control == view.rightCalloutAccessoryView {
            if let url = view.annotation?.subtitle! {
               UIApplication.shared.open(URL(string: url)!, options: [String: Any](), completionHandler: nil)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("callout")
        let urlString = view.annotation?.subtitle!
        let url = URL(string: urlString!)

        if let url = url {
            UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
        }
    }
    
}
