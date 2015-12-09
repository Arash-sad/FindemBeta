//
//  FinderRefineSearchViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 3/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

protocol FinderRefineSearchViewControllerDelegate {
    func refineSerch(gender: String)
}

class FinderRefineSearchViewController: UIViewController {

    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    
    var refineGender = "any"
    
    var delegate: FinderRefineSearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
            delegate.refineSerch(refineGender)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func genderSegmentedControlValueChanged(sender: UISegmentedControl) {
        if(genderSegmentedControl.selectedSegmentIndex == 0)
        {
            self.refineGender = "any";
        }
        else if(genderSegmentedControl.selectedSegmentIndex == 1)
        {
            self.refineGender = "male";
        }
        else if(genderSegmentedControl.selectedSegmentIndex == 2)
        {
            self.refineGender = "female";
        }
    }

}
