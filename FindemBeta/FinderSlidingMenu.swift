//
//  FinderSlidingMenu.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 4/01/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse


class FinderSlidingMenu: UIView {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    override func awakeFromNib() {
        // Setup buttons
        let homeImage = UIImage(named: "reset")
        homeButton.setImage(homeImage, forState: UIControlState.Normal)
        homeButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 20, right: 15)
        
        homeButton.setTitle("Home", forState: UIControlState.Normal)
        homeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        homeButton.titleEdgeInsets = UIEdgeInsets(top: 60, left: -homeImage!.size.width, bottom: 0, right: 0.0)
        
        let searchImage = UIImage(named: "search")
        searchButton.setImage(searchImage, forState: UIControlState.Normal)
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 20, right: 15)
        
        searchButton.setTitle("Search", forState: UIControlState.Normal)
        searchButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        searchButton.titleEdgeInsets = UIEdgeInsets(top: 60, left: -searchImage!.size.width, bottom: 0, right: 0.0)
        
        let connectionsImage = UIImage(named: "connections")
        messageButton.setImage(connectionsImage, forState: UIControlState.Normal)
        messageButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 20, right: 15)
        
        messageButton.setTitle("Connections", forState: UIControlState.Normal)
        messageButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        messageButton.titleEdgeInsets = UIEdgeInsets(top: 60, left: -connectionsImage!.size.width, bottom: 0, right: 0.0)
    }
    
    @IBAction func homeButtonTapped(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
        let transition = CATransition()
        transition.type = kCATransitionFade
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.setRootViewController(vc,transition: transition)
    }
    
    @IBAction func searchButtonTapped(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FinderHomeNavController")
        let transition = CATransition()
        transition.type = kCATransitionFade
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.setRootViewController(vc,transition: transition)
    }
    
    @IBAction func messagesButtonTapped(sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("navFinderMessages")
        let transition = CATransition()
        transition.type = kCATransitionFade
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.setRootViewController(vc,transition: transition)
    }
    
    @IBAction func logoutButtonTapped(sender: UIButton) {
        logOutAlert("Log Out",message: "Are you sure?")
    }
    
    //MARK: - Log Out Alert
    func logOutAlert(messageTitle: String, message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Log Out", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
            // Go To StartUp ViewController
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
            let transition = CATransition()
            transition.type = kCATransitionFade
            (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.setRootViewController(vc,transition: transition)
            // Log Out from Facebook and go back to startup page
            PFUser.logOut()
        }))
        let parentViewController: UIViewController = UIApplication.sharedApplication().windows[1].rootViewController!
        parentViewController.presentViewController(alert, animated: true, completion: nil)
    }

}

extension UIWindow {
    
    func setRootViewController(newRootViewController: UIViewController, transition: CATransition? = nil) {
        
        let previousViewController = rootViewController
        
        if let transition = transition {
            // Add the transition
            layer.addAnimation(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled() {
            UIView.animateWithDuration(CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKindOfClass(transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismissViewControllerAnimated(false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
}
