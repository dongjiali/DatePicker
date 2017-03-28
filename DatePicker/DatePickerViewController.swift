//
//  DatePickerViewController.swift
//  DatePicker
//
//  Created by Curry on 15/5/15.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit

protocol DatePickerChoiceDelegate
{
    func didChoiceDatePicker(_ datePickerView: DatePickerView)
}

class DatePickerViewController: UIViewController,DatePickerDelegate {
    
    var preaSuperView:UIView = UIView()
    var selectDate:String = ""
    var choiceDelegate:DatePickerChoiceDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerView = DatePickerView(frame: self.view.frame)
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.clear
        self.view = pickerView
        self.view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.height)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showDatePickerView()
    {
        //改变状态栏颜色
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self.view)
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: -10, width: self.view.frame.size.width, height: self.view.frame.size.height);
            self.preaSuperView.transform = CGAffineTransform(scaleX: 0.90, y: 0.90);
            self.preaSuperView.alpha = 0.6;
            self.preaSuperView.isUserInteractionEnabled = false;
            }, completion: { (Bool) -> Void in
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height);
                })
        }) 
    }
    
    func dismissDatePickerView()
    {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height);
            self.preaSuperView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0);
            self.preaSuperView.alpha = 1.0;
        }, completion: { (Bool) -> Void in
            self.preaSuperView.isUserInteractionEnabled = true;
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
            self.view.removeFromSuperview()
        }) 
    }
    
    
    func didSelectedItemDatePicker(_ datePickerView: DatePickerView) {
        selectDate = datePickerView.selectedDateString
        choiceDelegate?.didChoiceDatePicker(datePickerView)
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
