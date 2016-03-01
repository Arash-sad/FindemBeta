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
    var qualificationsArray: [String] = []
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var distance: Double = 10.0
    var shortDescription: String = ""
    var longDescription: String = ""
    var yearsExperience: Int = 0
    var achievements: String = ""
    var sessionTimes: String = "ABC"
    var instagramUserId: String = ""
    var clubName = ""
    var clubLatitude: Double?
    var clubLongitude: Double?
    let defaultLatitude = 38.018312
    let defaultLongitude = 51.412430
    var clubAddress: [String] = []
    var mobileAddress: [String] = []
    
    let firstCellIdentifier = "firstProfileCell"
    let clubProfileCell = "clubProfileCell"
    let mobileProfileCell = "mobileProfileCell"
    let secondCellIdentifier = "secondProfileCell"
    let thirdCellIdentifier = "thirdProfileCell"
    let fourthCellIdentifier = "fourthProfileCell"
    let fifthCellIdentifier = "fifthProfileCell"
    let sixthCellIdentifier = "sixthProfileCell"
    let sevenththCellIdentifier = "seventhProfileCell"
    let eighthCellIdentifier = "eighthProfileCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Add Right barButtonItem (Edit/Done)
        let rightBarButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editAction")
        
        self.navigationItem.setRightBarButtonItem(rightBarButton, animated: true)
        
        // Disable the tableView selection highlighting
        tableView.allowsSelection = false
        
        //Fetch Details from Parse
        self.name = currentTrainer()?.name
        currentTrainer()?.getPhoto({
            image in
            self.photo = image
            //TEMP: right place to call reloadData ?!
            self.tableView.reloadData()
        })
        self.gender = currentTrainer()?.gender
        self.trainingArray = (currentTrainer()?.trainingTypes)!
        self.qualificationsArray = (currentTrainer()?.qualifications)!
        self.latitude = (currentTrainer()?.latitude)!
        self.longitude = (currentTrainer()?.longitude)!
        self.distance = (currentTrainer()?.distance)!
        self.shortDescription = (currentTrainer()?.shortDescription)!
        self.longDescription = (currentTrainer()?.longDescription)!
        self.yearsExperience = (currentTrainer()?.yearsExperience)!
        self.achievements = (currentTrainer()?.achievements)!
        self.sessionTimes = (currentTrainer()?.sessionTimes)!
        self.instagramUserId = (currentTrainer()?.instagramUserId)!
        self.clubName = (currentTrainer()?.clubName)!
        self.clubLatitude = (currentTrainer()?.clubLatitude)!
        self.clubLongitude = (currentTrainer()?.clubLongitude)!
        self.clubAddress = (currentTrainer()?.clubAddress)!
        self.mobileAddress = (currentTrainer()?.mobileAddress)!

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // RightBarButtonItem Action
    func editAction() {
        if editButtonEnabled {
            editButtonEnabled = !editButtonEnabled
            self.navigationItem.rightBarButtonItem! = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Done, target: self, action: "editAction")
            // Disable the tableView selection highlighting
            tableView.allowsSelection = false
            self.tableView.reloadData()
        }
        else {
            editButtonEnabled = !editButtonEnabled
            self.navigationItem.rightBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "editAction")
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
            
            qualificationsVC?.qualificationsArray = self.qualificationsArray
        }
        else if segue.identifier == "showClubDetails"{
            let navVc = segue.destinationViewController as? UINavigationController
            let clubVC = navVc!.viewControllers[0] as? TrainerClubViewController
            
            clubVC?.delegate = self
            clubVC?.clubName = self.clubName
            clubVC?.clubAddress = self.clubAddress
        }
        else if segue.identifier == "showMobileDetails" {
            let navVC = segue.destinationViewController as? UINavigationController
            let regionVC = navVC!.viewControllers[0] as? TrainerRegionViewController
            
            regionVC?.delegate = self
            regionVC?.latitude = self.latitude
            regionVC?.longitude = self.longitude
            regionVC?.distance = self.distance
            regionVC?.mobileAddress = self.mobileAddress
        }
        else if segue.identifier == "showDescription" {
            let navVC = segue.destinationViewController as? UINavigationController
            let descVC = navVC!.viewControllers[0] as? TrainerDescriptionViewController
            
            descVC?.shortDescription = self.shortDescription
            descVC?.longDescription = self.longDescription
        }
        else if segue.identifier == "showOtherDetails" {
            let navVC = segue.destinationViewController as? UINavigationController
            let otherVC = navVC!.viewControllers[0] as? TrainerOtherViewController
            
            otherVC?.years = self.yearsExperience
            otherVC?.achievements = self.achievements
        }
        else if segue.identifier == "showSessionTimes" {
            let navVC = segue.destinationViewController as? UINavigationController
            let sessionVC = navVC!.viewControllers[0] as? TrainerSessionTimesViewController
            
            sessionVC?.delegate = self
            sessionVC?.sessionTimes = self.sessionTimes
        }
        else if segue.identifier == "showSocialNetworks" {
            let navVC = segue.destinationViewController as? UINavigationController
            let socialVC = navVC!.viewControllers[0] as? TrainerSocialNetworkingViewController
            
            socialVC?.delegate = self
            socialVC?.instagramId = self.instagramUserId
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.firstCellIdentifier, forIndexPath: indexPath) as! FirstTableViewCell
            
            // Setup profileImageView
            cell.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
            cell.profileImageView.layer.borderWidth = 2.0
            cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.height / 2
            cell.profileImageView.layer.masksToBounds = true
            
            cell.nameLabel.text = self.name
            cell.profileImageView?.image = self.photo
            cell.genderLabel.text = self.gender
            if editButtonEnabled {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.clubProfileCell, forIndexPath: indexPath) as! ClubProfileTableViewCell
            cell.clubLabel.text = self.clubName
            if clubAddress.count == 4 {
                cell.firstAddressLabel.text = "\(clubAddress[0])"
                cell.secondAddressLabel.text = "\(clubAddress[1]) \(clubAddress[2]) \(clubAddress[3])"
            }
            if editButtonEnabled {
                
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.mobileProfileCell, forIndexPath: indexPath) as! MobileProfileTableViewCell
            cell.distanceLabel.text = String(self.distance)
            if clubAddress.count == 4 {
                cell.firstAddressLabel.text = "\(mobileAddress[0])"
                cell.secondAddressLabel.text = "\(mobileAddress[1]) \(mobileAddress[2]) \(mobileAddress[3])"
            }
            if editButtonEnabled {
                
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.secondCellIdentifier, forIndexPath: indexPath) as! SecondTableViewCell
            
            //MARK: load mapView and add annotation and circle overlay
            let location = CLLocationCoordinate2DMake(latitude!, longitude!)
            let clubLocation = CLLocationCoordinate2DMake(self.clubLatitude!, self.clubLongitude!)
            
            cell.mapView.delegate = self
            cell.mapView.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.mapView.layer.borderWidth = 2.0
            
            //remove map overlays and annotations
            let overlays = cell.mapView.overlays
            cell.mapView.removeOverlays(overlays)
            let annotationToRemove = cell.mapView.annotations
            cell.mapView.removeAnnotations(annotationToRemove)
            
            if self.latitude != defaultLatitude && self.longitude != defaultLongitude {
                let span = MKCoordinateSpanMake(0.03, 0.03)
                let region = MKCoordinateRegion(center: location, span: span)
                cell.mapView.setRegion(region, animated: true)
            }
            else if self.clubLatitude != defaultLatitude && self.clubLongitude != defaultLongitude {
                let span = MKCoordinateSpanMake(0.03, 0.03)
                let region = MKCoordinateRegion(center: clubLocation, span: span)
                cell.mapView.setRegion(region, animated: true)
            }
            else {
                print("Haven't set any address!!")
            }
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = self.name
            annotation.subtitle = "Mobile PT"
            
            let clubAnnotation = MKPointAnnotation()
            clubAnnotation.coordinate = clubLocation
            clubAnnotation.title = self.name
            clubAnnotation.subtitle = self.clubName
            
            //Draw a circle around user location
            let newCircle = MKCircle(centerCoordinate: location, radius: (self.distance * 1000) as CLLocationDistance)
            
            if self.latitude != defaultLatitude && self.longitude != defaultLongitude {
                cell.mapView.addAnnotation(annotation)
                cell.mapView.addOverlay(newCircle)
            }
            
            if self.clubLatitude != defaultLatitude && self.clubLongitude != defaultLongitude {
                cell.mapView.addAnnotation(clubAnnotation)
            }
//            cell.mapView.showAnnotations([annotation,clubAnnotation], animated: true)
            
            return cell
        }
        else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.thirdCellIdentifier, forIndexPath: indexPath) as! ThirdTableViewCell
            cell.trainingTypesPickerView.reloadAllComponents()
            if editButtonEnabled {
                cell.trainingTypesPickerView.userInteractionEnabled = false
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.trainingTypesPickerView.userInteractionEnabled = true
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.section == 5 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.fourthCellIdentifier, forIndexPath: indexPath) as! FourthTableViewCell
            cell.qualificationsPickerView.reloadAllComponents()
            if editButtonEnabled {
                cell.qualificationsPickerView.userInteractionEnabled = false
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.qualificationsPickerView.userInteractionEnabled = true
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.section == 6 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.fifthCellIdentifier, forIndexPath: indexPath) as! FifthTableViewCell
            cell.shortDescriptionTextView.text = self.shortDescription
            cell.longDescriptionTextView.text = self.longDescription
            if editButtonEnabled {
                cell.shortDescriptionTextView.userInteractionEnabled = false
                cell.longDescriptionTextView.userInteractionEnabled = false
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.shortDescriptionTextView.userInteractionEnabled = true
                cell.longDescriptionTextView.userInteractionEnabled = true
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.section == 7 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.sixthCellIdentifier, forIndexPath: indexPath) as! SixthTableViewCell
            if self.yearsExperience == 0 {
                cell.yearsLabel.text = "Less than a year"
            }
            else if self.yearsExperience == 1 {
                cell.yearsLabel.text = "1 year"
            }
            else {
                cell.yearsLabel.text = ("\(self.yearsExperience) years")
            }
            cell.achievementsTextView.text = self.achievements
            if editButtonEnabled {
                cell.achievementsTextView.userInteractionEnabled = false
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.achievementsTextView.userInteractionEnabled = true
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else if indexPath.section == 8 {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.sevenththCellIdentifier, forIndexPath: indexPath) as! SeventhTableViewCell
            if sessionTimes.uppercaseString.characters.contains("A") {
                cell.morningsWD.textColor = UIColor.blackColor()
            }
            else {
                cell.morningsWD.textColor = UIColor.lightGrayColor()
            }
            if sessionTimes.uppercaseString.characters.contains("B") {
                cell.afternoonsWD.textColor = UIColor.blackColor()
            }
            else {
                cell.afternoonsWD.textColor = UIColor.lightGrayColor()
            }
            if sessionTimes.uppercaseString.characters.contains("C") {
                cell.eveningsWD.textColor = UIColor.blackColor()
            }
            else {
                cell.eveningsWD.textColor = UIColor.lightGrayColor()
            }
            if sessionTimes.uppercaseString.characters.contains("X") {
                cell.morningsWE.textColor = UIColor.blackColor()
            }
            else {
                cell.morningsWE.textColor = UIColor.lightGrayColor()
            }
            if sessionTimes.uppercaseString.characters.contains("Y") {
                cell.afternoonsWE.textColor = UIColor.blackColor()
            }
            else {
                cell.afternoonsWE.textColor = UIColor.lightGrayColor()
            }
            if sessionTimes.uppercaseString.characters.contains("Z") {
                cell.eveningsWE.textColor = UIColor.blackColor()
            }
            else {
                cell.eveningsWE.textColor = UIColor.lightGrayColor()
            }
            if editButtonEnabled {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier(self.eighthCellIdentifier, forIndexPath: indexPath) as! EighthTableViewCell
            cell.instagramIdLabel.text = self.instagramUserId
            if editButtonEnabled {
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "General Info"
        }
        else if section == 1 {
            return "Club Trainer"
        }
        else if section == 2 {
            return "Mobile Trainer"
        }
        else if section == 3 {
            return "Map"
        }
        else if section == 4 {
            return "Training Types"
        }
        else if section == 5 {
            return "Qualifications"
        }
        else if section == 6 {
            return "Descriptions"
        }
        else if section == 7 {
            return "Experience"
        }
        else if section == 8 {
            return "Sessions Times"
        }
        else {
            return "Instagram Id"
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if editButtonEnabled {
            if indexPath.section == 0 {
                performSegueWithIdentifier("showGeneralDetail", sender: nil)
            }
            else if indexPath.section == 1 {
                performSegueWithIdentifier("showClubDetails", sender: nil)
            }
            else if indexPath.section == 2 {
                performSegueWithIdentifier("showMobileDetails", sender: nil)
            }
            else if indexPath.section == 3 {
//                performSegueWithIdentifier("", sender: nil)
            }
            else if indexPath.section == 4 {
                performSegueWithIdentifier("showTypesOfTraining", sender: nil)
            }
            else if indexPath.section == 5 {
                performSegueWithIdentifier("showQualifications", sender: nil)
            }
            else if indexPath.section == 6 {
                performSegueWithIdentifier("showDescription", sender: nil)
            }
            else if indexPath.section == 7 {
                performSegueWithIdentifier("showOtherDetails", sender: nil)
            }
            else if indexPath.section == 8 {
                performSegueWithIdentifier("showSessionTimes", sender: nil)
            }
            else if indexPath.section == 9 {
                performSegueWithIdentifier("showSocialNetworks", sender: nil)
            }
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            return 210.0
        }
        else if indexPath.section == 1 {
            return 150.0
        }
        else if indexPath.section == 2 {
            return 150.0
        }
        else if indexPath.section == 3 {
            return 190.0
        }
        else if indexPath.section == 4 {
            return 150.0
        }
        else if indexPath.section == 5 {
            return 150.0
        }
        else if indexPath.section == 6 {
            return 240.0
        }
        else if indexPath.section == 7 {
            return 170.0
        }
        else if indexPath.section == 8 {
            return 130.0
        }
        else {
            return 50.0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor(red: 220, green: 220, blue: 220, alpha: 0.2)
        header.textLabel!.textColor = UIColor.blackColor()
        //It is only available on iOS 8.2 or newer
//        if #available(iOS 8.2, *) {
            header.textLabel!.font = UIFont.systemFontOfSize(18, weight: UIFontWeightBold)
//        } else {
//            // Fallback on earlier versions
//        }
        header.textLabel!.frame = header.frame
        header.textLabel!.textAlignment = NSTextAlignment.Left
    }
    
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
            self.qualificationsArray = tempArray
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromDescription(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerDescriptionViewController, shortDesc = sourceViewController.shortDescription, longDesc = sourceViewController.longDescription {
            self.shortDescription = shortDesc
            self.longDescription = longDesc
            tableView.reloadData()
        }
    }
    
    @IBAction func unwindFromOther(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.sourceViewController as? TrainerOtherViewController, years = sourceViewController.years, achieve = sourceViewController.achievements {
            self.yearsExperience = years
            self.achievements = achieve
            tableView.reloadData()
        }
    }

}

// MARK: - TrainerRegionViewControllerDelegate
extension TrainerProfileViewController: TrainerRegionViewControllerDelegate {
    func locationAndDistance(latitude: CLLocationDegrees, longitude: CLLocationDegrees, distance: Double, address: [String]) {
        self.latitude = latitude
        self.longitude = longitude
        self.distance = distance
        self.mobileAddress = address
        tableView.reloadData()
    }
}

// MARK: - TrainerSessionTimesViewControllerDelegate
extension TrainerProfileViewController: TrainerSessionTimesViewControllerDelegate {
    func saveSessionTimes(sessions: String) {
        self.sessionTimes = sessions
        tableView.reloadData()
    }
}

//MARK: - TrainerSocialNetworkingViewControllerDelegate
extension TrainerProfileViewController: TrainerSocialNetworkingViewControllerDelegate {
    func saveInstagramUserId(instagramId: String) {
        self.instagramUserId = instagramId
        tableView.reloadData()
    }
}

//MARK: - TrainerClubViewControllerDelegate
extension TrainerProfileViewController: TrainerClubViewControllerDelegate {
    func updateNameAndLocation(latitude: Double, longitude: Double, name: String, address: [String]) {
        self.clubName = name
        self.clubLatitude = latitude
        self.clubLongitude = longitude
        self.clubAddress = address
        tableView.reloadData()
    }
}

