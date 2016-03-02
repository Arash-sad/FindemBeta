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
        self.homeButton.layer.cornerRadius = self.homeButton.frame.height / 3
        self.homeButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.homeButton.layer.borderWidth = 1.0
        
        self.searchButton.layer.cornerRadius = self.searchButton.frame.height / 3
        self.searchButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.searchButton.layer.borderWidth = 1.0
        
        self.messageButton.layer.cornerRadius = self.messageButton.frame.height / 3
        self.messageButton.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).CGColor
        self.messageButton.layer.borderWidth = 1.0
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
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("StartUpVC")
        let transition = CATransition()
        transition.type = kCATransitionFade
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.window?.setRootViewController(vc,transition: transition)
        // Log Out from Facebook and go back to startup page
        PFUser.logOut()
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
