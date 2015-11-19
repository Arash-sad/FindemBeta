//
//  User.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 4/11/2015.
//  Copyright (c) 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import Foundation
import Parse

struct User {
    let id: String
    let name: String
//    let photo: PFFile
    private let pfUser: PFUser
    
    //Nested Function-Use callback: (UIImage) because make the call asynchronously
    func getPhoto(callback:(UIImage) -> ()) {
        let imageFile = pfUser.objectForKey("picture") as! PFFile
        imageFile.getDataInBackgroundWithBlock({
            data, error in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        })
    }
}

private func pfUserToUser(user: PFUser) -> User {
    return User(id: user.objectId!, name: user.objectForKey("firstName") as! String, pfUser: user)
//    photo: user.objectForKey("picture") as! PFFile
}

func currentUser() -> User? {
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil 
}

//class FacebookDetails {
//    static let sharedInstance = FacebookDetails()
//    var image: UIImage?
//    private init() {
//        populateImage()
//}

//func saveTrainerGeneralInfo (user:User) {
//    let cUser = PFUser.currentUser()
//    cUser?.setObject(user.name, forKey: "firstName")
//    cUser?.setObject(user.photo, forKey: "photo")
//
//}
