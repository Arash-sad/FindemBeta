//
//  Trainer.swift
//  FindemBeta
//
//  Created by Arash Sadeghieh E on 26/11/2015.
//  Copyright © 2015 Arash Sadeghieh Eshtehadi. All rights reserved.
//

import Foundation
import Parse

class Trainer : PFObject, PFSubclassing {
    
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var picture: PFFile
    @NSManaged var trainingTypes: [String]?
    @NSManaged var qualifications: [String]?
    @NSManaged var location: PFGeoPoint?
    @NSManaged var desc: String?
    var distance: Double?
    @NSManaged var yearsExperience: String?
    @NSManaged var achivements: String?
    @NSManaged var favorite: String?
    
    static func parseClassName() -> String {
        return "Trainer"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
}
