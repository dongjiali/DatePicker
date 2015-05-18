//
//  DatePickerView.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit

let HEADERVIEWHEIGHT:CGFloat = 50.0
let PICKERVIEWHEIGHT:CGFloat = 220.0

protocol DatePickerDelegate
{
    func didSelectedItemDatePicker(datePickerView: DatePickerView)
}

class DatePickerView: UIView,PickerValueChangeDelegate{
    
    var pickerArray = [AnyObject]()
    var pickerDataArray = [Array<String>]()
    var datePickerSource = DatePickerSource()
    var delegate:DatePickerDelegate?
    var selectedDateString:String = ""
    var yearString:String = ""
    var monthString:String = ""
    var dayString:String = ""
    var cancelButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    var doneButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        self.buildViewControl()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initPickerDateSource()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initPickerDateSource()
    {
        pickerDataArray = []
        pickerDataArray.append(datePickerSource.getYears())
        pickerDataArray.append(datePickerSource.getMonths())
        pickerDataArray.append(datePickerSource.getDaysInMonth(NSDate.new()))
    }
    
    func buildViewControl()
    {
        var button:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        button.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 270)
        button.backgroundColor = UIColor.clearColor()
        button .addTarget(self, action:nil, forControlEvents: UIControlEvents.TouchUpInside)
        self .addSubview(button)
        
        var pickerView:UIView = UIView(frame: CGRectMake(0, self.frame.size.height - 270, self.frame.size.width, 270))
        pickerView.backgroundColor = UIColor.clearColor()
        self.addSubview(pickerView)
        //add header view
        self.addHeaderView(pickerView)
        //add picker view
        self.addPickerView(pickerView)
    }
    
    func addHeaderView(subView:UIView)
    {
        var headerView:UIView = UIView(frame:CGRectMake(0.0, 0.0, subView.frame.size.width, HEADERVIEWHEIGHT+5))
        headerView.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        headerView.layer.cornerRadius = 5.0
        subView.addSubview(headerView)
        
        var label:UILabel = UILabel(frame: CGRectMake(0.0, 0.0, CGFloat(subView.frame.size.width), HEADERVIEWHEIGHT))
        label.text = "请选择日期"
        label.textAlignment = NSTextAlignment.Center
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(18.0)
        headerView.addSubview(label)
        
        //cancel
        cancelButton.setTitle("取消", forState: UIControlState.Normal)
        cancelButton.backgroundColor = UIColor.clearColor()
        cancelButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        cancelButton.frame = CGRectMake(0.0, 0.0, 60.0, HEADERVIEWHEIGHT)
        cancelButton.tag = -1
        headerView.addSubview(cancelButton)
        cancelButton.addTarget(self, action: "cancelButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //done
        doneButton.setTitle("确定", forState: UIControlState.Normal)
        doneButton.backgroundColor = UIColor.clearColor()
        doneButton.titleLabel?.font = UIFont.boldSystemFontOfSize(18.0)
        doneButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        doneButton.frame = CGRectMake(headerView.frame.size.width - 60.0 , 0.0, 60.0, HEADERVIEWHEIGHT);
        doneButton.tag = 250;
        headerView.addSubview(doneButton)
        doneButton.addTarget(self, action: "doneButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addPickerView(subView:UIView)
    {
        
        var bottomView:UIView = UIView(frame:CGRectMake(0.0, HEADERVIEWHEIGHT, subView.frame.size.width, PICKERVIEWHEIGHT + 10.0))
        bottomView.backgroundColor = UIColor.whiteColor()
        subView.addSubview(bottomView)
        
        
        //add highlight selected view
        var barSelected:UIView = UIView(frame: CGRectMake(0, 220/2.0 - 44/2.0, subView.frame.size.width, 44.0))
        barSelected.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        bottomView.addSubview(barSelected)
        
        //add picker view
        pickerArray.removeAll(keepCapacity: true)
        
        var nowDate = datePickerSource.getYearAndMonthAndDay(NSDate.new())
        yearString = nowDate[0]
        monthString = nowDate[1]
        dayString = nowDate[2]
        self.setSelectedDate()
        for var i = 0;i<pickerDataArray.count;i++
        {
            let pickerWidth:CGFloat = self.frame.size.width / 3;
            var pickframe:CGRect = CGRectMake(pickerWidth*CGFloat(i), 0.0, pickerWidth, PICKERVIEWHEIGHT)
            var lineLayout:DatePickerFlowLayout = DatePickerFlowLayout(size: CGSizeMake(pickerWidth, 44.0))
            var pickerView = DatePickerCollectionView(frame: pickframe, collectionViewLayout: lineLayout)
            pickerView.cellItemArray = pickerDataArray[i] as [(String)]
            pickerView.pickerDelegate = self
            let cellArray:NSArray = pickerView.cellItemArray
            pickerView.selectedItemTag = cellArray.indexOfObject(nowDate[i])
            pickerView.setCollectionViewOfContentOffset()
            pickerArray.append(pickerView)
            pickerView.tag = i
            bottomView.addSubview(pickerView)
            if i > 0
            {
                var line = UIView(frame: CGRectMake(pickframe.size.width*CGFloat(i), 0, 1.0, PICKERVIEWHEIGHT))
                line.backgroundColor = UIColor(white: 0.8, alpha: 1)
                bottomView.addSubview(line)
            }
        }
        self.addGradientLayer(bottomView)
    }
    
    func addGradientLayer(subView:UIView)
    {
        
        var gradientLayerTop = CAGradientLayer()
        gradientLayerTop.frame = CGRectMake(0.0, 0.0, subView.frame.size.width, PICKERVIEWHEIGHT/2.0)
        gradientLayerTop.colors = [UIColor(white: 1.0, alpha: 0).CGColor,subView.backgroundColor!.CGColor]
        gradientLayerTop.startPoint = CGPointMake(0.0, 0.7)
        gradientLayerTop.endPoint = CGPointMake(0.0, 0.0)
        
        var gradientLayerBottom = CAGradientLayer()
        gradientLayerBottom.frame = CGRectMake(0.0, PICKERVIEWHEIGHT/2.0, subView.frame.size.width, PICKERVIEWHEIGHT/2.0)
        gradientLayerBottom.colors = gradientLayerTop.colors
        gradientLayerBottom.startPoint = CGPointMake(0.0, 0.3);
        gradientLayerBottom.endPoint = CGPointMake(0.0, 1.0);
        
        subView.layer .addSublayer(gradientLayerTop)
        subView.layer .addSublayer(gradientLayerBottom)
    }
    
    
    func cancelButtonClick(button:UIButton)
    {
        delegate?.didSelectedItemDatePicker(self)
    }
    
    func doneButtonClick(button:UIButton)
    {
        delegate?.didSelectedItemDatePicker(self)
    }
    
    //    TODO PickerValueChangeDelegate
    func didEndDecelerating(collectionView: DatePickerCollectionView)
    {
        switch collectionView.tag
        {
        case 0:
            yearString = collectionView.cellItemArray[collectionView.selectedItemTag!]
            self.getDaysInYearAndMonth(yearString.toInt()!, month: monthString.toInt()!, day: dayString.toInt()!)
        case 1:
            monthString = collectionView.cellItemArray[collectionView.selectedItemTag!]
            self.getDaysInYearAndMonth(yearString.toInt()!, month: monthString.toInt()!, day: dayString.toInt()!)
        case 2:
            dayString = collectionView.cellItemArray[collectionView.selectedItemTag!]
        default:
            break
        }
        self.setSelectedDate()
        cancelButton.enabled = true
        doneButton.enabled = true
    }
    
    func DidScroll(collectionView: DatePickerCollectionView)
    {
        cancelButton.enabled = false
        doneButton.enabled = false
    }
    
    func getDaysInYearAndMonth(year:Int,month:Int,day:Int)
    {
        let date = datePickerSource.convertToDateDay(1, month: month, year: year)
        var days = datePickerSource.getDaysInMonth(date)
        var dayCollectionView:DatePickerCollectionView = pickerArray[2] as! DatePickerCollectionView
        pickerDataArray[2] = days
        dayCollectionView.cellItemArray = pickerDataArray[2]
        if dayCollectionView.selectedItemTag >= pickerDataArray[2].count {
            dayCollectionView.selectedItemTag = pickerDataArray[2].count - 1;
        }
        dayCollectionView.reloadData()
    }
    
    func setSelectedDate()
    {
        selectedDateString = yearString + "-" + monthString + "-" + dayString
    }
}
