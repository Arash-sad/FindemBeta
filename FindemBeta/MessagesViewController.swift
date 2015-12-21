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

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let vc = ChatViewController()
        
        // Pass connectionID to chatViewController and set its title to user's name
        let connection = connections[indexPath.row]
        vc.connectionID = connection.id
        vc.title = connection.user.name
        vc.recipient = connection.user
        
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
