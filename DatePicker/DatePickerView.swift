//
//  DatePickerView.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


let HEADERVIEWHEIGHT:CGFloat = 50.0
let PICKERVIEWHEIGHT:CGFloat = 220.0

protocol DatePickerDelegate
{
    func didSelectedItemDatePicker(_ datePickerView: DatePickerView)
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
    var cancelButton:UIButton = UIButton.init(type:.custom)
    var doneButton:UIButton = UIButton.init(type:.custom)
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
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
        pickerDataArray.append(datePickerSource.getDaysInMonth(Date()))
    }
    
    func buildViewControl()
    {
        let button:UIButton = UIButton.init(type:.custom)
        button.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - 270)
        button.backgroundColor = UIColor.clear
        button .addTarget(self, action:#selector(click), for: UIControlEvents.touchUpInside)
        self.addSubview(button)
        
        let pickerView:UIView = UIView(frame: CGRect(x: 0, y: self.frame.size.height - 270, width: self.frame.size.width, height: 270))
        pickerView.backgroundColor = UIColor.clear
        self.addSubview(pickerView)
        //add header view
        self.addHeaderView(pickerView)
        //add picker view
        self.addPickerView(pickerView)
    }
    
    func click() {
        
    }
    
    func addHeaderView(_ subView:UIView)
    {
        let headerView:UIView = UIView(frame:CGRect(x: 0.0, y: 0.0, width: subView.frame.size.width, height: HEADERVIEWHEIGHT+5))
        headerView.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        headerView.layer.cornerRadius = 5.0
        subView.addSubview(headerView)
        
        let label:UILabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: CGFloat(subView.frame.size.width), height: HEADERVIEWHEIGHT))
        label.text = "请选择日期"
        label.textAlignment = NSTextAlignment.center
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 18.0)
        headerView.addSubview(label)
        
        //cancel
        cancelButton.setTitle("取消", for: UIControlState())
        cancelButton.backgroundColor = UIColor.clear
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        cancelButton.setTitleColor(UIColor.white, for: UIControlState())
        cancelButton.frame = CGRect(x: 0.0, y: 0.0, width: 60.0, height: HEADERVIEWHEIGHT)
        cancelButton.tag = -1
        headerView.addSubview(cancelButton)
        cancelButton.addTarget(self, action: #selector(DatePickerView.cancelButtonClick(_:)), for: UIControlEvents.touchUpInside)
        
        //done
        doneButton.setTitle("确定", for: UIControlState())
        doneButton.backgroundColor = UIColor.clear
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18.0)
        doneButton.setTitleColor(UIColor.white, for: UIControlState())
        doneButton.frame = CGRect(x: headerView.frame.size.width - 60.0 , y: 0.0, width: 60.0, height: HEADERVIEWHEIGHT);
        doneButton.tag = 250;
        headerView.addSubview(doneButton)
        doneButton.addTarget(self, action: #selector(DatePickerView.doneButtonClick(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func addPickerView(_ subView:UIView)
    {
        
        let bottomView:UIView = UIView(frame:CGRect(x: 0.0, y: HEADERVIEWHEIGHT, width: subView.frame.size.width, height: PICKERVIEWHEIGHT + 10.0))
        bottomView.backgroundColor = UIColor.white
        subView.addSubview(bottomView)
        
        
        //add highlight selected view
        let barSelected:UIView = UIView(frame: CGRect(x: 0, y: 220/2.0 - 44/2.0, width: subView.frame.size.width, height: 44.0))
        barSelected.backgroundColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1)
        bottomView.addSubview(barSelected)
        
        //add picker view
        pickerArray.removeAll(keepingCapacity: true)
        
        var nowDate = datePickerSource.getYearAndMonthAndDay(Date())
        yearString = nowDate[0]
        monthString = nowDate[1]
        dayString = nowDate[2]
        self.setSelectedDate()
        for i in 0 ..< pickerDataArray.count
        {
            let pickerWidth:CGFloat = self.frame.size.width / 3;
            let pickframe:CGRect = CGRect(x: pickerWidth*CGFloat(i), y: 0.0, width: pickerWidth, height: PICKERVIEWHEIGHT)
            let lineLayout:DatePickerFlowLayout = DatePickerFlowLayout(size: CGSize(width: pickerWidth, height: 44.0))
            let pickerView = DatePickerCollectionView(frame: pickframe, collectionViewLayout: lineLayout)
            pickerView.cellItemArray = pickerDataArray[i] as [(String)]
            pickerView.pickerDelegate = self
            let cellArray:NSArray = pickerView.cellItemArray as NSArray
            pickerView.selectedItemTag = cellArray.index(of: nowDate[i])
            pickerView.setCollectionViewOfContentOffset()
            pickerArray.append(pickerView)
            pickerView.tag = i
            bottomView.addSubview(pickerView)
            if i > 0
            {
                let line = UIView(frame: CGRect(x: pickframe.size.width*CGFloat(i), y: 0, width: 1.0, height: PICKERVIEWHEIGHT))
                line.backgroundColor = UIColor(white: 0.8, alpha: 1)
                bottomView.addSubview(line)
            }
        }
        self.addGradientLayer(bottomView)
    }
    
    func addGradientLayer(_ subView:UIView)
    {
        
        let gradientLayerTop = CAGradientLayer()
        gradientLayerTop.frame = CGRect(x: 0.0, y: 0.0, width: subView.frame.size.width, height: PICKERVIEWHEIGHT/2.0)
        gradientLayerTop.colors = [UIColor(white: 1.0, alpha: 0).cgColor,subView.backgroundColor!.cgColor]
        gradientLayerTop.startPoint = CGPoint(x: 0.0, y: 0.7)
        gradientLayerTop.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        let gradientLayerBottom = CAGradientLayer()
        gradientLayerBottom.frame = CGRect(x: 0.0, y: PICKERVIEWHEIGHT/2.0, width: subView.frame.size.width, height: PICKERVIEWHEIGHT/2.0)
        gradientLayerBottom.colors = gradientLayerTop.colors
        gradientLayerBottom.startPoint = CGPoint(x: 0.0, y: 0.3);
        gradientLayerBottom.endPoint = CGPoint(x: 0.0, y: 1.0);
        
        subView.layer .addSublayer(gradientLayerTop)
        subView.layer .addSublayer(gradientLayerBottom)
    }
    
    
    func cancelButtonClick(_ button:UIButton)
    {
        delegate?.didSelectedItemDatePicker(self)
    }
    
    func doneButtonClick(_ button:UIButton)
    {
        delegate?.didSelectedItemDatePicker(self)
    }
    
    //    TODO PickerValueChangeDelegate
    func didEndDecelerating(_ collectionView: DatePickerCollectionView)
    {
        switch collectionView.tag
        {
        case 0:
            yearString = collectionView.cellItemArray[collectionView.selectedItemTag!]
            self.getDaysInYearAndMonth(Int(yearString)!, month: Int(monthString)!, day: Int(dayString)!)
        case 1:
            monthString = collectionView.cellItemArray[collectionView.selectedItemTag!]
            self.getDaysInYearAndMonth(Int(yearString)!, month: Int(monthString)!, day: Int(dayString)!)
        case 2:
            dayString = collectionView.cellItemArray[collectionView.selectedItemTag!]
        default:
            break
        }
        self.setSelectedDate()
        cancelButton.isEnabled = true
        doneButton.isEnabled = true
    }
    
    func DidScroll(_ collectionView: DatePickerCollectionView)
    {
        cancelButton.isEnabled = false
        doneButton.isEnabled = false
    }
    
    func getDaysInYearAndMonth(_ year:Int,month:Int,day:Int)
    {
        let date = datePickerSource.convertToDateDay(1, month: month, year: year)
        let days = datePickerSource.getDaysInMonth(date)
        let dayCollectionView:DatePickerCollectionView = pickerArray[2] as! DatePickerCollectionView
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
