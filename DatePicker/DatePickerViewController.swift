//
//  DatePickerViewController.swift
//  DatePicker
//
//  Created by Curry on 15/5/15.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit

class DatePickerViewController: UIViewController,DatePickerDelegate {
    
    var preaSuperView:UIView = UIView()
    var selectDate:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var pickerView = DatePickerView(frame: self.view.frame)
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.clearColor()
        self.view = pickerView
        self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.height)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDatePickerView()
    {
        //改变状态栏颜色
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        var keyWindow = UIApplication.sharedApplication().keyWindow
        keyWindow?.addSubview(self.view)
        
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectMake(0, -10, self.view.frame.size.width, self.view.frame.size.height);
            self.preaSuperView.transform = CGAffineTransformMakeScale(0.90, 0.90);
            self.preaSuperView.alpha = 0.6;
            self.preaSuperView.userInteractionEnabled = false;
            }) { (Bool) -> Void in
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                })
        }
    }
    
    func dismissDatePickerView()
    {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
            self.preaSuperView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.preaSuperView.alpha = 1.0;
        }) { (Bool) -> Void in
            self.preaSuperView.userInteractionEnabled = true;
            UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
            self.view.removeFromSuperview()
        }
    }
    
    
    func didSelectedItemDatePicker(datePickerView: DatePickerView) {
        selectDate = datePickerView.selectedDateString
        println(selectDate)
        self.dismissDatePickerView()
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
