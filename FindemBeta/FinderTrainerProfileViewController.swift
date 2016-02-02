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
    
    var trainer: PFUser?
    var trainingTypesArray: [String]?
    var qualificationsArray: [String]?
    var trainingTypes = ""
    var qualifications = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.contentSize = self.containerView.frame.size
        
        // Do any additional setup after loading the view.
        nameLabel.text = self.trainer!.objectForKey("firstName") as? String
        longDescriptionTextView.text = self.trainer!.objectForKey("longDescription") as? String
        self.trainingTypesArray = self.trainer!.objectForKey("trainingTypes") as? [String] ?? []
        for trainingType in self.trainingTypesArray! {
            self.trainingTypes += trainingType
            self.trainingTypes += "\n"
        }
        self.trainingTypesTextView.text = self.trainingTypes
        self.qualificationsArray = self.trainer!.objectForKey("qualifications") as? [String] ?? []
        for qualification in self.qualificationsArray! {
            self.qualifications += qualification
            self.qualifications += "\n"
        }
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
        self.achievementsTextView.text = self.trainer!.objectForKey("achievements") as? String
        let imageFile = self.trainer!.objectForKey("picture") as? PFFile
        imageFile!.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                self.profileImageView.image = UIImage(data: data)!
            }
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chatBarButtonItemPressed(sender: UIBarButtonItem) {
        let query = PFQuery(className:"Action")
        query.whereKey("byUser", equalTo: currentUser()!.id)
        query.whereKey("toTrainer", equalTo: trainer!.objectId!)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                saveConnection(self.trainer!)
                print("They haven't connected yet!")
            } else {
                // The find succeeded.
                if object!.objectForKey("userAction") as? String == "deleted" {
                    object!.setValue("connected", forKey: "userAction")
                    object!.setValue(NSDate(), forKey: "lastMessageAt")
                    object!.saveInBackgroundWithBlock(nil)
                }
                else if object!.objectForKey("userAction") as? String == "gameOver" {
                    object!.setValue("blocked", forKey: "userAction")
                    object!.setValue(NSDate(), forKey: "lastMessageAt")
                    object!.saveInBackgroundWithBlock(nil)
                }
                else {
                    print("They are already connected!")
                }
            }
        }
    }

}
