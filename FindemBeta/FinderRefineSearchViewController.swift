//
//  FinderRefineSearchViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 3/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

protocol FinderRefineSearchViewControllerDelegate {
    func refinedSerch(gender: String, experience: Int)
}

class FinderRefineSearchViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var refinedGender = "any"
    var pickerData = ["Few Month","2 Years","5 Years","10 Years"]
    var refinedExperience = 0
    
    var delegate: FinderRefineSearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func searchBarButtonItemPressed(sender: UIBarButtonItem) {
        
        if let delegate = self.delegate {
            delegate.refinedSerch(self.refinedGender, experience: self.refinedExperience)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func genderSegmentedControlValueChanged(sender: UISegmentedControl) {
        if(genderSegmentedControl.selectedSegmentIndex == 0)
        {
            self.refinedGender = "any";
        }
        else if(genderSegmentedControl.selectedSegmentIndex == 1)
        {
            self.refinedGender = "male";
        }
        else if(genderSegmentedControl.selectedSegmentIndex == 2)
        {
            self.refinedGender = "female";
        }
    }
        // MARK: - PickerView
        
        func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
                return pickerData.count
        }
        
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        switch pickerData[row] {
            case "2 Years":
            refinedExperience = 2
            case "5 Years":
            refinedExperience = 5
            case "10 Years":
            refinedExperience = 10
            default:
            refinedExperience = 0
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
            let pickerLabel = UILabel()
            pickerLabel.textAlignment = .Center
            pickerLabel.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1)
            let titleData = pickerData[row]
            let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(20, weight: UIFontWeightThin),NSForegroundColorAttributeName:UIColor.whiteColor()])
            pickerLabel.attributedText = myTitle
        
            return pickerLabel
    }

}
