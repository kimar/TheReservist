//
//  StoresViewController.swift
//  TheReservist
//
//  Created by Marcus Kida on 23/09/2014.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class StoresViewController: UITableViewController {

    var stores: Array<JSON>?
    var availabilities: Dictionary<String, JSON> = [:]
    var selectedIndex: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "performReload", forControlEvents: UIControlEvents.ValueChanged)
        performReload()
    }
    
    func performReload () {
        HUDController.sharedController.contentView = HUDContentView.TextView(text: "Refreshing…")
        HUDController.sharedController.show()
        loadStores(NSLocale.currentLocale())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = stores?.count {
            return count
        }
        return 0
    }
    
    func loadStores(locale: NSLocale) {
        let localeParams = countryLocale(locale)
        Alamofire.request(.GET, "https://reserve.cdn-apple.com/\(localeParams.country)/\(localeParams.localeIdentifier)/reserve/iPhone/stores.json")
            .response { (request, response, data, error) in
                
                if let errorDesc = error?.localizedDescription {
                    self.presentErrorAlert(errorDesc)
                    self.hideHud()
                    return
                }
                
                if let statusCode = response?.statusCode {
                    self.presentErrorAlert("Store for your Country has not been found.")
                    self.hideHud()
                    return
                }
                
                let json = JSON(data: data! as NSData)
                if let stores = json["stores"].arrayValue {
                    objc_sync_enter(self)
                    self.stores = stores
                    objc_sync_exit(self)
                }
                
                self.loadAvailabilities(locale)
        }
    }
    
    func loadAvailabilities(locale: NSLocale) {
        let localeParams = countryLocale(locale)
        Alamofire.request(.GET, "https://reserve.cdn-apple.com/\(localeParams.country)/\(localeParams.localeIdentifier)/reserve/iPhone/availability.json")
            .response { (request, response, data, error) in
                
                if let errorDesc = error?.localizedDescription {
                    self.presentErrorAlert(errorDesc)
                    self.hideHud()
                    return
                }
                
                if let statusCode = response?.statusCode {
                    self.presentErrorAlert("Products for your Country have not been found.")
                    self.hideHud()
                    return
                }
                
                let json = JSON(data: data! as NSData)
                if let availabilities = json.dictionaryValue {
                    objc_sync_enter(self)
                    self.availabilities = availabilities;
                    objc_sync_exit(self)
                }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
                self.hideHud()
        }
    }
    
    func countryLocale(locale: NSLocale) -> (country: String, localeIdentifier: String) {
        let country: String = locale.objectForKey(NSLocaleCountryCode) as String
        let localeIdentifier = locale.localeIdentifier
        return (country, localeIdentifier)
    }
    
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: "An error occured when loading your Data: \(message)", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func hideHud() {
        HUDController.sharedController.hide()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        objc_sync_enter(self)
        if let store = stores?[indexPath.row] {
            cell.textLabel?.text = store["storeName"].stringValue
        }
        objc_sync_exit(self)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedIndex = indexPath
        self.performSegueWithIdentifier("PartsSegue", sender: self)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "PartsSegue" {
            let dest = segue.destinationViewController as PartsViewController
            if let storeNumber = self.stores?[self.selectedIndex!.row]["storeNumber"].stringValue {
                dest.parts = self.availabilities[storeNumber] as JSON?
            }
        }
    }

}
