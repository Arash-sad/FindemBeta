//
//  TrainerSocialNetworkingViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 4/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

protocol TrainerSocialNetworkingViewControllerDelegate {
    func saveInstagramUserId(instagramId:String)
}

class TrainerSocialNetworkingViewController: UIViewController {

    @IBOutlet weak var instagramIdTextField: UITextField!
    
    var instagramId:String?
    var tempInstagramId = ""
    var delegate:TrainerSocialNetworkingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.instagramId != "" {
            self.tempInstagramId = self.instagramId!
        }
        instagramIdTextField.text = self.tempInstagramId
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func saveBarButtonItemTapped(sender: UIBarButtonItem) {
        if instagramIdTextField.text == "" {
            alert("", message: "Please enter the User ID first.")
        }
        else {
            // remove all leading and trailing white spaces
            tempInstagramId = instagramIdTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if let delegate = self.delegate {
                delegate.saveInstagramUserId(self.tempInstagramId)
            }
            //MARK: Save Instagram User ID to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.tempInstagramId, forKey: "instagramUserId")
            user!.saveInBackgroundWithBlock(nil)
            
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    @IBAction func checkInstagramButtonTapped(sender: UIButton) {
        // remove all leading and trailing white spaces
        tempInstagramId = instagramIdTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        if tempInstagramId == "" {
            alert("", message: "Please enter the User ID first.")
        }
        else {
                let instagramHooks = "instagram://user?username=\(tempInstagramId)"
                let instagramUrl = NSURL(string: instagramHooks)
                if UIApplication.sharedApplication().canOpenURL(instagramUrl!)
                {
                    UIApplication.sharedApplication().openURL(instagramUrl!)
                    
                } else {
                    //redirect to safari because the user doesn't have Instagram
                    UIApplication.sharedApplication().openURL(NSURL(string: "http://instagram.com/\(tempInstagramId)")!)
                }
            
        }
    }
    
    //MARK: - Alert
    func alert(messageTitle: String, message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


}
