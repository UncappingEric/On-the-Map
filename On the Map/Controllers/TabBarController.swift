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
        
        ParseClient.sharedInstance().getPostedData(self)
    }
    
    func getMap() -> MKMapView {
        return ((viewControllers![0] as? MapController)?.mapView)!
    }
    
    @IBAction func refresh() {
        getMap().removeAnnotations(ParseClient.sharedInstance().annotations)
        
        ParseClient.sharedInstance().getPostedData(self)
    }
    
    @IBAction func logout() {
        UdacityClient.sharedInstance().logOff(hostView: self)
    }
}
