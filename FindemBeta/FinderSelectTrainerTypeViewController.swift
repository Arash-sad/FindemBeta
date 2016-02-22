//
//  FinderSelectTrainerTypeViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 15/02/2016.
//  Copyright © 2016 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class FinderSelectTrainerTypeViewController: UIViewController {

    @IBOutlet weak var trainerTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var kmLabel: UILabel!
    
    var slidingMenu = UIView.loadFromNibNamed("SlidingMenu")
    var menuIsVisible = false
    var menuHeight:CGFloat = 150
    
    var pickerData = [[String]]()
    var distanceArray = [String]()
    var trainerType = "club"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        slidingMenu?.frame.size.width = self.view.frame.size.width
        slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: -menuHeight)
        view.addSubview(slidingMenu!)
        
        trainerTypeSegmentControl.selectedSegmentIndex = 0
        
        self.descriptionLabel.text = "You will find all the personal trainers who are working at the sports club around you with the radius of:"
        
        //Set PickerView Values (Distance between 0 - 50KM)
        for dis in 0...20 {
            distanceArray.append(String(dis))
        }
        pickerData = [distanceArray,[".0",".5"]]
        
        self.distanceLabel.text = "1.5"
        self.pickerView.selectRow(1, inComponent: 0, animated: false)
        self.pickerView.selectRow(1, inComponent: 1, animated: false)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func MenuBarButtonItemTapped(sender: UIBarButtonItem) {
        UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions.TransitionNone, animations: {
            
            self.menuIsVisible = !self.menuIsVisible
            var height:CGFloat = self.menuHeight
            if self.menuIsVisible == false {
                height = -self.menuHeight
            }
            self.slidingMenu?.center = CGPoint(x: self.view.frame.size.width/2, y: height)
            
            }, completion: { finished in
                
                
        })
    }
    
    @IBAction func trainerTypeValueChanged(sender: UISegmentedControl) {
        if(trainerTypeSegmentControl.selectedSegmentIndex == 0)
        {
            self.trainerType = "club"
            self.distanceLabel.hidden = false
            self.pickerView.hidden = false
            self.descriptionLabel.text = "You will find all the personal trainers who are working at the sports club around you with the radius of:"
        }
        else if(trainerTypeSegmentControl.selectedSegmentIndex == 1)
        {
            self.trainerType = "mobile"
            self.distanceLabel.hidden = true
            self.kmLabel.hidden = true
            self.pickerView.hidden = true
            self.descriptionLabel.text = "You will find all the mobile personal trainers who cover your current location."
        }
    }

    @IBAction func nextButtonTapped(sender: UIButton) {
        performSegueWithIdentifier("showSearchTrainingTypes", sender: nil)
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSearchTrainingTypes" {
            let trainerTypeVC = segue.destinationViewController as! FinderSearchViewController
            trainerTypeVC.trainerType = self.trainerType
            trainerTypeVC.clubDistance = Double(self.distanceLabel.text!)!
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

}
