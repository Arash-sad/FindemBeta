//
//  Connection.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 11/12/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import Foundation
import Parse

struct Connection {
    let id: String
    let user: User
}

func fetchConnections (callBack: ([Connection]) -> ()) {
    PFQuery(className: "Action")
        .whereKey("toTrainer", equalTo: PFUser.currentUser()!.objectId!)
        .whereKey("type", equalTo: "connected")
        .findObjectsInBackgroundWithBlock({
            (objects: [PFObject]?, error: NSError?) -> () in
            if error == nil {
                if let connections = objects {
                    let connectedUsers = connections.map({
                        (object)->(connectionID: String, userID: String) in
                        (object.objectId!, object.objectForKey("byUser") as! String)
                    })
                    let userIDs = connectedUsers.map({$0.userID})
                    
                    PFUser.query()!
                        .whereKey("objectId", containedIn: userIDs)
                        .findObjectsInBackgroundWithBlock({
                            (objects: [PFObject]?, error: NSError?) -> () in
                            
                            if let users = objects as? [PFUser] {
                                // Warning: reverse is not available in Swift 2.0
                                // used users.reverse() instead of reverse(users)
                                let users = users.reverse()
                                var m = Array<Connection>()
                                // Warning: enumerate is not a global function anymore in Swift 2.0
                                // Below used users.enumerate() instead of enumerate(users)
                                for (index, user) in users.enumerate() {
                                    m.append(Connection(id: connectedUsers[index].connectionID, user: pfUserToUser(user)))
                                }
                                callBack(m)
                            }
                        })
                }
            }
            else {
                // Log details of the failure
                print("Error-FetchConnections: \(error!) \(error!.userInfo)")
            }
            
        })
}