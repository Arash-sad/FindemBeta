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
    
    //TODO: TEMP
    var gName:String?
    var gPhoto:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        // Disable the Save button if the text field is empty
        saveBarButtonItem.enabled = !nameTextField.text!.isEmpty
        
        //TODO: TEMP
        self.nameTextField.text = gName
        self.imageView.image = gPhoto
        print(gName)
        print(gPhoto)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if saveBarButtonItem === sender {
            
            // Set the name and photo to be passed to TrainerProfileViewController after the unwind segue.
            //TODO: TEMP
            gName = self.nameTextField.text
            gPhoto = self.imageView.image
            
            //MARK: Save Name and Photo to Parse
            let user = PFUser.currentUser()
            user!.setObject(self.nameTextField.text!, forKey: "firstName")
            if let image = self.imageView.image {
                //Convert UIImage to PFFile named profilePic.jpg
                let imageData = UIImageJPEGRepresentation(image, 1.0)
                let imageFile = PFFile(name: "profilePic.jpg", data: imageData!)
                
                user!.setObject(imageFile, forKey: "picture")
                print("@@@image: \(image)")
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
