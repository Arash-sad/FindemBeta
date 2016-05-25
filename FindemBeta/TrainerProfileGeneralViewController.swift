//
//  TrainerProfileGeneralViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 9/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class TrainerProfileGeneralViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!    
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var name: String?
    var photo: UIImage?
    var gender: String?
    
    var photoUploadTask: UIBackgroundTaskIdentifier?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Setup imageView
        self.imageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.imageView.layer.borderWidth = 2.0
        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        self.imageView.layer.masksToBounds = true
        
        self.nameTextField.text = self.name
        self.imageView.image = photo
        if gender! == "male" {
            segmentedControl.selectedSegmentIndex = 0
            self.gender = "Male"
        }
        else {
            segmentedControl.selectedSegmentIndex = 1
            self.gender = "Female"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func segmentedControlValueChanged(sender: UISegmentedControl) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            self.gender = "Male"
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            self.gender = "Female"
        }
    }
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBarButtonItem === sender {
            
            // Set the name and photo to be passed to TrainerProfileViewController after the unwind segue.
            self.name = self.nameTextField.text
            self.photo = self.imageView.image
            
            //MARK: Save Name, Photo, and Gender to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.nameTextField.text!, forKey: "firstName")
            user!.setObject(self.gender!, forKey: "gender")
            if let image = self.imageView.image {
                //Convert UIImage to PFFile named profilePic.jpg
                let imageData = UIImageJPEGRepresentation(image, 0.8)
                let imageFile = PFFile(name: "profilePic.jpg", data: imageData!)
                
                // Requesting a Long Running Background Task
                // To finish up tasks that started before the app got suspended
                photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
                    UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
                }
                imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                    
                    UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!)
                }
                
                user!.setObject(imageFile, forKey: "picture")
            }
            user!.saveInBackgroundWithBlock(nil)
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidName()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing
        saveBarButtonItem.enabled = false
    }
    
    func checkValidName() {
        // Disable the Save button if the textField is empty / just white spaces
        let text = nameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        saveBarButtonItem.enabled = !text.isEmpty
    }

    @IBAction func cameraButtonTapped(sender: UIButton) {
        self.nameTextField.resignFirstResponder()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            alert("", message: "Your device does not support the Camera")
        }
    }
    @IBAction func photoLibraryButtonTapped(sender: UIButton) {
        self.nameTextField.resignFirstResponder()
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
        else {
            alert("", message: "Your device does not support the Photo Library")
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.imageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - Alert
    func alert(messageTitle: String, message: String) {
        let alert = UIAlertController(title: messageTitle, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.view.tintColor = UIColor(red: 245/255, green: 7/255, blue: 55/255, alpha: 1.0)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
