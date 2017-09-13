//
//  ConfirmFoodVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 8/8/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ConfirmFoodVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Data passing through from SearchFoodVC
    var emoji: String!
    var food: String!
    var servings: String!
    var servingSizeRaw: String!
    var baseCalories: String!
    var calories: String!
    var ndbno: String!
    
    //Variables
    var meals: Array = ["Breakfast", "Lunch", "Dinner", "Snack"]
    var servingSize = Array(1...50)
    var servingMultiplier: Int! = 1
    
    var servingLabel: String!
    
    var timer = Timer()
    
    var newCalories: String!
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        print("Updating")
        self.caloriesOutlet.text = self.newCalories
    }
    
    
    //Outlets
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mealOutlet: UILabel!
    @IBOutlet weak var mealPicker: UIPickerView!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var servingsPicker: UIPickerView!
    @IBOutlet weak var caloriesOutlet: UILabel!
    
    
    //Actions
    @IBAction func savePressed(_ sender: Any) {
        
        if mealOutlet.text != ""{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let task = Foods(context: context)
            
            task.emoji = emoji
            task.name = food
            
            //Convert label text to NSDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy" //Your date format
            dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
            let dateNew = dateFormatter.date(from: dateLabel.text!) //according to date format your date string
            
            task.date = dateNew
            task.meal = mealOutlet.text
            task.servings = String(servingMultiplier)
            task.calories = caloriesOutlet.text
            task.servingSize = servingSizeRaw
            task.ndbno = ndbno
            
            //Save the data to CoreData
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            print("CoreData has been saved to")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InitialView") as! UITabBarController
            vc.selectedIndex = 2
            present(vc, animated: true, completion: nil)
            
        }
        else{
            
            let alert = UIAlertController(title: "Invalid Meal", message: "Please enter a valid meal.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        var selectedDate: String = ""
        // Create date formatter

        let formatter: DateFormatter = DateFormatter()
        
        // Set date format
        formatter.dateFormat = "MM/dd/yyyy"
        
        // Apply date format
        selectedDate = formatter.string(from: datePicker.date)
        
        print("Selected value \(selectedDate)")
        dateLabel.text = selectedDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Confirm Food View Loaded")

        mealPicker.delegate = self
        servingsPicker.delegate = self
        
        
        //Load label values
        emojiLabel.text = emoji
        foodLabel.text = food
        servingsLabel.text = servings
        caloriesOutlet.text = calories

        dateLabelSetup()
        
        print(emoji)
        print(food)
        print(servings)
        print(servingSizeRaw)
        print(baseCalories)
        print(calories)
        print(ndbno)
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the navigation bar on other view controllers

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }
    
    func dateLabelSetup () {
        //Set Date Default Value
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        dateLabel.text = result
    }
    
    
    
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleMealpicker() {
        
        mealPickerHidden = !mealPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleServingspicker() {
        
        servingsPickerHidden = !servingsPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            toggleDatepicker()
        }
        else if indexPath.section == 0 && indexPath.row == 3 {
            toggleMealpicker()
        }
        else if indexPath.section == 0 && indexPath.row == 5 {
            toggleServingspicker()
        }
    }
    var datePickerHidden = true
    var mealPickerHidden = true
    var servingsPickerHidden = true
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 2 {
            return 0
        }
        else if mealPickerHidden && indexPath.section == 0 && indexPath.row == 4 {
            return 0
        }
        else if servingsPickerHidden && indexPath.section == 0 && indexPath.row == 6 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    //Picker View Functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == mealPicker {
            return meals.count
        }
        else if pickerView == servingsPicker{
            return servingSize.count
        }
        else{
            return 1
        }
        
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == mealPicker{
            return meals[row]
        }
        else {
            //else if pickerView == activityPicker{
            return String(servingSize[row])
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == mealPicker {
            mealOutlet.text = meals[row]
            
        }
        else if pickerView == servingsPicker {
            
            
            if timer.isValid{
                
            }
            else{
                scheduledTimerWithTimeInterval()
            }
            
            
            servingsLabel.text = " \(String(servingSize[row])) serving(s)"
            
            servingMultiplier = servingSize[row]
            
            calculateCalories()

        }
    }
    
    func calculateCalories(){
        let calculatedDouble: Double =  Double(self.baseCalories)!
    
        let calculated = calculatedDouble * Double(self.servingMultiplier)
    
        let calculatedInt = Int(calculated)
    
        let subtitleString = "\(calculatedInt)"
    
        self.newCalories = subtitleString
    
    }
}
