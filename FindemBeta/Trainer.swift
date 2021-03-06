//
//  Trainer.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 26/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import Foundation
import Parse

struct Trainer {
    let id: String
    let name: String
    let gender: String
    let trainingTypes: [String]?
    let qualifications: [String]?
    let latitude: CLLocationDegrees?
    let longitude: CLLocationDegrees?
    let distance: Double?
    let shortDescription: String?
    let longDescription: String?
    let yearsExperience: Int?
    let achievements: String?
    let sessionTimes: String?
    let instagramUserId: String?
    let clubName: String?
    let clubLatitude: Double?
    let clubLongitude: Double?
    let clubAddress: [String]?
    let mobileAddress: [String]?
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

func pfUserToTrainer(user: PFUser) -> Trainer {
    
    return Trainer(id: user.objectId!, name: user.objectForKey("firstName") as! String, gender: user.objectForKey("gender") as! String, trainingTypes: user.objectForKey("trainingTypes") as? [String] ?? [], qualifications: user.objectForKey("qualifications") as? [String] ?? [], latitude: (user.objectForKey("location") as? PFGeoPoint)?.latitude ?? 38.018312, longitude: (user.objectForKey("location") as? PFGeoPoint)?.longitude ?? 51.412430, distance: user.objectForKey("distance") as? Double ?? 10.0, shortDescription: user.objectForKey("shortDescription") as? String ?? "", longDescription: user.objectForKey("longDescription") as? String ?? "", yearsExperience: user.objectForKey("yearsExperience") as? Int ?? 0, achievements: user.objectForKey("achievements") as? String ?? "", sessionTimes: user.objectForKey("sessionTimes") as? String ?? "ABC", instagramUserId: user.objectForKey("instagramUserId") as? String ?? "", clubName: user.objectForKey("clubName") as? String ?? "", clubLatitude: user.objectForKey("clubLatitude") as? Double ?? 38.018312, clubLongitude: user.objectForKey("clubLongitude") as? Double ?? 51.412430, clubAddress: user.objectForKey("clubAddress") as? [String] ?? [], mobileAddress: user.objectForKey("mobileAddress") as? [String] ?? [], pfUser: user)
}

func currentTrainer() -> Trainer? {
    if let user = PFUser.currentUser() {
        return pfUserToTrainer(user)
    }
    return nil
}

