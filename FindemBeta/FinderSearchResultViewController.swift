//
//  FinderSearchResultViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 26/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse
import MapKit

class FinderSearchResultViewController: UIViewController {
    
    var trainerArray:[PFUser] = []
    var refinedtrainerArray:[PFUser] = []
    var trainingType = ""
    var refinedGender = "any"
    var currentLocation = PFGeoPoint?()
    var trainerType = "club"
    var clubDistance = 1.5
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        print(clubDistance)
        print(trainerType)
        if trainerArray == [] {
            // Activity Indicator
            let loadView = UIView.loadFromNibNamed("LoadView")
            loadView?.center = view.center
            view.addSubview(loadView!)
            
            let query = PFUser.query()
            query!.whereKey("trainingTypes", equalTo:trainingType)
            // Different queries for mobile and club trainers
            if trainerType == "club" {
                query!.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> () in
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) users.")
                        // Do something with the found objects
                        if let objects = objects {
                            for object in objects {
                                //Check trainers who cover user's current location
                                let lat = object.objectForKey("clubLatitude") as? Double ?? 38.018312
                                let long =  object.objectForKey("clubLongitude") as? Double ?? 51.412430
                                let location = PFGeoPoint(latitude: lat, longitude: long)
                                let distanceBetween = location.distanceInKilometersTo(self.currentLocation)
                                if self.clubDistance >= distanceBetween {
                                    let trainer = object as? PFUser
                                    self.trainerArray.append(trainer!)
                                }
                            }
                            self.refinedtrainerArray = self.trainerArray
                        }
                    }
                    else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    self.tableView.reloadData()
                    self.animateTable()
                    loadView!.removeFromSuperview()
                }
            }
            else if trainerType == "mobile" {
                query!.whereKey("location", nearGeoPoint: self.currentLocation!, withinKilometers: 50)
                query!.findObjectsInBackgroundWithBlock {
                    (objects: [PFObject]?, error: NSError?) -> () in
                    if error == nil {
                        // The find succeeded.
                        print("Successfully retrieved \(objects!.count) users.")
                        // Do something with the found objects
                        if let objects = objects {
                            for object in objects {
                                //Check trainers who cover user's current location
                                let location = object.objectForKey("location") as? PFGeoPoint
                                let distance = object.objectForKey("distance") as? Double
                                let distanceBetween = location?.distanceInKilometersTo(self.currentLocation)
                                if distance >= distanceBetween {
                                    let trainer = object as? PFUser
                                    self.trainerArray.append(trainer!)
                                }
                            }
                            self.refinedtrainerArray = self.trainerArray
                        }
                    }
                    else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    self.tableView.reloadData()
                    self.animateTable()
                    loadView!.removeFromSuperview()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    // Animate tableView
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions.TransitionNone, animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRefineSearch" {
            let navigationController = segue.destinationViewController as? UINavigationController
            let refineSearchVC = navigationController!.topViewController as? FinderRefineSearchViewController
            
            if let vc = refineSearchVC {
                vc.delegate = self
            }
        }
        else if segue.identifier == "showTrainerProfile" {
            let profileVC = segue.destinationViewController as? FinderTrainerProfileViewController
            
            if let vc = profileVC {
                let indexPath = self.tableView.indexPathForSelectedRow
                let thisTrainer = self.refinedtrainerArray[indexPath!.row]
                vc.trainer = thisTrainer
            }
        }
    }


    @IBAction func refineSearchBarButtonItemPressed(sender: UIBarButtonItem) {
        
    }

}

// MARK: - UITableViewDataSource and UITableViewDelegate
extension FinderSearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.refinedtrainerArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! SearchResultTableViewCell
        
        cell.nameLabel.text = self.refinedtrainerArray[indexPath.row].objectForKey("firstName") as? String
        let imageFile = self.refinedtrainerArray[indexPath.row].objectForKey("picture") as? PFFile
        imageFile!.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                cell.trainerImageView.image = UIImage(data: data)!
            }
        })
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showTrainerProfile", sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - FinderRefineSearchViewControllerDelegate
extension FinderSearchResultViewController: FinderRefineSearchViewControllerDelegate {
    func refineSerch(gender: String) {
        self.refinedGender = gender
        
        //TEMP: Refine Search Result
        if refinedGender != "any" {
            self.refinedtrainerArray = []
            for trainer in self.trainerArray {
                if trainer.objectForKey("gender") as? String == self.refinedGender {
                    self.refinedtrainerArray.append(trainer)
                }
            }
        }
        else {
            self.refinedtrainerArray = self.trainerArray
        }
        self.tableView.reloadData()
    }
}

//MARK: - Load from Nib file
extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}
