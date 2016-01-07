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

class TrainerRegionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var distanceLabel: UILabel!
    
//    var coords: CLLocationCoordinate2D?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var distance: Double?
    var pickerData = [[String]]()
    var distanceArray = [String]()
    var delegate: TrainerRegionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Set PickerView Values (Distance between 0 - 50KM)
        for dis in 0...50 {
            distanceArray.append(String(dis))
        }
        pickerData = [distanceArray,[".0",".5"]]
        
        self.distanceLabel.text = String(self.distance!)
        //TODO: available on Swift 2.0
        // what works for 8.0 ?!!
        self.pickerView.selectRow(Int(self.distance!), inComponent: 0, animated: false)
        if (self.distance! % 1) == 0 {
            self.pickerView.selectRow(0, inComponent: 1, animated: false)
        }
        else {
            self.pickerView.selectRow(1, inComponent: 1, animated: false)
        }
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
        
        if (streetTextField.text!.isEmpty || cityTextField.text!.isEmpty || stateTextField.text!.isEmpty || postalCodeTextField.text!.isEmpty) {
            alert("Missing Details", message: "Please complete all the sections")
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
                        self.distance = Double(self.distanceLabel.text!)!
                        
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

    // MARK: - PickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return pickerData[component].count
        }
        else {
            return pickerData[component].count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return pickerData[component][row]
        }
        else {
            return pickerData[component][row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        let firstComponent = pickerData[0][pickerView.selectedRowInComponent(0)]
        let secondComponent = pickerData[1][pickerView.selectedRowInComponent(1)]
        self.distanceLabel.text = firstComponent + secondComponent
    }
    
    //MARK: - Alert
    func alert(messageTitle: String, message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
