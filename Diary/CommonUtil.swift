//
//  CommonUtil.swift
//  Diary
//
//  Created by Jang Hyeon Lee on 2016. 2. 2..
//  Copyright © 2016년 Jang Hyeon Lee. All rights reserved.
//

import Foundation

class CommonUtil {
    func getTimeWithFormat (date:NSDate, type:String) -> String {
        
        //let currentDate = NSDate()
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR")
        
        switch type {
        case "short":
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        case "long":
            dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.LongStyle
        case "only short date":
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
        default:
            dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.FullStyle
        }
        
        let convertedDate = dateFormatter.stringFromDate(date)
        
        return convertedDate
        
    }
}