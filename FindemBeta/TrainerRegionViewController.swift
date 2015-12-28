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

protocol TrainerRegionViewControllerDelegate {
    func locationAndDistance (latitude: CLLocationDegrees, longitude: CLLocationDegrees, distance: Double)
}

class TrainerRegionViewController: UIViewController {

    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
//    var coords: CLLocationCoordinate2D?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    var distance:Double?
    
    var delegate: TrainerRegionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationItem.rightBarButtonItem?.enabled = false
        
        self.distanceTextField.text = String(distance!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveBarButtonItemPressed(sender: UIBarButtonItem) {
        let geoCoder = CLGeocoder()
        let addressString = "\(streetTextField.text) \(cityTextField.text) \(stateTextField.text) \(postalCodeTextField.text)"
        
        if (streetTextField.text!.isEmpty || cityTextField.text!.isEmpty || stateTextField.text!.isEmpty || postalCodeTextField.text!.isEmpty || distanceTextField.text!.isEmpty) {
            alert("Missing Details", message: "Please complete all the sections")
        }
        else if Double(self.distanceTextField.text!) == nil {
            alert("Wrong Distance Value", message: "Please enter the correct distance value")
        }
        else {
            //MARK: Convert Address String to Latitude & Longitude
            geoCoder.geocodeAddressString(addressString, completionHandler:
                {(placemarks: [CLPlacemark]?, error: NSError?) in
                    
                    if (error != nil) {
                        print("Geocode failed with error: \(error!.localizedDescription)")
                        self.alert("Wrong Address", message: "Please enter the correct address")
                    } else if placemarks!.count > 0 {
                        let placemark = placemarks![0]
                        let location = placemark.location
                        let coordinate = location!.coordinate
                        
                        self.latitude = coordinate.latitude
                        self.longitude = coordinate.longitude
                        self.distance = Double(self.distanceTextField.text!)!
                        
                        if let delegate = self.delegate {
                            delegate.locationAndDistance(self.latitude!, longitude: self.longitude!, distance: self.distance!)
                        }
                        //MARK: Save Latitude, Longitude and Distance to Parse
                        let point = PFGeoPoint(latitude: self.latitude!, longitude: self.longitude!)
                        let user = PFUser.currentUser()
                        user!.setObject(point, forKey: "location")
                        user!.setObject(self.distance!, forKey: "distance")
                        user!.saveInBackgroundWithBlock(nil)
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
            })
        }
        
    }

    //MARK: - Alert
    func alert(messageTitle: String, message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
