//
//  MyProfileVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/26/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MyProfileVC: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    //Outlets
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    @IBOutlet weak var ageOutlet: UITextField!
    @IBOutlet weak var dateOfBirthOutlet: UILabel!
    @IBOutlet weak var genderOutlet: UILabel!
    @IBOutlet weak var heightField: UILabel!
    @IBOutlet weak var startingWeightOutlet: UITextField!
    @IBOutlet weak var currentWeightOutlet: UILabel!
    @IBOutlet weak var goalWeightOutlet: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var heightPicker: UIPickerView!
    
    
    //Actions
    @IBAction func firstNameAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(firstNameOutlet.text, forKey: "FirstName")
    }
    @IBAction func lastNameAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(lastNameOutlet.text, forKey: "LastName")
    }
    @IBAction func ageAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(ageOutlet.text, forKey: "Age")
    }
    @IBAction func startingWeightAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(startingWeightOutlet.text, forKey: "StartWeight")
    }
    @IBAction func goalWeightAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(goalWeightOutlet.text, forKey: "GoalWeight")
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        //var selectedDate: String = ""
        
        
        
        
        //print("Selected value \(selectedDate)")
        //dateOfBirthOutlet.text = selectedDate
        
        let defaults = UserDefaults.standard
        
        var dateOfBirthText = defaults.string(forKey: "DateOfBirth")
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
        // Apply date format
        dateOfBirthText = dateFormatter.string(from: (sender as AnyObject).date)
        
        dateOfBirthOutlet.text = dateOfBirthText
        defaults.set(dateOfBirthText, forKey: "DateOfBirth")
    }
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleGenderpicker() {
        
        genderPickerHidden = !genderPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleHeightpicker() {
        
        heightPickerHidden = !heightPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    //Variables
    
    var datePickerHidden = true
    var heightPickerHidden = true
    var genderPickerHidden = true
    
    var heightArrayFeet = ["1'", "2'", "3'", "4'", "5'", "6'", "7'", "8'"]
    var heightArrayInches = ["1\"", "2\"", "3\"", "4\"", "5\"", "6\"", "7\"", "8\"", "9\"", "10\"", "11\""]
    
    var genderArray = ["Male", "Female"]
    
    //var currentWeightVarialbe: String!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Logs] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.navigationController?.navigationBar.tintColor = .white
        //Pickerview delegate setup

        genderPicker.delegate = self
        heightPicker.delegate = self
        
        datePickerChanged()
        
        //Initialize Fields with UserDefaults
        let defaults = UserDefaults.standard
        
        let firstNameText = defaults.string(forKey: "FirstName")
        let lastNameText = defaults.string(forKey: "LastName")
        let ageText = defaults.string(forKey: "Age")
        let dateOfBirthText = defaults.string(forKey: "DateOfBirth")
        let genderText = defaults.string(forKey: "Gender")
        let heightText = defaults.string(forKey: "Height")
        let startWeightText = defaults.string(forKey: "StartWeight")
        let weightText = defaults.string(forKey: "CurrentWeight")
        let goalWeightText = defaults.string(forKey: "GoalWeight")
        
        
        firstNameOutlet.text = firstNameText
        lastNameOutlet.text = lastNameText
        ageOutlet.text = ageText
        dateOfBirthOutlet.text = dateOfBirthText
        genderOutlet.text = genderText
        heightField.text = heightText
        startingWeightOutlet.text = startWeightText
        currentWeightOutlet.text = weightText
        goalWeightOutlet.text = goalWeightText
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func datePickerChanged () {
        //Set Date Default Value
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        dateOfBirthOutlet.text = result
    }
    
    
    
    
    //TableView Functions
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 4 {
            return 0
        }
        else if genderPickerHidden && indexPath.section == 0 && indexPath.row == 6 {
            return 0
        }
        else if heightPickerHidden && indexPath.section == 0 && indexPath.row == 8 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    //PickerView Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == heightPicker{
            return 2
        }
        else{
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 {
            toggleDatepicker()
        }
        else if indexPath.section == 0 && indexPath.row == 5 {
            toggleGenderpicker()
        }
        else if indexPath.section == 0 && indexPath.row == 7 {
            toggleHeightpicker()
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == heightPicker {
            if component == 0{
                return heightArrayFeet.count
            }
            else{
                return heightArrayInches.count
            }
        }
        else if pickerView == genderPicker{
            return 2
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == heightPicker {
            if component == 0 {
                return heightArrayFeet[row]
            }
            else{
                return heightArrayInches[row]
            }
        }
        else{
            return genderArray[row]
        }
        
    }
    
    var firstComponentString: String = ""
    var secondComponentString: String = ""
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == heightPicker {
  
            if component == 0 {
                firstComponentString = String(heightArrayFeet[row])
            }
            else if component == 1 {
                secondComponentString = String(heightArrayInches[row])
            }
            
            //firstComponentString.append("'")
            //secondComponentString.append("\"")
            let displayString = "\(firstComponentString)\(secondComponentString)"
            print(displayString)
            
            heightField.text = displayString
            
            let defaults = UserDefaults.standard
            
            defaults.set(displayString, forKey: "Height")
        }
        else if pickerView == genderPicker {
            genderOutlet.text = genderArray[row]
            let defaults = UserDefaults.standard
            
            defaults.set(genderArray[row], forKey: "Gender")
        }
    }
}
