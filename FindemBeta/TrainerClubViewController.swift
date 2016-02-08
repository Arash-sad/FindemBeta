//
//  TrainerClubViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 8/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

protocol TrainerClubViewControllerDelegate {
    func updateClubName(name: String)
}

class TrainerClubViewController: UIViewController {

    @IBOutlet weak var clubNameTextField: UITextField!
    
    var clubName: String?
//    var latitude: CLLocationDegrees?
//    var longitude: CLLocationDegrees?
    var delegate: TrainerClubViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let name = clubName {
            self.clubNameTextField.text = name
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveBarButtonTapped(sender: UIBarButtonItem) {
        
        self.clubName = self.clubNameTextField.text!
        
        if self.clubNameTextField.text?.isEmptyOrWhitespace() == false{
            if let name = clubName {
                print(name)
                //MARK: Save Description to Parse
                let user = PFUser.currentUser()
                user!.setObject(self.clubName!, forKey: "clubName")
                user!.saveInBackgroundWithBlock(nil)
            }
            
            if let delegate = self.delegate {
                delegate.updateClubName(clubName!)
            }
            
            dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            alert("Empty Club Name", message: "Please enter the club name.")
        }
    }

    //MARK: - Alert
    func alert(messageTitle: String, message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
