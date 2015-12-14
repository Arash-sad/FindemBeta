//
//  MessagesViewController.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 11/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var connections:[Connection] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
        override func viewWillAppear(animated: Bool) {
            super.viewWillAppear(animated)
    
            fetchConnections({
                connections in
                self.connections = connections
                self.tableView.reloadData()
            })
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return connections.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("messageCell", forIndexPath: indexPath) as! MessagesTableViewCell
        
        // Configure the cell...
        let user = connections[indexPath.row].user
        
        cell.nameLabel.text = user.name
        user.getPhoto({
            image in
            cell.avatarImageView.image = image
        })
        
        return cell
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
