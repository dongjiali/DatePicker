//
//  ViewController.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit


class ViewController: UIViewController,DatePickerChoiceDelegate {

    var datePicker = DatePickerViewController()
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preaSuperView = self.view
        datePicker.choiceDelegate = self
    }

    @IBAction func clickButton(_ sender: AnyObject) {
        datePicker.showDatePickerView()
    }
    
    func didChoiceDatePicker(_ datePickerView: DatePickerView) {
        dateButton.setTitle(datePickerView.selectedDateString, for:UIControlState())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

