//
//  TrainerRegionViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 16/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse
import MapKit

class TrainerRegionViewController: UIViewController {

    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
//    var coords: CLLocationCoordinate2D?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var distance:Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        self.distanceTextField.text = String(distance!)
        print("$$$")
        print(latitude)
        print(longitude)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func showOnMapButtonPressed(sender: UIButton) {
        
        let geoCoder = CLGeocoder()
        let addressString = "\(streetTextField.text) \(cityTextField.text) \(stateTextField.text) \(postalCodeTextField.text)"
        
        if (streetTextField.text!.isEmpty || cityTextField.text!.isEmpty || stateTextField.text!.isEmpty || postalCodeTextField.text!.isEmpty || distanceTextField.text!.isEmpty) {
            addressAlert()
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        //Show alert if the distanceTextField is not digits
        else if Double(self.distanceTextField.text!) == nil {
            distanceAlert()
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        else {
            //MARK: Convert Address String to Latitude & Longitude
            geoCoder.geocodeAddressString(addressString, completionHandler:
                {(placemarks: [CLPlacemark]?, error: NSError?) in
                    
                    if (error != nil) {
                        print("Geocode failed with error: \(error!.localizedDescription)")
                    } else if placemarks!.count > 0 {
                        let placemark = placemarks![0]
                        let location = placemark.location
                        let coordinate = location!.coordinate
                        
                        self.latitude = coordinate.latitude
                        self.longitude = coordinate.longitude
                        
                        print("###")
                        print(self.latitude)
                        print(self.longitude)
                        
                    }
            })
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBarButtonItem === sender {
            self.distance = Double(self.distanceTextField.text!)! 
            
            //MARK: Save Latitude, Longitude and Distance to Parse
            let point = PFGeoPoint(latitude: self.latitude!, longitude: self.longitude!)
            let user = PFUser.currentUser()
            user!.setObject(point, forKey: "location")
            user!.setObject(self.distance!, forKey: "distance")
            user!.saveInBackgroundWithBlock(nil)
        }
        
    }
    //MARK: - Alerts
    func addressAlert() {
        let alert = UIAlertController(title: "Missing Details", message: "Please complete all the sections", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func distanceAlert() {
        let alert = UIAlertController(title: "Wrong Distance Value", message: "Please enter the correct distance value", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }


}
