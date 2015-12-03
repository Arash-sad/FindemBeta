//
//  FinderSearchResultViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 26/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class FinderSearchResultViewController: UIViewController {
    
    //TEMP:
    var trainerArray:[PFUser] = []
    
    var trainingType = ""
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Activity Indicator
        let loadView = UIView.loadFromNibNamed("LoadView")
        loadView?.center = view.center
        view.addSubview(loadView!)
        
        let query = PFUser.query()
//        query!.whereKey("firstName", equalTo:"Arash")
        query!.whereKey("trainingTypes", equalTo:trainingType)
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> () in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) users.")
                // Do something with the found objects
                
                self.trainerArray = objects as? [PFUser] ?? []
                print(self.trainerArray)
                

//                if let objects = objects {
//                    for object in objects {
//                        //TEMP:
//                        if let name = object.objectForKey("firstName") as? String {
//                            print(name)
//                            self.nameArray.append(name)
//                        }
//                        print(object)
//                    }
//                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
            self.tableView.reloadData()
            loadView!.removeFromSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func refineSearchBarButtonItemPressed(sender: UIBarButtonItem) {
        
    }

}

// MARK: - UITableViewDataSource
extension FinderSearchResultViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.trainerArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchResultCell") as! SearchResultTableViewCell
        
        cell.nameLabel.text = self.trainerArray[indexPath.row].objectForKey("firstName") as? String
        
        return cell
    }
}

extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}
