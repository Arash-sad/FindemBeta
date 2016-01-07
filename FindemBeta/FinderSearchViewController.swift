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
    
    var slidingMenu = UIView.loadFromNibNamed("SlidingMenu")
    var menuVisible = false
    var menuHeight:CGFloat = 150
    
    let locationManager = CLLocationManager()
    var currentLocation = PFGeoPoint()
    
    var ImageArray = [UIImage(named: "baby"),UIImage(named: "core"),UIImage(named: "functional"),UIImage(named: "rehab"),UIImage(named: "smallGroup"),UIImage(named: "weightLoss")]
    let trainingTypesArray = ["Pre and Post Baby","Core Strength","Functional Training","Rehab","Small Group Training","Weight Loss"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slidingMenu?.frame.size.width = self.view.frame.size.width
        slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: -menuHeight)
        view.addSubview(slidingMenu!)
        
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

    // MARK: - Menu Bar Button
    @IBAction func MenuBarButtonItemTapped(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.menuVisible = !self.menuVisible
            var height:CGFloat = self.menuHeight
            if self.menuVisible == false {
                height = -self.menuHeight
            }
            self.slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: height)
            
            }, completion: { finished in
                
                
        })

    }

    //MARK: - Location Access Alert
    func locationAccessAlert() {
        let alert = UIAlertController(title: "Allow Location Access", message: "Location access is restricted. In order to use Findem, please allow location access in the Settigs app under Privacy, Location Services.", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertActionStyle.Default, handler: { (alert: UIAlertAction!) in
            print("")
            UIApplication.sharedApplication().openURL(NSURL(string:UIApplicationOpenSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}

//MARK: - UICollectionViewDelegate
extension FinderSearchViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("searchCell", forIndexPath: indexPath) as! SearchCollectionViewCell
        cell.imageView.image = self.ImageArray[indexPath.row]
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if (currentLocation.latitude == 0 && currentLocation.longitude == 0){
            locationAccessAlert()
        }
        else {
            performSegueWithIdentifier("showSearchResult", sender: nil)

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSearchResult"{
            let indexPaths = self.collectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            let resultVC = segue.destinationViewController as! FinderSearchResultViewController
            resultVC.trainingType = self.trainingTypesArray[indexPath.row]
            resultVC.currentLocation = self.currentLocation
        }
    }
}


