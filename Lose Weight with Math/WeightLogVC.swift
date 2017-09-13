//
//  WeightLogVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/22/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import HealthKit

class WeightLogVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
//class WeightLogVC: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    //Outlets
    @IBOutlet weak var myDatePicker: UIDatePicker!
    @IBOutlet weak var weightOutlet: UITextField!
    @IBOutlet weak var dateOutlet: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    //var weight: [String] = []
    var logs: [NSManagedObject] = []
    
    var currentString: [String] = []
    var previousString: [String] = []
    var currentDouble: Double = 0
    var previousDouble: Double = 0
    
    var selectedDate: String = ""
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //Actions

    @IBAction func dateChange(_ sender: Any) {
        
        if myDatePicker.isHidden{
            myDatePicker.isHidden = false
            self.view.bringSubview(toFront: myDatePicker)
            view.endEditing(true)
            
        }
        else{
            myDatePicker.isHidden = true
            view.endEditing(true)
        }
        
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Apply date format
        selectedDate = dateFormatter.string(from: (sender as AnyObject).date)
        
        print("Selected value \(selectedDate)")
        dateOutlet.setTitle(selectedDate, for: .normal)
    }
    @IBAction func addWeight(_ sender: Any) {
        
        let defaults = UserDefaults.standard
        let dateText = defaults.string(forKey: "CurrentWeightDate")
        
        
        let weight: String = weightOutlet.text as String!
        let date: String = dateOutlet.currentTitle!
        
        let testWeight = Double(weight)

        if testWeight == nil{
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Weight", message: "Please enter a valid weight.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if weight == "Add Weight"{
            //Alert if user does not change default weight value.
            let alert = UIAlertController(title: "Invalid Weight", message: "Please enter a valid weight.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if weight == ""{
            //Alert if user leaves weight as nil
            let alert = UIAlertController(title: "Invalid Weight", message: "Please enter a valid weight.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if date == dateText{
            //Alert if user has already added an entry on current date
            let alert = UIAlertController(title: "Invalid Entry", message: "Weight Log already exists on today's date. Please remove your earlier entry and try again.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            //weight += " lbs"
            
            myDatePicker.isHidden = true
            view.endEditing(true)
        
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let dateString = dateFormatter.date(from: date)
            
            self.save(weight: weight, date: dateString!)
            coreDataSetup()
            self.tableView.reloadData()
            print("Table Reloaded Data")
            
            if self.previousDouble > self.currentDouble{
                let alert = UIAlertController(title: "Good Job!", message: "You've lost weight since your previous entry, looking good!", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Tap here if you will keep losing weight.", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            
        }
        
        view.endEditing(true)
        
        
    }
    func save(weight: String, date: Date) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Logs", in: managedContext)!
        
        let log = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        log.setValue(weight, forKeyPath: "weight")
        log.setValue(date, forKeyPath: "date")
        
        // 4
        do {
            try managedContext.save()
            logs.append(log)
            //logs.insert(log, at: 0)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //Required Classes
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Date Default Value
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        dateOutlet.setTitle(result, for: .normal)
        
        //Start picker hidden
        myDatePicker.isHidden = true
        myDatePicker.backgroundColor = UIColor.white
        
        //Date Button Attributes
        dateOutlet.backgroundColor = .clear
        dateOutlet.layer.cornerRadius = 3
        dateOutlet.layer.borderWidth = 0.5
        dateOutlet.layer.borderColor = UIColor.lightGray.cgColor
        //Weight Outlet Attributes
        weightOutlet.backgroundColor = .clear
        weightOutlet.layer.cornerRadius = 3
        weightOutlet.layer.borderWidth = 0.5
        weightOutlet.layer.borderColor = UIColor.lightGray.cgColor
        
        
        
        //Clear keyboard
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(logVC.dismissKeyboard))
//        view.addGestureRecognizer(tap)
        
        //Register TableView
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coreDataSetup()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    //Custom Classes
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
        myDatePicker.isHidden = true
    }
    
    func coreDataSetup(){
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Logs")
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        //3
        do {
            logs = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Using reversedRow algorithm to invert the order that data is displayed so the most recent entries appear at the top.
//        let reversedRow = Swift.abs(indexPath.row - logs.count + 1)
//        let log = logs[reversedRow]
        
        let log = logs[indexPath.row]
        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM/dd/yyy"
//        let newDate: Date = log.value(forKeyPath: "date") as! Date
//        let dateString = dateFormatter.string(from: newDate)
        
        //let selectedDate = dateFormatter.string(from: newDate)
            
        
        var weightString: String = log.value(forKeyPath: "weight") as! String
        weightString += " lbs"
        
        let tempDate = log.value(forKeyPath: "date") as? Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyy"
        let dateString = dateFormatter.string(from: tempDate!)
            //print(dateString)
        
        

        
        
        
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
            cell.textLabel?.text = weightString
            cell.detailTextLabel?.text = dateString
            
            let defaults = UserDefaults.standard
            
            defaults.set(weightString, forKey: "CurrentWeight")
            defaults.set(dateString, forKey: "CurrentWeightDate")
            currentString = weightString.components(separatedBy: " ")
            currentDouble = Double(currentString[0]) as Double!
            print("Saved \(weightString) into UserDefaults")
            return cell
        }
        else if indexPath.row == 1{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
            cell.textLabel?.text = weightString
            cell.detailTextLabel?.text = dateString
            
            previousString = weightString.components(separatedBy: " ")
            previousDouble = Double(previousString[0]) as Double!
            
            
            
            
            

            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)
            cell.textLabel?.text = weightString
            cell.detailTextLabel?.text = dateString
            return cell
        }
            
        
        
        
        
        
    }
    
    // EDIT CELL
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            //Using reversedRow algorithm to invert the order that data is displayed so the correct entries get deleted.
//            let reversedRow = Swift.abs(indexPath.row - logs.count + 1)
//            context.delete(logs[reversedRow])
            context.delete(logs[indexPath.row])
            do {
                try context.save()
                //tableView.deleteRows(at: [indexPath], with:.fade)
                //tableView.reloadData()
                self.logs.remove(at: indexPath.row) //replace with reversed
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                coreDataSetup()
                
                
                
                
                let log = logs[0]
                
                var weightString: String = log.value(forKeyPath: "weight") as! String
                weightString += " lbs"
                
                let tempDate = log.value(forKeyPath: "date") as? Date
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyy"
                let dateString = dateFormatter.string(from: tempDate!)
                
                let defaults = UserDefaults.standard

                defaults.set(dateString, forKey: "CurrentWeightDate")
                
                
                
                
                
                
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            print("Deleted")
            //tableView.reloadData()
        }
    }
    
    
    var weightToPass:String!
    var dateToPass:String!
    var weightChangeToPass:String!
    var caloricIntakeToPass:String!
    var caloriesBurnedToPass:String!
    var timeExercisingToPass:String!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get Cell Label
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell!
        
        //Get Weight and Date from label to pass into details screen
        weightToPass = currentCell?.textLabel?.text
        dateToPass = currentCell?.detailTextLabel?.text
        weightChangeToPass = "N/A"
        caloricIntakeToPass = "N/A"
        caloriesBurnedToPass = "N/A"
        timeExercisingToPass = "N/A"
        //self.performSegue(withIdentifier: "toWeightLogDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toWeightLogDetails") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! WeightLogDetailsVC
            // your new view controller should have property that will store passed value
            viewController.weight = weightToPass
            viewController.date = dateToPass
        }
    }
    
}
