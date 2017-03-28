//
//  DatePickerSource.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit

let YESTSPACEYEAR = 100
let LASTSPACEYEAR = 100
var StartYear = 0;
var EndYear = 0;

class DatePickerSource: NSObject {
    var calendar = Calendar.init(identifier:Calendar.Identifier.gregorian)
    var timeZone = TimeZone(identifier: "UTC")
    var components = DateComponents.init()
    
    func getYears() -> Array<String>
    {
        var years = [String]()
        components = calendar.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: Date())
        StartYear = components.year! - YESTSPACEYEAR;
        EndYear = components.year! + LASTSPACEYEAR;
        
        for y in StartYear...EndYear {
            years.append(y.description)
        }
        
        return years;
    }
    
    func getMonths() -> Array<String>
    {
        var months = [String]()
        for m in 1...12
        {
            months.append(m.description)
        }
        
        return months
    }
    
    func getDaysInMonth(_ mdate:Date) -> Array<String>
    {
        
        var days = [String]()
        let daysRange:Range! = calendar.range(of: .day, in: .month, for: mdate)
        for d in 1...daysRange.upperBound
        {
            days.append(d.description)
        }
        
        return days
    }
    
    func getDates() ->Array<Date>
    {
        var dates:[Date] = Array()
        (components as NSDateComponents).calendar = calendar
        (components as NSDateComponents).timeZone = timeZone
        components.year = StartYear
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let yearMin:Date = (components as NSDateComponents).date!
        let yearMax:Date = Date()
        
        let timestampMin = yearMin.timeIntervalSince1970
        let timestampMax = yearMax.timeIntervalSince1970
        
        while timestampMin < timestampMax
        {
            let date = Date.init(timeIntervalSince1970:timestampMin)
            dates.append(date)
        }
        
        return dates;
    }
    
    func convertToDateDay(_ day:Int,month:Int,year:Int) -> Date
    {
        components.calendar = calendar
        components.timeZone = timeZone
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        return components.date!
    }
    
    func getYearAndMonthAndDay(_ date:Date) -> Array<String>
    {
        var nowComponents = calendar.dateComponents([.year,.month,.day,.weekday,.hour,.minute,.second], from: Date())
        let year = nowComponents.year?.description
        let month = nowComponents.month?.description
        let day = nowComponents.day?.description
        return [year!,month!,day!]
    }
}
