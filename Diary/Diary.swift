//
//  Diary.swift
//  Diary
//
//  Created by Jang Hyeon Lee on 2016. 1. 31..
//  Copyright © 2016년 Jang Hyeon Lee. All rights reserved.
//

import Foundation
import UIKit

class Diary : NSObject, NSCoding {
    var date:NSDate
    var subject:String
    var content:String
    var photo:UIImage?
    
    init?(date:NSDate, subject:String, content:String, photo:UIImage?) {
        self.date    = date
        self.subject = subject
        self.content = content
        self.photo   = photo
        
        super.init()
        
        if subject.isEmpty  {
            return nil
        }
    }
    
    // MARK: Property
    
    struct PropertyKey {
        static let subjectKey = "subject"
        static let dateKey    = "date"
        static let contentKey = "content"
        static let photoKey   = "photo"
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
    }
    
    required convenience init?(coder aDecoder:NSCoder) {
        let subject = aDecoder.decodeObjectForKey(PropertyKey.subjectKey) as! String
        let date = aDecoder.decodeObjectForKey(PropertyKey.dateKey) as! NSDate
        let content = aDecoder.decodeObjectForKey(PropertyKey.contentKey) as! String
        let photo = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as? UIImage
        
        self.init(date:date, subject:subject, content:content, photo:photo)
    }
}