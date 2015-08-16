//
//  CartViewController.swift
//  MoltinSwiftExample
//
//  Created by Dylan McKee on 15/08/2015.
//  Copyright (c) 2015 Moltin. All rights reserved.
//

import UIKit
import Moltin
import SwiftSpinner

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let CART_CELL_REUSE_IDENTIFIER = "CartTableViewCell"
    
    @IBOutlet weak var tableView:UITableView?
    @IBOutlet weak var totalLabel:UILabel?
    
    private var cartData:NSDictionary?
    private var cartProducts:NSArray?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Cart"
        
        totalLabel?.text = ""
        
        refreshCart()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func refreshCart() {
        SwiftSpinner.show("Updating cart")
        
        // Get the cart contents from Moltin API
        Moltin.sharedInstance().cart.getContentsWithsuccess({ (response) -> Void in
            // Got cart contents succesfully!
            // Set local var's
            self.cartData = response
            self.cartProducts = self.cartData?.valueForKeyPath("result.contents") as? NSArray
            
            // Reset cart total
            if let cartPriceString:NSString = self.cartData?.valueForKeyPath("result.totals.post_discount.formatted.with_tax") as? NSString {
                self.totalLabel?.text = cartPriceString as String

            }
            
            // Hide loading UI
            SwiftSpinner.hide()
            
            // And reload table of cart items...
            self.tableView?.reloadData()
            
        }, failure: { (response, error) -> Void in
            // Something went wrong; hide loading UI and warn user
            
            
        })
        

        
    }

    // MARK: - TableView Data source & Delegate
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (cartProducts != nil) {
            return cartProducts!.count
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CART_CELL_REUSE_IDENTIFIER, forIndexPath: indexPath) as! CollectionTableViewCell
        
        let row = indexPath.row
        
        
        return cell
    }
    

    
    func tableView(_tableView: UITableView,
        willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            if cell.respondsToSelector("setSeparatorInset:") {
                cell.separatorInset = UIEdgeInsetsZero
            }
            if cell.respondsToSelector("setLayoutMargins:") {
                cell.layoutMargins = UIEdgeInsetsZero
            }
            if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
                cell.preservesSuperviewLayoutMargins = false
            }
    }
    
    
}

