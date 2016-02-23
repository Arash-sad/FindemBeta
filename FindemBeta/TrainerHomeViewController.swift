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
    
    var expirationDate: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
        self.presentViewController(vc, animated: true, completion: nil)
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
    
}
