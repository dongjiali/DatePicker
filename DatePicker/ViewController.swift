//
//  ViewController.swift
//  DatePicker
//
//  Created by Curry on 15/5/14.
//  Copyright (c) 2015年 curry. All rights reserved.
//

import UIKit


class ViewController: UIViewController,DatePickerChoiseDelegate {

    var datePicker = DatePickerViewController.new()
    @IBOutlet weak var dateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.preaSuperView = self.view
        datePicker.didChoiseDatePicker = self
    }

    @IBAction func clickButton(sender: AnyObject) {
        datePicker.showDatePickerView()
    }

    func didChoiseDatePicker(datePickerView: DatePickerView) {
        dateButton.setTitle(datePickerView.selectedDateString, forState:.Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

