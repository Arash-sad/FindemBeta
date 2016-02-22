//
//  TrainerInAppPurchaseViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 17/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import StoreKit
import Parse

protocol TrainerInAppPurchaseViewControllerDelegate {
    func enableProfileAndMessages()
}

class TrainerInAppPurchaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    @IBOutlet weak var tableView: UITableView!
    
    let productIdentifiers = Set(["io.treepi.FindemBeta.yearly1","io.treepi.FindemBeta.monthly1","io.treepi.FindemBeta.threeMonth"])
    var product: SKProduct?
    var productsArray = Array<SKProduct>()
    var expirationDate: NSDate?
    var delegate: TrainerInAppPurchaseViewControllerDelegate?
    
    // priceFormatter is used to show proper, localized currency
    lazy var priceFormatter: NSNumberFormatter = {
        let pf = NSNumberFormatter()
        pf.formatterBehavior = .Behavior10_4
        pf.numberStyle = .CurrencyStyle
        return pf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Retrive Trainer Expiration Date from Parse
        self.expirationDate = PFUser.currentUser()?.objectForKey("expirationDate") as? NSDate ?? NSDate()
        print(self.expirationDate!)
        // Retrieve the IAP information
        requestProductData()
        
//        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "inAppPurchaseCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! InAppPurchaseTableViewCell
        
        cell.displayNameLabel.text = self.productsArray[indexPath.row].localizedTitle
        priceFormatter.locale = self.productsArray[indexPath.row].priceLocale
        cell.priceLabel.text = priceFormatter.stringFromNumber(self.productsArray[indexPath.row].price)
        cell.buyButton.tag = indexPath.row
        cell.buyButton.addTarget(self, action: "buyProduct:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Change the button titile to Renew if already subscribed
        if daysRemainingOnSubscription() > 0 {
            cell.buyButton.setTitle("Renew", forState: UIControlState.Normal)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 66.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 60))
            headerView.backgroundColor = UIColor.grayColor()
            let expirationDateLabel = UILabel(frame: CGRectMake(10, 2, tableView.frame.size.width - 20, 60))
            expirationDateLabel.text = getExpirationDateString()
            expirationDateLabel.textColor = UIColor.whiteColor()
            expirationDateLabel.numberOfLines = 0
            expirationDateLabel.textAlignment = .Center
            expirationDateLabel.backgroundColor = UIColor.clearColor()
            headerView.addSubview(expirationDateLabel)
            
            return headerView
        }
        return nil
    }
    
    // MARK: - In-App Purchases Helper functions
    
    // MARK: Retrieving Product Information
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers:
                self.productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            let alert = UIAlertController(title: "In-App Purchases Not Enabled", message: "Please enable In App Purchase in Settings", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
                
                let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
                if url != nil
                {
                    UIApplication.sharedApplication().openURL(url!)
                }
                
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: { alertAction in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        
        var products = response.products
        
        if (products.count != 0) {
            for var i = 0; i < products.count; i++
            {
                self.product = products[i]
                self.productsArray.append(product!)
            }
            self.tableView.reloadData()
        } else {
            print("No products found")
        }
        
        for product in response.invalidProductIdentifiers
        {
            print("Product not found: \(product)")
        }
    }
    
    // MARK: Requesting Payment
    func buyProduct(sender:UIButton) {
        let payment = SKPayment(product: productsArray[sender.tag])
        SKPaymentQueue.defaultQueue().addPayment(payment)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
    }
    
    // MARK: Delivering Products
    
    //for iOS 8.4:
    //func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!)
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            switch transaction.transactionState {
                
            case SKPaymentTransactionState.Purchased:
                print("Transaction Approved")
                print("Product Identifier: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction)
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case SKPaymentTransactionState.Failed:
                print("Transaction Failed")
                SKPaymentQueue.defaultQueue().finishTransaction(transaction)
                break
            case SKPaymentTransactionState.Deferred:
                break
            default:
                break
            }
        }
    }
    
    func deliverProduct(transaction:SKPaymentTransaction) {
        
        if transaction.payment.productIdentifier == "io.treepi.FindemBeta.yearly1" {
            print("1 Year Product Purchased")
            updateExpirationDate(12)
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "io.treepi.FindemBeta.threeMonth" {
            print("3 Month Product Purchased")
            updateExpirationDate(3)
            // Unlock Feature
        }
        else if transaction.payment.productIdentifier == "io.treepi.FindemBeta.monthly1" {
            print("1 Month Product Purchased")
            updateExpirationDate(1)
            // Unlock Feature
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction){
        print("Finshed Transaction")
    }
    
    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("Remove Transaction")
    }
    
    // MARK: - Calculate Expiration Date
    
    // If there’s an existing subscription, get the remaining days
    func daysRemainingOnSubscription() -> Int {
        let timeInt: NSTimeInterval = self.expirationDate!.timeIntervalSinceDate(NSDate())
        let days = Int(timeInt / 60 / 60 / 24)
        
        if days > 0 {
            return days
        }
        else {
            return 0
        }
        
    }
    
    // Add the lenght of subscription to original expiration date
    func updateExpirationDate(months: Int) {
        var originDate:NSDate!
        if self.daysRemainingOnSubscription() > 0 {
            originDate = self.expirationDate!
        }
        else {
            originDate = NSDate()
        }
        
        let dateComp = NSDateComponents()
        dateComp.month = months
        dateComp.day = 1 // add an extra day
        
        let newExpirationDate =  NSCalendar.currentCalendar().dateByAddingComponents(dateComp, toDate: originDate, options: [])
        
        // Save new Expiration Date to Parse
        let user = PFUser.currentUser()
        user!.setObject(newExpirationDate!, forKey: "expirationDate")
        user!.saveInBackgroundWithBlock(nil)
        // Update expirationDate date
        self.expirationDate = newExpirationDate
        self.tableView.reloadData()
        // Enable Profile and Messages in TrainerHomeViewController
        if let delegate = self.delegate {
            delegate.enableProfileAndMessages()
        }
    }
    
    // Generate the user-facing expiration date
    func getExpirationDateString() -> String {
        if daysRemainingOnSubscription() > 0 {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateFormatter.timeZone = NSTimeZone()
            let dateString = dateFormatter.stringFromDate(self.expirationDate!)
            return "Subscribed! \nExpires: \(dateString) (\(daysRemainingOnSubscription()) Days)"
        }
        else {
            return "Not Subscribed"
        }
    }

}



