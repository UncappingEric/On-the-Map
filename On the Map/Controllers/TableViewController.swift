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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let urlString = ParseClient.sharedInstance().locations[indexPath.row].url!
        let url = URL(string: urlString)

        if let url = url {
            UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let table = ParseClient.sharedInstance().locations
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
        let info = table[indexPath.row]
        
        cell.textLabel?.text = "\(info.first!) \(info.last!)"
        cell.detailTextLabel?.text = info.url!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseClient.sharedInstance().locations.count
    }
    
}
