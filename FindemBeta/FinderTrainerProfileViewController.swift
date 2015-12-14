//
//  FinderTrainerProfileViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 9/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit
import Parse

class FinderTrainerProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var trainer: PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = trainer?.objectForKey("firstName") as? String
        print(trainer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chatBarButtonItemPressed(sender: UIBarButtonItem) {
        let query = PFQuery(className:"Action")
        query.whereKey("byUser", equalTo: currentUser()!.id)
        query.whereKey("toTrainer", equalTo: trainer!.objectId!)
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) -> Void in
            if error != nil || object == nil {
                saveConnection(self.trainer!)
                print("They haven't connected yet!")
            } else {
                // The find succeeded.
                print("They are already connected!")
            }
        }
        print(trainer!.objectId!)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
