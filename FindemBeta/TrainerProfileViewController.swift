//
//  TrainerProfileViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 9/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse
import MapKit
//import CoreLocation

class TrainerProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource,UIPickerViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var tableView: UITableView!
    
    var editButtonEnabled = false
    
    var name: String?
    var photo: UIImage?
    var gender: String?
    var trainingArray: [String] = []
    var qualificationsArray:[String] = []
//    var coords: PFGeoPoint?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var distance: Double = 10.0
    var descriptionString: String = ""
    var yearsExperience: Int = 0
    var achievements: String = ""
    var favorite: String = ""
    
    let firstCellIdentifier = "firstProfileCell"
    let secondCellIdentifier = "secondProfileCell"
    let thirdCellIdentifier = "thirdProfileCell"
    let fourthCellIdentifier = "fourthProfileCell"
    let fifthCellIdentifier = "fifthProfileCell"
    let sixthCellIdentifier = "sixthProfileCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Disable the tableView selection highlighting
        tableView.allowsSelection = false
        
        //Fetch Details from Parse
        self.name = currentTrainer()?.name
        currentTrainer()?.getPhoto({
            image in
            self.photo = image
        })
        self.gender = currentTrainer()?.gender
        self.trainingArray = (currentTrainer()?.trainingTypes)!
        self.qualificationsArray = (currentTrainer()?.qualifications)!
        self.latitude = (currentTrainer()?.latitude)!
        self.longitude = (currentTrainer()?.longitude)!
        self.distance = (currentTrainer()?.distance)!
        self.descriptionString = (currentTrainer()?.description)!
        self.yearsExperience = (currentTrainer()?.yearsExperience)!
        self.achievements = (currentTrainer()?.achievements)!
        self.favorite = (currentTrainer()?.favorite)!
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editBarButtonItem(sender: UIBarButtonItem) {
        if editButtonEnabled {
            editButtonEnabled = !editButtonEnabled
            self.navigationItem.rightBarButtonItem! = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Done, target: self, action: "editBarButtonItem:")
            // Disable the tableView selection highlighting
            tableView.allowsSelection = false
            self.tableView.reloadData()
        }
        else {
            editButtonEnabled = !editButtonEnabled
            self.navigationItem.rightBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "editBarButtonItem:")
            // Enable the tableView selection highlighting
            tableView.allowsSelection = true
            self.tableView.reloadData()
        }
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showGeneralDetail" {
            let navVC = segue.destinationViewController as? UINavigationController
            let generalVC = navVC!.viewControllers[0] as? TrainerProfileGeneralViewController
            
            generalVC!.name = self.name
            generalVC!.photo = self.photo
            generalVC!.gender = self.gender
        }
        else if segue.identifier == "showTypesOfTraining" {
            let navVC = segue.destinationViewController as? UINavigationController
            let trainingVC = navVC!.viewControllers[0] as? TrainerTrainingTypesViewController
            
            trainingVC?.tempArray = self.trainingArray
        }
        else if segue.identifier == "showQualifications" {
            let navVC = segue.destinationViewController as? UINavigationController
            let qualificationsVC = navVC!.viewControllers[0] as? TrainerQualificationsViewController
            
            qualificationsVC?.tempArray = self.qualificationsArray
            print(qualificationsArray)
        }
        else if segue.identifier == "showRegionDetails" {
            let navVC = segue.destinationViewController as? UINavigationController
            let regionVC = navVC!.viewControllers[0] as? TrainerRegionViewController
            
            regionVC?.latitude = self.latitude
            regionVC?.longitude = self.longitude
            regionVC?.distance = self.distance
        }
        else if segue.identifier == "showDescription" {
            let navVC = segue.destinationViewController as? UINavigationController
            let descVC = navVC!.viewControllers[0] as? TrainerDescriptionViewController
            
            descVC?.descriptionString = self.descriptionString
        }
        else if segue.identifier == "showOtherDetails" {
            let navVC = segue.destinationViewController as? UINavigationController
            let otherVC = navVC!.viewControllers[0] as? TrainerOtherViewController
            
            otherVC?.years = self.yearsExperience
            otherVC?.achievements = self.achievements
            otherVC?.favorite = self.favorite
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.firstCellIdentifier, forIndexPath: indexPath) as! FirstTableViewCell
            
            cell.nameLabel.text = self.name
            cell.imageView?.layer.masksToBounds = true
            cell.imageView?.contentMode = .ScaleAspectFill
            cell.imageView?.image = self.photo
            if editButtonEnabled {
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.secondCellIdentifier, forIndexPath: indexPath) as! SecondTableViewCell
            
            //MARK: load mapView and add annotation and circle overlay
            let location = CLLocationCoordinate2DMake(latitude!, longitude!)
            
            cell.mapView.delegate = self
            
            //remove map overlays and annotations
            let overlays = cell.mapView.overlays
            cell.mapView.removeOverlays(overlays)
            let annotationToRemove = cell.mapView.annotations
            cell.mapView.removeAnnotations(annotationToRemove)
            
            //Draw a circle of 100m radius around user location
            let newCircle = MKCircle(centerCoordinate: location, radius: (self.distance * 1000) as CLLocationDistance)
            
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegion(center: location, span: span)
            cell.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.name
            annotation.subtitle = "Mobile PT"
            cell.mapView.addAnnotation(annotation)
            cell.mapView.addOverlay(newCircle)
            if editButtonEnabled {
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.thirdCellIdentifier, forIndexPath: indexPath) as! ThirdTableViewCell
            cell.trainingTypesPickerView.reloadAllComponents()
            if editButtonEnabled {
                cell.trainingTypesPickerView.userInteractionEnabled = false
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            }
            else {
                cell.trainingTypesPickerView.userInteractionEnabled = true
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.fourthCellIdentifier, forIndexPath: indexPath) as! FourthTableViewCell
            cell.qualificationsPickerView.reloadAllComponents()
            if editButtonEnabled {
                cell.qualificationsPickerView.userInteractionEnabled = false
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            }
            else {
                cell.qualificationsPickerView.userInteractionEnabled = true
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.fifthCellIdentifier, forIndexPath: indexPath) as! FifthTableViewCell
            cell.descriptionTextView.text = self.descriptionString
            if editButtonEnabled {
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.sixthCellIdentifier, forIndexPath: indexPath) as! SixthTableViewCell
            cell.yearsLabel.text = String(self.yearsExperience)
            cell.achievementsTextView.text = self.achievements
            cell.favoriteLabel.text = self.favorite
            if editButtonEnabled {
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editButtonEnabled {
            if indexPath.row == 0 {
                performSegueWithIdentifier("showGeneralDetail", sender: nil)
            }
            else if indexPath.row == 1 {
                performSegueWithIdentifier("showRegionDetails", sender: nil)
            }
            else if indexPath.row == 2 {
                performSegueWithIdentifier("showTypesOfTraining", sender: nil)
            }
            else if indexPath.row == 3 {
                performSegueWithIdentifier("showQualifications", sender: nil)
            }
            else if indexPath.row == 4 {
                performSegueWithIdentifier("showDescription", sender: nil)
            }
            else if indexPath.row == 5 {
                performSegueWithIdentifier("showOtherDetails", sender: nil)
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 150.0
//        if indexPath.row == 0 {
//            return 150.0
//        }
//        else if indexPath.row == 1 {
//            return 150.0
//        }
//        else if indexPath.row == 2 {
//            return 150.0
//        }
//        else if indexPath.row == 3 {
//            return 150.0
//        }
//        else if indexPath.row == 4 {
//            return 150.0
//        }
//        else if indexPath.row == 5 {
//            return 150.0
//        }
//        else {
//            return 70.0
//        }
    }
    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "General Info"
//        }
//        else if section == 1 {
//            return "Types of Training"
//        }
//        else {
//            return "Qualifications"
//    }
    
    // MARK: - PickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return trainingArray.count
        } else {
            return qualificationsArray.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag == 1) {
            return trainingArray[row]
        }
        else {
            return qualificationsArray[row]
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    //Asks the delegate for a renderer object to use when drawing the specified overlay
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        //        if overlay is MKCircle {
        let circle = MKCircleRenderer(overlay: overlay)
        circle.strokeColor = UIColor(red: 0, green: 100, blue: 255, alpha: 1.0)
        circle.fillColor = UIColor(red: 0, green: 100, blue: 255, alpha: 0.1)
        circle.lineWidth = 1
        return circle
        //        }
        //        else {
        //            return nil
        //        }
    }
    
    //MARK: - Unwind Segues
    @IBAction func unwindFromGeneral(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerProfileGeneralViewController, name = sourceViewController.name, photo = sourceViewController.photo, gender = sourceViewController.gender {
                self.name = name
                self.photo = photo
                self.gender = gender
                tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromTraining(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerTrainingTypesViewController, tempArray = sourceViewController.tempArray {
            self.trainingArray = tempArray.sort()
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromQualifications(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerQualificationsViewController, tempArray = sourceViewController.tempArray {
            self.qualificationsArray = tempArray.sort()
            print("@@@")
            print(self.qualificationsArray)
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromRegion(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerRegionViewController, latitude = sourceViewController.latitude, longitude = sourceViewController.longitude, distance = sourceViewController.distance {
            self.latitude = latitude
            self.longitude = longitude
            self.distance = distance
            print("@@@")
            print(self.latitude)
            print(self.longitude)
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromDescription(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerDescriptionViewController, desc = sourceViewController.descriptionString {
            self.descriptionString = desc
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromOther(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerOtherViewController, years = sourceViewController.years, achieve = sourceViewController.achievements, fav = sourceViewController.favorite {
            self.yearsExperience = years
            self.achievements = achieve
            self.favorite = fav
            tableView.reloadData()
        }
    }

}
