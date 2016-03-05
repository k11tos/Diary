//
//  Diary.swift
//  Diary
//
//  Created by Jang Hyeon Lee on 2016. 1. 31..
//  Copyright © 2016년 Jang Hyeon Lee. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class Diary : NSObject, NSCoding {
    var date:NSDate
    var subject:String
    var content:String
    var photo:UIImage?
    var latitude:CLLocationDegrees
    var longitude:CLLocationDegrees
    
    init?(date:NSDate, subject:String, content:String, photo:UIImage?, latitude:CLLocationDegrees, longitude:CLLocationDegrees) {
        self.date      = date
        self.subject   = subject
        self.content   = content
        self.photo     = photo
        self.latitude  = latitude
        self.longitude = longitude
        
        super.init()
        
        if subject.isEmpty  {
            return nil
        }
    }
    
    // MARK: Property
    
    struct PropertyKey {
        static let subjectKey   = "subject"
        static let dateKey      = "date"
        static let contentKey   = "content"
        static let photoKey     = "photo"
        static let latitudeKey  = "latitude"
        static let longitudeKey = "longitude"
    }
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("diaries")
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(subject, forKey: PropertyKey.subjectKey)
        aCoder.encodeObject(date, forKey: PropertyKey.dateKey)
        aCoder.encodeObject(content, forKey: PropertyKey.contentKey)
        aCoder.encodeObject(photo, forKey: PropertyKey.photoKey)
        aCoder.encodeObject(latitude, forKey: PropertyKey.latitudeKey)
        aCoder.encodeObject(longitude, forKey: PropertyKey.longitudeKey)
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let subject = aDecoder.decodeObjectForKey(PropertyKey.subjectKey) as! String
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        let content = aDecoder.decodeObjectForKey(PropertyKey.contentKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        let latitude = aDecoder.decodeObjectForKey(PropertyKey.latitudeKey) as! CLLocationDegrees
        let longitude = aDecoder.decodeObjectForKey(PropertyKey.longitudeKey) as! CLLocationDegrees
        
        self.init(date:date, subject:subject, content:content, photo:photo, latitude:latitude, longitude:longitude)
    }
}