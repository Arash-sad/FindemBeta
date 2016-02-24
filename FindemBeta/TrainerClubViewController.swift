//
//  TrainerClubViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 8/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

protocol TrainerClubViewControllerDelegate {
    func updateNameAndLocation(latitude: Double, longitude: Double, name: String, address: [String])
}

class TrainerClubViewController: UIViewController {

    @IBOutlet weak var clubNameTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var postalCodeTextField: UITextField!
    
    var clubName: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var clubAddress: [String] = []
    
    var delegate: TrainerClubViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // hide keyboard if tap on screen
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "handleTapGestureRecognizer:")
        view.addGestureRecognizer(tapGestureRecognizer)
        
        if let name = clubName {
            self.clubNameTextField.text = name
        }
        // fill address in textFelds
        if self.clubAddress.count == 4 {
            self.streetTextField.text = self.clubAddress[0]
            self.cityTextField.text = self.clubAddress[1]
            self.stateTextField.text = self.clubAddress[2]
            self.postalCodeTextField.text = self.clubAddress[3]
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonTapped(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func saveBarButtonTapped(sender: UIBarButtonItem) {
        
        self.clubName = self.clubNameTextField.text!
        
        let geoCoder = CLGeocoder()
        let addressString = "\(streetTextField.text) \(cityTextField.text) \(stateTextField.text) \(postalCodeTextField.text)"
        
        if ((streetTextField.text?.isEmptyOrWhitespace() == true) || (cityTextField.text?.isEmptyOrWhitespace() == true) || (stateTextField.text?.isEmptyOrWhitespace() == true) || (postalCodeTextField?.text?.isEmptyOrWhitespace() == true) || (self.clubNameTextField.text?.isEmptyOrWhitespace() == true)) {
            alert("Missing Details", message: "Please complete all the sections")
        }
        else {
            // Save Address String
            self.clubAddress = [self.streetTextField.text!,self.cityTextField.text!,self.stateTextField.text!,self.postalCodeTextField.text!]
            
            // MARK: Convert Address String to Latitude & Longitude
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
                        print(self.latitude)
                        print(self.longitude)
                        
                        if let delegate = self.delegate {
                            delegate.updateNameAndLocation(self.latitude!, longitude: self.longitude!, name: self.clubName!, address: self.clubAddress)
                        }
                        // MARK: Save clubName, latitude, longitude, and address string to Parse
                        let user = PFUser.currentUser()
                        user!.setObject(self.clubName!, forKey: "clubName")
                        user!.setObject(self.clubAddress, forKey: "clubAddress")
                        user!.setObject(Double(self.latitude!), forKey: "clubLatitude")
                        user!.setObject(Double(self.longitude!), forKey: "clubLongitude")
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
    
    // MARK: Custom Tap method implementation
    func handleTapGestureRecognizer(tapGestureRecognizer: UITapGestureRecognizer) {
        clubNameTextField.resignFirstResponder()
        streetTextField.resignFirstResponder()
        cityTextField.resignFirstResponder()
        stateTextField.resignFirstResponder()
        postalCodeTextField.resignFirstResponder()
    }
    
}
