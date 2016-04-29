//
//  FinderSearchViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 23/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse


class FinderSearchViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let locationManager = CLLocationManager()
    var currentLocation = PFGeoPoint()
    var trainerType = "club"
    var clubDistance = 1.5
    
    let trainingTypesArray = ["Bootcamp", "Core Strength", "Diet & Nutrition", "Functional Training", "Group Exercise", "Lifestyle Coach", "Massage Therapy", "Physiotherapist", "Pre & Post Baby", "Rehab", "Sport Specific", "Strength & Conditioning", "Weight Loss"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Location Access - For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        else {
            locationAccessAlert()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSearchResult" {
            let indexPaths = self.collectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            let resultVC = segue.destinationViewController as! FinderSearchResultViewController
            resultVC.trainingType = self.trainingTypesArray[indexPath.row]
            resultVC.currentLocation = self.currentLocation
            resultVC.trainerType = self.trainerType
            resultVC.clubDistance = self.clubDistance
        }
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        // Get the user current location
        let userLocation = locations.last! as CLLocation
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        
        self.locationManager.stopUpdatingLocation()
        self.currentLocation = PFGeoPoint(latitude: latitude, longitude: longitude)
    }
    
    //Print out the location manager error
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Location Manager - Errors: " + error.localizedDescription)
    }

    //MARK: - Location Access Alert
    func locationAccessAlert() {
        let alert = UIAlertController(title: "Allow Location Access", message: "Location access is restricted. In order to use Findem, please allow location access in the Settigs app under Privacy, Location Services.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0)
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
            UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

//MARK: - UICollectionViewDelegate
extension FinderSearchViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trainingTypesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("searchCell", forIndexPath: indexPath) as! SearchCollectionViewCell
        cell.imageView.image = UIImage(named: self.trainingTypesArray[indexPath.row])
        cell.trainingTypeLabel.text = self.trainingTypesArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        if menuIsVisible == false {
            if (currentLocation.latitude == 0 && currentLocation.longitude == 0){
                locationAccessAlert()
            }
            else {
                performSegueWithIdentifier("showSearchResult", sender: nil)
                
            }
//        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSizeMake(self.view.frame.width/2 - 20, self.view.frame.width/2 - 20)
    }
    
}


