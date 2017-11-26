//
//  TableViewController.swift
//  On the Map
//
//  Created by Eric Cajuste on 11/14/17.
//  Copyright © 2017 Cajuste. All rights reserved.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    // MARK: Delegate Functions
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let urlString = StudentInformation.locations[indexPath.row].url else {
            let alert = UIAlertController(title: "URL Error", message:
                "No URL to Open.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        let url = URL(string: urlString)!
        tableView.deselectRow(at: indexPath, animated: true)

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
        } else {
            let alert = UIAlertController(title: "URL Error", message:
                "Error opening up ill-formatted URL.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = StudentInformation.locations
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
        let info = table[indexPath.row]
        
        if let first = info.first, let last = info.last {
            cell.textLabel?.text = "\(first) \(last)"
        } else {
            cell.textLabel?.text = "Nilly Null"
        }
        
        if let url = info.url {
            cell.detailTextLabel?.text = url
        } else {
            cell.detailTextLabel?.text = "www.nilly-null.com"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInformation.locations.count
    }
    
}
