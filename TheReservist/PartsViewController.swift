//
//  PartsViewController.swift
//  TheReservist
//
//  Created by Marcus Kida on 23/09/2014.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

import UIKit

class PartsViewController: UITableViewController {

    var parts: JSON?
    let redColor = UIColor(red: 87/255, green: 194/255, blue: 87/255, alpha: 1.0)
    let greenColor = UIColor(red: 194/255, green: 87/255, blue: 87/255, alpha: 1.0)
    let products = Products()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if let count = self.parts?.dictionaryValue?.count {
            return count
        }
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        var partNumber = ""
        var available = false

        if let keys = self.parts?.dictionaryValue?.keys {
            partNumber = keys.array[indexPath.row] as String
        }

        if let values = self.parts?.dictionaryValue?.values {
            available = values.array[indexPath.row].boolValue
        }
        
        if let name = products.name(partNumber) {
            var availableString = available ? "Reservation is available." : "Reservation is not available."
            if let size = products.size(partNumber) {
                if let color = products.color(partNumber) {
                    cell.textLabel?.text = "\(name) (\(color), \(size))"
                    
                    cell.detailTextLabel?.textColor = available ? redColor : greenColor
                    cell.detailTextLabel?.text = availableString
                }
            }
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
