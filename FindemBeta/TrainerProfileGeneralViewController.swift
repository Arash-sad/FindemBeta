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

        // Do any additional setup after loading the view.
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        // Disable the Save button if the text field is empty
        saveBarButtonItem.enabled = !nameTextField.text!.isEmpty
        
        self.nameTextField.text = self.name
        self.imageView.layer.cornerRadius = self.imageView.frame.height / 2
        self.imageView.layer.masksToBounds = true
        self.imageView.image = photo
        if gender! == "male" {
            segmentedControl.selectedSegmentIndex = 0
        }
        else {
            segmentedControl.selectedSegmentIndex = 1
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
            self.gender = "male"
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            self.gender = "female"
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
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidName()
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Save button while editing.
        saveBarButtonItem.enabled = false
    }
    
    func checkValidName() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveBarButtonItem.enabled = !text.isEmpty
    }
    
    //MARK: - TapGestureRecognizer
    
    @IBAction func selectImage(sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        
        //TODO: Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .PhotoLibrary
        imagePickerController.delegate = self
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }

}
