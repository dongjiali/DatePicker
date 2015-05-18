//
//  ViewController.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var datePicker = DatePickerViewController.new()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preaSuperView = self.view
    }


    
    @IBAction func clickButton(sender: AnyObject) {
        datePicker.showDatePickerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

