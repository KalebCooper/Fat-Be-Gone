//
//  MyGoalsVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/26/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MyGoalsVC: UITableViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    //Outlets

    @IBOutlet weak var goalWeightOutlet: UITextField!
    @IBOutlet weak var weightLossOutlet: UILabel!
    @IBOutlet weak var weightLossPicker: UIPickerView!
    @IBOutlet weak var activityLevelOutlet: UILabel!
    @IBOutlet weak var activityPicker: UIPickerView!
    
    //Actions
    @IBAction func goalWeightEdited(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        defaults.set(goalWeightOutlet.text, forKey: "GoalWeight")
    }
    
    //Variables
    var activityLevelArray = ["Sedentary", "Light Activity", "Moderate Activity", "Very Active"]
    
    var desiredLossArray = ["Maintain Weight", "0.5 pounds / week", "1.0 pound / week", "1.5 pounds / week", "2.0 pounds / week"]
    
    var weightLossPickerHidden = true
    var activityPickerHidden = true
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [UserHealth] = []
    var logs: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController?.navigationBar.tintColor = .white
        
        weightLossPicker.delegate = self
        activityPicker.delegate = self
        
        
        do {
            tasks = try context.fetch(UserHealth.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        
        let task = tasks[tasks.count-1]
        
        if let goalWeight = task.goalWeight {
            goalWeightOutlet.text = goalWeight
        }
        if let desired = task.desiredLoss {
            weightLossOutlet.text = desired
        }
        if let activity = task.activityLevel {
            activityLevelOutlet.text = activity
        }
        
        let defaults = UserDefaults.standard
        
        let goalWeightText = defaults.string(forKey: "GoalWeight")
        let weightLossText = defaults.string(forKey: "DesiredWeight")
        let activityText = defaults.string(forKey: "ActivityLevel")
        
        goalWeightOutlet.text = goalWeightText
        weightLossOutlet.text = weightLossText
        activityLevelOutlet.text = activityText
        
        print(task)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // No need for semicolon
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    //Core Data FUnctions
    
    
    
    
    //Table View Functions
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            toggleDesiredpicker()
        }
        else if indexPath.section == 0 && indexPath.row == 3 {
            toggleActivitypicker()
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if weightLossPickerHidden && indexPath.section == 0 && indexPath.row == 2 {
            return 0
        }
        else if activityPickerHidden && indexPath.section == 0 && indexPath.row == 4 {
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
        if pickerView == weightLossPicker {
            return desiredLossArray.count
        }
        else if pickerView == activityPicker{
            return activityLevelArray.count
        }
        else{
          return 1
        }

        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == weightLossPicker{
            return desiredLossArray[row]
        }
        else {
        //else if pickerView == activityPicker{
            return activityLevelArray[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserHealth", in: managedContext)!
        
        let log = NSManagedObject(entity: entity, insertInto: managedContext)
        
        
        
        if pickerView == weightLossPicker {
            weightLossOutlet.text = desiredLossArray[row]
            log.setValue(desiredLossArray[row], forKeyPath: "desiredLoss")

            
            
            do {
                try managedContext.save()
                print("Saved \(desiredLossArray[row]) to CoreData")
                //logs.append(log)
                //logs.insert(log, at: 0)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            let defaults = UserDefaults.standard
            
            defaults.set(desiredLossArray[row], forKey: "DesiredWeight")
            
        }
        else if pickerView == activityPicker {
            activityLevelOutlet.text = activityLevelArray[row]
            log.setValue(activityLevelArray[row], forKeyPath: "activityLevel")
            
            
            do {
                try managedContext.save()
                print("Saved \(activityLevelArray[row]) to CoreData")
                //logs.append(log)
                //logs.insert(log, at: 0)
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            print(log)
            let defaults = UserDefaults.standard
            
            defaults.set(activityLevelArray[row], forKey: "ActivityLevel")
            
        }
        
        
    }
    func toggleActivitypicker() {
        
        activityPickerHidden = !activityPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleDesiredpicker() {
        
        weightLossPickerHidden = !weightLossPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    
}
