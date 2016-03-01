//
//  TrainerHomeViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 2/11/2015.
//  Copyright (c) 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class TrainerHomeViewController: UIViewController, TrainerInAppPurchaseViewControllerDelegate {

    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var subscriptionButton: UIButton!
    
    var expirationDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Setup buttons
        self.profileButton.layer.cornerRadius = self.profileButton.frame.height / 3
        self.profileButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.profileButton.layer.borderWidth = 1.0
        self.messageButton.layer.cornerRadius = self.messageButton.frame.height / 3
        self.messageButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.messageButton.layer.borderWidth = 1.0
        self.subscriptionButton.layer.cornerRadius = self.subscriptionButton.frame.height / 3
        self.subscriptionButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.subscriptionButton.layer.borderWidth = 1.0
        
        // Save preferred App direction(Trainer or User) to NSUserDefaults
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("Trainer", forKey: "appDirection")
        
        expirationDate = PFUser.currentUser()?.objectForKey("expirationDate") as? NSDate ?? NSDate()
        
        if NSDate().timeIntervalSince1970 >= expirationDate?.timeIntervalSince1970 {
            self.profileButton.enabled = false
            self.messageButton.enabled = false
        }
        else {
            self.profileButton.enabled = true
            self.messageButton.enabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBarButtonItem(sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
        let transition = CATransition()
        transition.type = kCATransitionFade
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.setRootViewController(vc,transition: transition)
    }
    @IBAction func logOutBarButtonItem(sender: UIBarButtonItem) {
        logOutAlert("Log Out",message: "Are you sure?")
    }
    
    @IBAction func profileButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("showProfileSegue", sender: nil)
    }
    @IBAction func messagesButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("showMessagesSegue", sender: nil)
    }
    @IBAction func subscriptionButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("showSubscription", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSubscription" {
            let inAppVC = segue.destinationViewController as? TrainerInAppPurchaseViewController
            
            if let vc = inAppVC {
                vc.delegate = self
            }
        }
    }
    
    // TrainerInAppPurchaseViewControllerDelegate method
    func enableProfileAndMessages() {
        self.profileButton.enabled = true
        self.messageButton.enabled = true
    }
    
    //MARK: - Log Out Alert
    func logOutAlert(messageTitle: String, message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
            // Go To StartUp ViewController
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
            let transition = CATransition()
            transition.type = kCATransitionFade
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.setRootViewController(vc,transition: transition)
            // Log Out from Facebook and go back to startup page
            PFUser.logOut()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
