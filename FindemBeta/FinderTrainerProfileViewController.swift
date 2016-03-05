//
//  FinderTrainerProfileViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 9/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse
import MapKit

class FinderTrainerProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var connectBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var trainer: Trainer?
    var trainingTypesArray: [String]?
    var qualificationsArray: [String]?
    var trainingTypes = ""
    var qualifications = ""
    var isConnected = false
    var trainerType = "club"
    var weekdaysSessionTimes = ""
    var weekendSessionTimes = ""
    var hideConnectBarButtonItem = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Disable tableView row selection
        tableView.allowsSelection = false
        
        self.trainingTypesArray = self.trainer!.trainingTypes ?? []
        for trainingType in self.trainingTypesArray! {
            self.trainingTypes += trainingType
            self.trainingTypes += "\n"
        }
        
        self.qualificationsArray = self.trainer!.qualifications ?? []
        for qualification in self.qualificationsArray! {
            self.qualifications += qualification
            self.qualifications += "\n"
        }
        
        // Disable connectBarButtonItem if user and trainer are the same person
        if PFUser.currentUser()?.objectId == trainer!.id {
            self.connectBarButtonItem.enabled = false
        }
        
        // Hide connectBarButtonItem if segue is "showTrainerProfileFromMessages"
        if self.hideConnectBarButtonItem == true {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        // Get Session Times
        if let sessionTimes = self.trainer!.sessionTimes {
            if sessionTimes.uppercaseString.characters.contains("A") {
                self.weekdaysSessionTimes += " Mornings,"
            }
            if sessionTimes.uppercaseString.characters.contains("B") {
                self.weekdaysSessionTimes += " Afternoons,"
            }
            if sessionTimes.uppercaseString.characters.contains("C") {
                self.weekdaysSessionTimes += " Evenings"
            }
            if sessionTimes.uppercaseString.characters.contains("X") {
                self.weekendSessionTimes += " Mornings,"
            }
            if sessionTimes.uppercaseString.characters.contains("Y") {
                self.weekendSessionTimes += " Afternoons,"
            }
            if sessionTimes.uppercaseString.characters.contains("Z") {
                self.weekendSessionTimes += " Evenings"
            }
            if self.weekdaysSessionTimes.characters.last == "," {
                self.weekdaysSessionTimes = String(self.weekdaysSessionTimes.characters.dropLast(1))
            }
            if self.weekendSessionTimes.characters.last == "," {
                self.weekendSessionTimes = String(self.weekendSessionTimes.characters.dropLast(1))
            }
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
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if trainerType == "club" {
            return 2
        }
        else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
                    let cellIdentifier = "firstTrainerProfile"
                    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! FirstTrainerProfileTableViewCell
            
            // Setup profileImageView
            cell.profilePictureImageView.layer.borderColor = UIColor.whiteColor().CGColor
            cell.profilePictureImageView.layer.borderWidth = 2.0
            cell.profilePictureImageView.layer.cornerRadius = cell.profilePictureImageView.frame.height / 2
            cell.profilePictureImageView.layer.masksToBounds = true
            
            // Add target for instagram button
            cell.instagramButton.addTarget(self, action: "openInstagram:", forControlEvents: .TouchUpInside)
            
            if let instaId = self.trainer!.instagramUserId {
                if instaId == "" {
                    cell.instagramButton.enabled = false
                }
            }
            else {
                cell.instagramButton.enabled = false
            }
            
            // Display trainer data
            self.trainer!.getPhoto({
                image in
                cell.profilePictureImageView.image = image
                cell.backgroundImageView.image = image
            })
            cell.nameLabel.text = self.trainer!.name
            cell.descriptionTextView.layer.cornerRadius = 5
            cell.descriptionTextView.text = self.trainer!.longDescription
            cell.trainingTypesTextView.layer.cornerRadius = 5
            cell.trainingTypesTextView.text = self.trainingTypes
            cell.qualificationsTextView.layer.cornerRadius = 5
            cell.qualificationsTextView.text = self.qualifications
            if let yearsExperience = self.trainer!.yearsExperience {
                if yearsExperience == 0 {
                    cell.experienceLabel.text = "Less than a year"
                }
                else if yearsExperience == 1 {
                    cell.experienceLabel.text = "1 year"
                }
                else {
                    cell.experienceLabel.text = ("\(yearsExperience) years")
                }
            }
            cell.achievementsTextView.layer.cornerRadius = 5
            cell.achievementsTextView.text = self.trainer!.achievements
            cell.weekdaysLabel.text = self.weekdaysSessionTimes
            cell.weekendsLabel.text = self.weekendSessionTimes
            
            return cell
        }
        else {
                    let cellIdentifier = "secondTrainerProfile"
                    let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SecondTrainerProfileTableViewCell
            
            cell.clubNameLabel.text = self.trainer!.clubName
            if let clubAddress = trainer!.clubAddress {
                if clubAddress.count == 4 {
                    cell.clubAddressLabel.text = "\(clubAddress[0])\n\(clubAddress[1]) \(clubAddress[2]) \(clubAddress[3])"
                }
            }
            // Setup mapView
            cell.mapView.delegate = self
            cell.mapView.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.mapView.layer.borderWidth = 2.0
            //remove map overlays and annotations
            let annotationToRemove = cell.mapView.annotations
            cell.mapView.removeAnnotations(annotationToRemove)
            
            let latitude = trainer!.clubLatitude
            let longitude = trainer!.clubLongitude
            let location = CLLocationCoordinate2DMake(latitude!, longitude!)
            
            let span = MKCoordinateSpanMake(0.03, 0.03)
            let region = MKCoordinateRegion(center: location, span: span)
            cell.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.trainer!.name
            annotation.subtitle = self.trainer!.clubName
            cell.mapView.addAnnotation(annotation)
            
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 0 {
            return 950.0
        }
        else {
            return 400.0
        }
    }
    
    func openInstagram(sender: UIButton){
        if let instagramUserId = self.trainer!.instagramUserId {
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
    
    @IBAction func connectBarButtonItemTapped(sender: UIBarButtonItem) {
        let query = PFQuery(className:"Action")
        query.whereKey("byUser", equalTo: currentUser()!.id)
        query.whereKey("toTrainer", equalTo: trainer!.id)
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
