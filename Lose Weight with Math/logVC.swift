//
//  logVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/20/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//


import Foundation
import UIKit

class logVC: UIViewController {
    
    @IBOutlet weak var weightOutlet: UITextField!
    @IBOutlet weak var dateOutlet: UITextField!
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
        // Create a DatePicker
        let datePicker: UIDatePicker = UIDatePicker()
        
        // Posiiton date picket within a view
        datePicker.frame = CGRect(x: 10, y: 50, width: self.view.frame.width, height: 200)
        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.backgroundColor = UIColor.white
        
        // Add an event to call onDidChangeDate function when value is changed.
        datePicker.addTarget(self, action: #selector(logVC.datePickerValueChanged(_:)), for: .valueChanged)
        
        // Add DataPicker to the view
        view.addSubview(datePicker)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
    }
    
    
    
    
    
    
    
    
    
    

    
}

