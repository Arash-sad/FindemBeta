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
    let description: String?
    let yearsExperience: Int?
    let achievements: String?
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

private func pfUserToTrainer(user: PFUser) -> Trainer {
    
    return Trainer(id: user.objectId!, name: user.objectForKey("firstName") as! String, gender: user.objectForKey("gender") as! String, trainingTypes: user.objectForKey("trainingTypes") as? [String] ?? [], qualifications: user.objectForKey("qualifications") as? [String] ?? [], latitude: (user.objectForKey("location") as? PFGeoPoint)?.latitude ?? 51.50007773, longitude: (user.objectForKey("location") as? PFGeoPoint)?.longitude ?? -0.1246402, distance: user.objectForKey("distance") as? Double ?? 10.0, description: user.objectForKey("description") as? String ?? "", yearsExperience: user.objectForKey("yearsExperience") as? Int ?? 0, achievements: user.objectForKey("achievements") as? String ?? "", pfUser: user)
}

func currentTrainer() -> Trainer? {
    if let user = PFUser.currentUser() {
        return pfUserToTrainer(user)
    }
    return nil
}

