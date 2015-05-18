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
    var calendar = NSCalendar.init(calendarIdentifier:NSCalendarIdentifierGregorian)
    var timeZone = NSTimeZone.new()
    var components = NSDateComponents.new()
    
    func getYears() -> Array<String>
    {
        var years = [String]()
        let unitFlags = NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit|NSCalendarUnit.WeekdayCalendarUnit|NSCalendarUnit.HourCalendarUnit|NSCalendarUnit.MinuteCalendarUnit|NSCalendarUnit.SecondCalendarUnit
        components = calendar!.components(unitFlags, fromDate: NSDate.new())
        StartYear = components.year - YESTSPACEYEAR;
        EndYear = components.year + LASTSPACEYEAR;
        
        for var y = StartYear; y <= EndYear; y++
        {
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
    
    func getDaysInMonth(mdate:NSDate) -> Array<String>
    {
        
        var days = [String]()
        let daysRange = calendar?.rangeOfUnit(NSCalendarUnit.DayCalendarUnit, inUnit: NSCalendarUnit.MonthCalendarUnit, forDate: mdate)
        for d in 1...daysRange!.length
        {
            days.append(d.description)
        }
        
        return days
    }
    
    func getDates() ->Array<NSDate>
    {
        var dates:[NSDate] = Array()
        components.calendar = calendar
        components.timeZone = timeZone
        components.year = StartYear
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        components.second = 0
        
        let yearMin:NSDate = components.date!
        let yearMax:NSDate = NSDate.new()
        
        let timestampMin = yearMin.timeIntervalSince1970
        let timestampMax = yearMax.timeIntervalSince1970
        
        while timestampMin < timestampMax
        {
            let date = NSDate.init(timeIntervalSince1970:timestampMin)
            dates.append(date)
        }
        
        return dates;
    }
    
    func convertToDateDay(day:Int,month:Int,year:Int) -> NSDate
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
    
    func getYearAndMonthAndDay(date:NSDate) -> Array<String>
    {
        let unitFlags = NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit|NSCalendarUnit.WeekdayCalendarUnit|NSCalendarUnit.HourCalendarUnit|NSCalendarUnit.MinuteCalendarUnit|NSCalendarUnit.SecondCalendarUnit
        var nowComponents = calendar!.components(unitFlags, fromDate: NSDate.new())
        var year = nowComponents.year.description
        var month = nowComponents.month.description
        var day = nowComponents.day.description
        return [year,month,day]
    }
}
