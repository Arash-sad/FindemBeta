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
    //TODO: TEMP
    var name:String?
    var photo:UIImage?
    var trainingArray:[String] = []
    var qualificationsArray:[String] = []
    var coords: PFGeoPoint?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var distance: Double = 10.0
    var descriptionString:String = ""
    var yearsExperience:String = ""
    var achievements:String = ""
    var favorite:String = ""
    
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
        
        //TODO: TEMP
        //Fetch name and photo from Parse
        self.name = currentUser()?.name
        currentUser()?.getPhoto({
            image in
            self.photo = image
        })
        
        //Fetch TrainingTypes from Parse
        if let trainingArrayParse = PFUser.currentUser()!.objectForKey("trainingTypes") {
            trainingArray = trainingArrayParse as! [String]
        }
        
        //Fetch Qualifications from Parse
        if let qualificationsArrayParse = PFUser.currentUser()!.objectForKey("qualifications") {
            qualificationsArray = qualificationsArrayParse as! [String]
        }
        
        //Fetch Location from Parse
        if let coordsParse = PFUser.currentUser()!.objectForKey("location") {
            self.coords = coordsParse as? PFGeoPoint
            self.latitude = coords?.latitude
            self.longitude = coords?.longitude
        }
        else {
            //TODO: What location to set when user has not set it
            self.latitude = 51.50007773
            self.longitude = -0.1246402
        }
        
        //Fetch Distance from Parse
        if let distanceParse = PFUser.currentUser()!.objectForKey("distance") {
            self.distance = distanceParse as! Double
        }
        
        //Fetch Description from Parse
        if let descriptionParse = PFUser.currentUser()!.objectForKey("description") {
            self.descriptionString = descriptionParse as! String
        }
        
        //Fetch Years Experience from Parse
        if let yearsParse = PFUser.currentUser()!.objectForKey("yearsExperience") {
            self.yearsExperience = yearsParse as! String
        }
        
        //Fetch Achievements from Parse
        if let achievementsParse = PFUser.currentUser()!.objectForKey("achievements") {
            self.achievements = achievementsParse as! String
        }
        //Fetch Favorite from Parse
        if let favoriteParse = PFUser.currentUser()!.objectForKey("favorite") {
            self.favorite = favoriteParse as! String
        }
        
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
            //TODO: TEMP
            generalVC!.gName = self.name
            generalVC!.gPhoto = self.photo
        }
        else if segue.identifier == "showTypesOfTraining" {
            let navVC = segue.destinationViewController as? UINavigationController
            let trainingVC = navVC!.viewControllers[0] as? TrainerTrainingTypesViewController
            //TODO: TEMP
            trainingVC?.tempArray = self.trainingArray
        }
        else if segue.identifier == "showQualifications" {
            let navVC = segue.destinationViewController as? UINavigationController
            let qualificationsVC = navVC!.viewControllers[0] as? TrainerQualificationsViewController
            //TODO: TEMP
            qualificationsVC?.tempArray = self.qualificationsArray
            print(qualificationsArray)
        }
        else if segue.identifier == "showRegionDetails" {
            let navVC = segue.destinationViewController as? UINavigationController
            let regionVC = navVC!.viewControllers[0] as? TrainerRegionViewController
            //TODO: TEMP
            regionVC?.latitudeR = self.latitude
            regionVC?.longitudeR = self.longitude
            regionVC?.distance = self.distance
        }
        else if segue.identifier == "showDescription" {
            let navVC = segue.destinationViewController as? UINavigationController
            let descVC = navVC!.viewControllers[0] as? TrainerDescriptionViewController
            //TODO:TEMP
            descVC?.descriptionString = self.descriptionString
        }
        else if segue.identifier == "showOtherDetails" {
            let navVC = segue.destinationViewController as? UINavigationController
            let otherVC = navVC!.viewControllers[0] as? TrainerOtherViewController
            //TODO:TEMP
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
            //TODO: TEMP
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
            
            //MAP
            let location = CLLocationCoordinate2DMake(latitude!, longitude!)
            
            cell.mapView.delegate = self
            
            //remove map overlays
            let overlays = cell.mapView.overlays
            cell.mapView.removeOverlays(overlays)
            
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
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.fourthCellIdentifier, forIndexPath: indexPath) as! FourthTableViewCell
            cell.qualificationsPickerView.reloadAllComponents()
            if editButtonEnabled {
                cell.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            }
            else {
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
            cell.yearsLabel.text = self.yearsExperience
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
    //TODO: TEMP
    @IBAction func unwindFromGeneral(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerProfileGeneralViewController, gName = sourceViewController.gName, gPhoto = sourceViewController.gPhoto {
                self.name = gName
                self.photo = gPhoto
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
        if let sourceViewController = sender.sourceViewController as? TrainerRegionViewController, latitude = sourceViewController.latitudeR, longitude = sourceViewController.longitudeR, distance = sourceViewController.distance {
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
            print("@@@")
            print(self.descriptionString)
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromOther(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerOtherViewController, years = sourceViewController.years, achieve = sourceViewController.achievements, fav = sourceViewController.favorite {
            self.yearsExperience = years
            self.achievements = achieve
            self.favorite = fav
            print("@@@")
            print(self.descriptionString)
            tableView.reloadData()
        }
    }

}
