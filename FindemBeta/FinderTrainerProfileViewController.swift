//
//  FinderTrainerProfileViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 9/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class FinderTrainerProfileViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var longDescriptionTextView: UITextView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var trainingTypesTextView: UITextView!
    @IBOutlet weak var qualificationTextView: UITextView!
    @IBOutlet weak var yearsExperienceLabel: UILabel!
    @IBOutlet weak var achievementsTextView: UITextView!
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var connectBarButtonItem: UIBarButtonItem!
    
    var trainer: PFUser?
    var trainingTypesArray: [String]?
    var qualificationsArray: [String]?
    var trainingTypes = ""
    var qualifications = ""
    var isConnected = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize = self.containerView.frame.size
        // Do any additional setup after loading the view.
        
        // Setup profileImageView
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImageView.layer.borderWidth = 2.0
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.layer.masksToBounds = true
        
        // Display trainer data 
        nameLabel.text = self.trainer!.objectForKey("firstName") as? String
        self.longDescriptionTextView.layer.cornerRadius = 5
        self.longDescriptionTextView.text = self.trainer!.objectForKey("longDescription") as? String
        self.trainingTypesArray = self.trainer!.objectForKey("trainingTypes") as? [String] ?? []
        for trainingType in self.trainingTypesArray! {
            self.trainingTypes += trainingType
            self.trainingTypes += "\n"
        }
        self.trainingTypesTextView.layer.cornerRadius = 5
        self.trainingTypesTextView.text = self.trainingTypes
        self.qualificationsArray = self.trainer!.objectForKey("qualifications") as? [String] ?? []
        for qualification in self.qualificationsArray! {
            self.qualifications += qualification
            self.qualifications += "\n"
        }
        self.qualificationTextView.layer.cornerRadius = 5
        self.qualificationTextView.text = self.qualifications
        if let yearsExperience = self.trainer!.objectForKey("yearsExperience") as? Int {
            if yearsExperience == 0 {
                self.yearsExperienceLabel.text = "Less than a year"
            }
            else if yearsExperience == 1 {
                self.yearsExperienceLabel.text = "1 year"
            }
            else {
                self.yearsExperienceLabel.text = ("\(yearsExperience) years")
            }
        }
        self.achievementsTextView.layer.cornerRadius = 5
        self.achievementsTextView.text = self.trainer!.objectForKey("achievements") as? String
        let imageFile = self.trainer!.objectForKey("picture") as? PFFile
        imageFile!.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                self.profileImageView.image = UIImage(data: data)!
            }
        })
        
        if PFUser.currentUser()?.objectId == trainer!.objectId! {
            self.connectBarButtonItem.enabled = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showConnection" {
            let connectionVC = segue.destinationViewController as? FinderConnectionViewController
            connectionVC?.trainer = self.trainer
            connectionVC?.isConnected = self.isConnected
        }
    }
    
    
    @IBAction func instagramButtonTapped(sender: UIButton) {
        let instagramUserId = self.trainer!.objectForKey("instagramUserId") as? String
        print(instagramUserId)
        if instagramUserId == "" {
            self.instagramButton.enabled = false
        }
        else {
            let instagramHooks = "instagram://user?username=\(instagramUserId)"
            let instagramUrl = NSURL(string: instagramHooks)
            if UIApplication.sharedApplication().canOpenURL(instagramUrl!)
            {
                UIApplication.sharedApplication().openURL(instagramUrl!)
                
            } else {
                //redirect to safari because the user doesn't have Instagram
                UIApplication.sharedApplication().openURL(NSURL(string: "http://instagram.com/\(instagramUserId)")!)
            }
            
        }
    }
    
    @IBAction func connectBarButtonItemPressed(sender: UIBarButtonItem) {
        let query = PFQuery(className:"Action")
        query.whereKey("byUser", equalTo: currentUser()!.id)
        query.whereKey("toTrainer", equalTo: trainer!.objectId!)
        query.findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> () in
            if error == nil {
                if objects?.count == 0 {
                    saveConnection(self.trainer!)
                    print("They haven't connected yet!")
                    self.performSegueWithIdentifier("showConnection", sender: nil)
                }
                else if objects?.count == 1 {
                    for object in objects! {
                        // The find succeeded.
                        if object.objectForKey("userAction") as? String == "deleted" {
                            object.setValue("connected", forKey: "userAction")
                            object.setValue(NSDate(), forKey: "lastMessageAt")
                            object.saveInBackgroundWithBlock(nil)
                        }
                        else if object.objectForKey("userAction") as? String == "gameOver" {
                            object.setValue("blocked", forKey: "userAction")
                            object.setValue(NSDate(), forKey: "lastMessageAt")
                            object.saveInBackgroundWithBlock(nil)
                        }
                        else {
                            print("They are already connected!")
                            self.isConnected = true
                        }
                        self.performSegueWithIdentifier("showConnection", sender: nil)
                    }
                }
            }
            else {
                // Log details of the failure
                print("Error-FetchConnections: \(error!) \(error!.userInfo)")
            }
        })
    }

}
