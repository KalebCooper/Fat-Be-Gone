//
//  DayOverviewVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/26/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import LocalAuthentication
import WatchConnectivity
import HealthKit

class DayOverviewVC: UITableViewController, WCSessionDelegate {
    
    
    //Food Variables
    var breakfastEmoji: [String] = []
    var breakfastName: [String] = []
    var breakfastServings: [String] = []
    var breakfastServingSize: [String] = []
    var breakfastCalories: [String] = []
    var breakfastNDBNO: [String] = []
    
    var lunchEmoji: [String] = []
    var lunchName: [String] = []
    var lunchServings: [String] = []
    var lunchServingSize: [String] = []
    var lunchCalories: [String] = []
    var lunchNDBNO: [String] = []
    
    var dinnerEmoji: [String] = []
    var dinnerName: [String] = []
    var dinnerServings: [String] = []
    var dinnerServingSize: [String] = []
    var dinnerCalories: [String] = []
    var dinnerNDBNO: [String] = []
    
    var snackEmoji: [String] = []
    var snackName: [String] = []
    var snackServings: [String] = []
    var snackServingSize: [String] = []
    var snackCalories: [String] = []
    var snackNDBNO: [String] = []
    
    
    var foodCalorieTotal: Int! = 0
    
    var breakfastCalorieTotal: Int! = 0
    var lunchCalorieTotal: Int! = 0
    var dinnerCalorieTotal: Int! = 0
    var snackCalorieTotal: Int! = 0
    var exerciseCalorieTotal: Int! = 0
    
    
    
    //Variables
    var weightString: String!
    var weightInKg: Double!
    var heightString: String!
    var heightinCm: Double!
    var ageString: String!
    var ageYears: Double!
    var genderString: String!
    
    var desiredLoss: String!
    var activityLevel: String!
    var activityDouble: Double = 1.0;
    
    var bmrDouble: Double!
    var bmrString: String!
    
    var desiredLossArray = ["Maintain Weight", "0.5 pounds / week", "1.0 pound / week", "1.5 pounds / week", "2.0 pounds / week"]
    
    var activityLevelArray = ["Sedentary", "Light Activity", "Moderate Activity", "Very Active"]
    
    //Outlets
    @IBOutlet weak var bmrOutlet: UILabel!
    @IBOutlet weak var foodCaloriesOutlet: UILabel!
    @IBOutlet weak var exerciseCaloriesOutlet: UILabel!
    @IBOutlet weak var remainingCaloriesOutlet: UILabel!
    
    @IBOutlet weak var breakfastCalorieOutlet: UILabel!
    @IBOutlet weak var lunchCalorieOutlet: UILabel!
    @IBOutlet weak var dinnerCalorieOutlet: UILabel!
    @IBOutlet weak var snackCalorieOutlet: UILabel!
    
    //Actions
    
    
    //CoreData
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [UserHealth] = []
    var profileTasks: [UserProfile] = []
    
    //var foodTasks : [Foods] = []
    var foodTasks : [NSManagedObject] = []
    
    
    //HealthKit
    var healthStore: HKHealthStore?
    private var activeEnergyBurned: Double = 0.0 {
        didSet {
            didSetActiveEnergyBurned(oldValue)
        }
    }
    private var energyConsumed: Double = 0.0 {
        didSet {
            didSetEnergyConsumed(oldValue)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        //Check if Health App has been enabled in settings
        let defaults = UserDefaults.standard
        let healthApp = defaults.bool(forKey: "HealthApp")
        if healthApp {
            self.healthStore = HKHealthStore()
        }
        
        
        
        do {
            tasks = try context.fetch(UserHealth.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        
        let task = tasks[0]
        
        if let weight = task.currentWeight {
            weightString = weight
        }
        if let height = task.height{
            heightString = height
        }
        if let desired = task.desiredLoss{
            desiredLoss = desired
        }
        if let activity = task.activityLevel{
            activityLevel = activity
        }
        do {
            profileTasks = try context.fetch(UserProfile.fetchRequest())
        } catch {
            print("Fetching Failed")
        }
        
        let profileTask = profileTasks[0]
        
        if let age = profileTask.age{
            ageString = age
        }
        if let gender = profileTask.gender{
            genderString = gender
        }
        
        
        //Initialize Labels at top
        foodCaloriesOutlet.text = "0"
        exerciseCaloriesOutlet.text = "0"
        
        
        
        //Initialize Fonts at top
        foodCaloriesOutlet.textColor = UIColor.red
        //exerciseCaloriesOutlet.textColor = UIColor.green
        
        
        let desiredText = defaults.string(forKey: "DesiredWeight")
        let activityText = defaults.string(forKey: "ActivityLevel")
        let ageText = defaults.string(forKey: "Age")
        let genderText = defaults.string(forKey: "Gender")
        let heightText = defaults.string(forKey: "Height")
        let weightText = defaults.string(forKey: "CurrentWeight")
        
        
        breakfastCalorieOutlet.text = "0 calories"
        lunchCalorieOutlet.text = "0 calories"
        dinnerCalorieOutlet.text = "0 calories"
        snackCalorieOutlet.text = "0 calories"
        coreDataSetup()
        
        
        desiredLoss = desiredText
        activityLevel = activityText
        ageString = ageText
        genderString = genderText
        heightString = heightText
        weightString = weightText
        
        //calculateBMR()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let defaults = UserDefaults.standard
        let healthApp = defaults.bool(forKey: "HealthApp")
        
        if healthApp {
            self.healthStore = HKHealthStore()
        }
        
        DispatchQueue.main.async {
            if healthApp {
                self.refreshControl?.addTarget(self, action: #selector(DayOverviewVC.refreshStatistics), for: .valueChanged)
                
                self.refreshStatistics()
                
                NotificationCenter.default.addObserver(self, selector: #selector(DayOverviewVC.refreshStatistics), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
            }
        }
        
        
        coreDataSetup()
        //updateData()
        
        let desiredText = defaults.string(forKey: "DesiredWeight")
        let activityText = defaults.string(forKey: "ActivityLevel")
        let ageText = defaults.string(forKey: "Age")
        let genderText = defaults.string(forKey: "Gender")
        let heightText = defaults.string(forKey: "Height")
        let weightText = defaults.string(forKey: "CurrentWeight")

        desiredLoss = desiredText
        activityLevel = activityText
        ageString = ageText
        genderString = genderText
        heightString = heightText
        weightString = weightText

        calculateBMR()
        self.tableView.reloadData()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func coreDataSetup(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Foods")
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        breakfastEmoji.removeAll()
        breakfastName.removeAll()
        breakfastServings.removeAll()
        breakfastServingSize.removeAll()
        breakfastCalories.removeAll()
        breakfastNDBNO.removeAll()
        
        lunchEmoji.removeAll()
        lunchName.removeAll()
        lunchServings.removeAll()
        lunchServingSize.removeAll()
        lunchCalories.removeAll()
        lunchNDBNO.removeAll()
        
        dinnerEmoji.removeAll()
        dinnerName.removeAll()
        dinnerServings.removeAll()
        dinnerServingSize.removeAll()
        dinnerCalories.removeAll()
        dinnerNDBNO.removeAll()
        
        snackEmoji.removeAll()
        snackName.removeAll()
        snackServings.removeAll()
        snackServingSize.removeAll()
        snackCalories.removeAll()
        snackNDBNO.removeAll()
        
        
        do{
            

            
            foodTasks = try context.fetch(fetchRequest)
            print(foodTasks.count)
            print(foodTasks)
            
            for i in 0 ..< foodTasks.count {
                
                let foodTask = foodTasks[i]
                
                var calendar = Calendar.current
                calendar.timeZone = TimeZone.autoupdatingCurrent
                let today = calendar.startOfDay(for: Date())
                
                let formatter: DateFormatter = DateFormatter()
                
                // Set date format
                formatter.dateFormat = "MM/dd/yyyy"
                formatter.timeZone = TimeZone.autoupdatingCurrent
                
                // Apply date format
                let todayString = formatter.string(from: today)
                
                
                let foodDate: Date = foodTask.value(forKey: "date") as! Date

                let updatedFoodDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: foodDate)!

                let foodDateString = formatter.string(from: updatedFoodDate)
                
                if todayString == foodDateString{
                    
                    let foodMeal: String = foodTask.value(forKey: "meal") as! String
                    
                    if foodMeal == "Breakfast"{
                        
                        breakfastEmoji.append(foodTask.value(forKey: "emoji") as! String)
                        breakfastName.append(foodTask.value(forKey: "name") as! String)
                        breakfastServings.append(foodTask.value(forKey: "servings") as! String)
                        //breakfastServingSize.append(foodTask.value(forKey: "servingSize") as! String)
                        breakfastCalories.append(foodTask.value(forKey: "calories") as! String)
                        breakfastNDBNO.append(foodTask.value(forKey: "ndbno") as! String)
                        
                    }
                    else if foodMeal == "Lunch" {
                        
                        lunchEmoji.append(foodTask.value(forKey: "emoji") as! String)
                        lunchName.append(foodTask.value(forKey: "name") as! String)
                        lunchServings.append(foodTask.value(forKey: "servings") as! String)
                        //lunchServingSize.append(foodTask.value(forKey: "servingSize") as! String)
                        lunchCalories.append(foodTask.value(forKey: "calories") as! String)
                        lunchNDBNO.append(foodTask.value(forKey: "ndbno") as! String)
                        
                        
                    }
                    else if foodMeal == "Dinner" {
                        
                        dinnerEmoji.append(foodTask.value(forKey: "emoji") as! String)
                        dinnerName.append(foodTask.value(forKey: "name") as! String)
                        dinnerServings.append(foodTask.value(forKey: "servings") as! String)
                        //print (foodTask.value(forKey: "servingSize") as! String)
                        //dinnerServingSize.append(foodTask.value(forKey: "servingSize") as! String)
                        dinnerCalories.append(foodTask.value(forKey: "calories") as! String)
                        dinnerNDBNO.append(foodTask.value(forKey: "ndbno") as! String)
                        
                    }
                    else if foodMeal == "Snack" {
                        
                        snackEmoji.append(foodTask.value(forKey: "emoji") as! String)
                        snackName.append(foodTask.value(forKey: "name") as! String)
                        snackServings.append(foodTask.value(forKey: "servings") as! String)
                        //snackServingSize.append(foodTask.value(forKey: "servingSize") as! String)
                        snackCalories.append(foodTask.value(forKey: "calories") as! String)
                        snackNDBNO.append(foodTask.value(forKey: "ndbno") as! String)
                    }
                    
                }
                
            }
            
            
            print(lunchCalories)
            print(dinnerCalories)
            updateData()
            
            
        }
        catch{
            print("Fetching Failed")
        }
        
        
        
        
        
        
    }
    
    func updateData(){
        
        breakfastCalorieTotal = 0
        lunchCalorieTotal = 0
        dinnerCalorieTotal = 0
        snackCalorieTotal = 0
        exerciseCalorieTotal = 0
        
        breakfastCalorieOutlet.text = "0 calories"
        lunchCalorieOutlet.text = "0 calories"
        dinnerCalorieOutlet.text = "0 calories"
        snackCalorieOutlet.text = "0 calories"
        
        print(lunchCalories)
        print(dinnerCalories)
        
        
        for i in 0 ..< breakfastCalories.count{
            
            let calculatedDouble: Double = Double(breakfastCalories[i])!
            let calculatedInt: Int! = Int(calculatedDouble)
            
            breakfastCalorieTotal = breakfastCalorieTotal + calculatedInt as Int!
            
            let stringCalories: String! = String(breakfastCalorieTotal)

            
            let endString: String! = "\(stringCalories!) calories"

            breakfastCalorieOutlet.text = endString
        
        }
        
        for i in 0 ..< lunchCalories.count{
            
            let calculatedDouble: Double = Double(lunchCalories[i])!
            let calculatedInt: Int! = Int(calculatedDouble)

            lunchCalorieTotal = lunchCalorieTotal + calculatedInt as Int!
            
            let stringCalories: String! = String(lunchCalorieTotal)

            let endString: String! = "\(stringCalories!) calories"

            lunchCalorieOutlet.text = endString
            
        }
        
        for i in 0 ..< dinnerCalories.count{
        
            let calculatedDouble: Double = Double(dinnerCalories[i])!
            let calculatedInt: Int! = Int(calculatedDouble)
            
            dinnerCalorieTotal = dinnerCalorieTotal + calculatedInt as Int!
            
            let stringCalories: String! = String(dinnerCalorieTotal)
            
            let endString: String! = "\(stringCalories!) calories"
            
            dinnerCalorieOutlet.text = endString
        
        }
        
        for i in 0 ..< snackCalories.count{
            
            let calculatedDouble: Double = Double(snackCalories[i])!
            let calculatedInt: Int! = Int(calculatedDouble)
            
            snackCalorieTotal = snackCalorieTotal + calculatedInt as Int!
            
            let stringCalories: String! = String(snackCalorieTotal)
            
            let endString: String! = "\(stringCalories!) calories"
            
            snackCalorieOutlet.text = endString
        
        }
        
        
        
        foodCalorieTotal = (breakfastCalorieTotal + lunchCalorieTotal) + (dinnerCalorieTotal + snackCalorieTotal) as Int
        
        let foodCaloriesString: String! = String(foodCalorieTotal)
        
        print(foodCaloriesString)
        print("Test")
        print(foodCaloriesString)
        
        foodCaloriesOutlet.text = foodCaloriesString
        
        
    }
    
    func calculateBMR() {
        //Formulas
        //Male: 88.4 + (13.4 * weight) + (4.8 * height) - (5.68 * age)
        //Female: 447.6 + (9.25 * weight) + (3.10 * height) - (4.33 * age)
        //1 Pound = 0.453592 kg
        //1 inch = 2.54 centimeters
        
        print("entered calculateBMR")
        print(desiredLoss)
        print(activityLevel)
        print(ageString)
        print(genderString)
        print(heightString)
        print(weightString)
        
        let weightArray = weightString?.components(separatedBy: (" "))
        
        weightString = weightArray?[0]
        
        
        weightInKg = (Double(weightString)! * 0.453592)
        let heightArrayOne = heightString.components(separatedBy: "'")
        let heightArrayTwo = heightArrayOne[1].components(separatedBy: "\"")
        
        print(heightArrayOne)
        print(heightArrayTwo)
        print(heightArrayOne[0])
        print(heightArrayTwo[0])
        
        if let feetDouble = Double(heightArrayOne[0]){
            if let inchesDouble = Double(heightArrayTwo[0]){
                let heightInInches = (feetDouble * 12) + inchesDouble
                print(heightInInches)
                heightinCm = heightInInches * 2.54
                
                ageYears = Double(ageString)
                
                if activityLevel == activityLevelArray[0]{
                    activityDouble = 1.2
                }
                else if activityLevel == activityLevelArray[1]{
                    activityDouble = 1.375
                }
                else if activityLevel == activityLevelArray[2]{
                    activityDouble = 1.55
                }
                else if activityLevel == activityLevelArray[3]{
                    activityDouble = 1.725
                }
                
                
                if genderString == "Male"{
                    let bmrCalc1 = (13.7 * weightInKg)
                    let bmrCalc2 = (5 * heightinCm)
                    let bmrCalc3 = (6.8 * ageYears)
                    bmrDouble = 66 + bmrCalc1 + bmrCalc2 - bmrCalc3
                    
                    
                    if desiredLoss == desiredLossArray[0]{
                        //Maintain
                        bmrDouble = bmrDouble * activityDouble
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    else if desiredLoss == desiredLossArray[1]{
                        //Lose 0.5 / week
                        //Subtract 250
                        bmrDouble = bmrDouble * activityDouble
                        bmrDouble = bmrDouble - 250
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    else if desiredLoss == desiredLossArray[2]{
                        //Lose 1 / week
                        //Subtract 500
                        bmrDouble = bmrDouble * activityDouble
                        bmrDouble = bmrDouble - 500
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    else if desiredLoss == desiredLossArray[3]{
                        //Lose 1.5 / week
                        //Subtract 750
                        bmrDouble = bmrDouble * activityDouble
                        bmrDouble = bmrDouble - 750
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    else if desiredLoss == desiredLossArray[4]{
                        //Lose 2 / week
                        //Subtract 1000
                        bmrDouble = bmrDouble * activityDouble
                        bmrDouble = bmrDouble - 1000
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    
                    
                }
                else{
                    let bmrCalc1 = (9.6 * weightInKg)
                    let bmrCalc2 = (1.8 * heightinCm)
                    let bmrCalc3 = (4.7 * ageYears)
                    bmrDouble = 655 + bmrCalc1 + bmrCalc2 - bmrCalc3
                    if desiredLoss == desiredLossArray[0]{
                        //Maintain
                        bmrDouble = bmrDouble * activityDouble
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    else if desiredLoss == desiredLossArray[1]{
                        //Lose 0.5 / week
                        //Subtract 250
                        bmrDouble = bmrDouble * activityDouble
                        bmrDouble = bmrDouble - 250
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    else if desiredLoss == desiredLossArray[2]{
                        //Lose 1 / week
                        //Subtract 500
                        bmrDouble = bmrDouble * activityDouble
                        bmrDouble = bmrDouble - 500
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    else if desiredLoss == desiredLossArray[3]{
                        //Lose 1.5 / week
                        //Subtract 750
                        bmrDouble = bmrDouble * activityDouble
                        bmrDouble = bmrDouble - 750
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                    else if desiredLoss == desiredLossArray[4]{
                        //Lose 2 / week
                        //Subtract 1000
                        bmrDouble = bmrDouble * activityDouble
                        bmrDouble = bmrDouble - 1000
                        let bmRInt = Int(bmrDouble)
                        bmrString = String(bmRInt)
                        print(bmrString)
                        bmrOutlet.text = bmrString!
                        let defaults = UserDefaults.standard
                        defaults.set(bmrString!, forKey: "goalCalories")
                        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                        sharedDefaults.set(bmrString!, forKey: "goalCalories")
                        print("bmrString \(bmrString!)")
                    }
                }
            }
        }
        
        refreshRemaining()
        
        
    }
    
    func refreshRemaining() {
        
        if let bmr = Double(bmrOutlet.text!){
            if let food = Double(foodCaloriesOutlet.text!){
                if let exercise = Double (exerciseCaloriesOutlet.text!){
                    
                    let remainingCalories = (bmr - food) + exercise
                    let remainingInt = Int(remainingCalories)
                    remainingCaloriesOutlet.text = String(remainingInt)
                    print(remainingInt)
                    let defaults = UserDefaults.standard
                    defaults.set(String(remainingInt), forKey: "remainingCalories")
                    defaults.set(foodCaloriesOutlet.text!, forKey: "foodCalories")
                    defaults.set(exerciseCaloriesOutlet.text!, forKey: "exerciseCalories")
                    
                    let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
                    sharedDefaults.set(foodCaloriesOutlet.text!, forKey: "foodCalories")
                    sharedDefaults.set(exerciseCaloriesOutlet.text!, forKey: "exerciseCalories")
                    sharedDefaults.set(String(remainingInt), forKey: "remainingCalories")
                    
                    print("remainingCalories \(String(remainingInt))")
                    print("foodCalories \(foodCaloriesOutlet.text!)")
                    print("exerciseCalories \(exerciseCaloriesOutlet.text!)")
                    
                    //Get Watch App Data from iOS UserDefaults
                    
                    let goalText = defaults.string(forKey: "goalCalories")
                    let foodText = defaults.string(forKey: "foodCalories")
                    let exerciseText = defaults.string(forKey: "exerciseCalories")
                    let remainingText = defaults.string(forKey: "remainingCalories")
                    
                    
                    //Watch App Code
                    var session: WCSession?
                    if WCSession.isSupported() {
                        session = WCSession.default
                        session?.delegate = self
                        session?.activate()
                    }
                    
                    let message = ["goalMessage":goalText, "foodMessage":foodText, "exerciseMessage":exerciseText, "remainingMessage":remainingText]
                    print(message)
                    
                    session?.sendMessage(message, replyHandler: nil, errorHandler: nil)
                }
            }
        }
        
        if let remainingDouble = Double(remainingCaloriesOutlet.text!){
            if remainingDouble > 0{
                remainingCaloriesOutlet.textColor = UIColor.green
            }
            else if remainingDouble < 0{
                remainingCaloriesOutlet.textColor = UIColor.red
            }
            else{
                remainingCaloriesOutlet.textColor = UIColor.black
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 3
        }
        else if section == 2 {
            return 3
        }
        else if section == 3 {
            return 3
        }
        else if section == 4 {
            return 3
        }
        else{
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1  && indexPath.row == 1 {
            mealToPass = "Breakfast"
            self.performSegue(withIdentifier: "toViewFoods", sender: self)
        }
        if indexPath.section == 1  && indexPath.row == 2 {
            self.performSegue(withIdentifier: "toAddFood", sender: self)
        }
        if indexPath.section == 2  && indexPath.row == 1 {
            mealToPass = "Lunch"
            self.performSegue(withIdentifier: "toViewFoods", sender: self)
        }
        if indexPath.section == 2  && indexPath.row == 2 {
            self.performSegue(withIdentifier: "toAddFood", sender: self)
        }
        if indexPath.section == 3  && indexPath.row == 1 {
            mealToPass = "Dinner"
            self.performSegue(withIdentifier: "toViewFoods", sender: self)
        }
        if indexPath.section == 3  && indexPath.row == 2 {
            self.performSegue(withIdentifier: "toAddFood", sender: self)
        }
        if indexPath.section == 4  && indexPath.row == 1 {
            mealToPass = "Snack"
            self.performSegue(withIdentifier: "toViewFoods", sender: self)
        }
        if indexPath.section == 4  && indexPath.row == 2 {
           self.performSegue(withIdentifier: "toAddFood", sender: self)
        }
        if indexPath.section == 5  && indexPath.row == 1 {
            self.performSegue(withIdentifier: "toAddFood", sender: self)
        }
        
        
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Fill in
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //Fill in
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //Fill in
    }
    
    //HealthKit related
    
    
    //MARK: - Reading HealthKit Data
    
    @objc private func refreshStatistics() {
        self.refreshControl?.beginRefreshing()
        
        let activeEnergyBurnType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
        let energyConsumedType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
        
            
        // First, fetch the sum of energy consumed samples from HealthKit. Populate this by creating your
        // own food logging app or using the food journal view controller.
        self.fetchSumOfSamplesTodayForType(energyConsumedType!, unit: HKUnit.joule()) {totalJoulesConsumed, error in
            
            // Next, fetch the sum of active energy burned from HealthKit. Populate this by creating your
            // own calorie tracking app or the Health app.
            self.fetchSumOfSamplesTodayForType(activeEnergyBurnType!, unit: HKUnit.joule()) {activeEnergyBurned, error in
                    
                    // Update the UI with all of the fetched values.
                    DispatchQueue.main.async {
                        self.activeEnergyBurned = activeEnergyBurned
                        self.energyConsumed = totalJoulesConsumed
                        self.refreshControl?.endRefreshing()
                    }
            }
        }
    }
    
    private func fetchSumOfSamplesTodayForType(_ quantityType: HKQuantityType, unit: HKUnit, completion completionHandler: ((Double, Error?)->Void)?) {
        
        
        let predicate = predicateForSamplesToday()
        
        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) {query, result, error in
            let sum = result?.sumQuantity()
            
            if completionHandler != nil {
                let value: Double = sum?.doubleValue(for: unit) ?? 0.0
                
                completionHandler!(value, error)
            }
        }
        self.healthStore?.execute(query)
    }
    
    //MARK: - Convenience
    
    private func predicateForSamplesToday() -> NSPredicate {
        let calendar = Calendar.current
        
        let now = Date()
        
        let startDate = calendar.startOfDay(for: now)
        let endDate = (calendar as NSCalendar).date(byAdding: .day, value: 1, to: startDate, options: [])
        
        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
    }
    
    //MARK: - NSEnergyFormatter
    
    private lazy var energyFormatter: EnergyFormatter = {
        let formatter = EnergyFormatter()
        formatter.unitStyle = .long
        formatter.isForFoodEnergyUse = true
        formatter.numberFormatter.maximumFractionDigits = 0
        return formatter
    }()
    
    //MARK: - Setter Overrides
    
    private func didSetActiveEnergyBurned(_ oldValue: Double) {
        
        let exerciseArray = energyFormatter.string(fromJoules: activeEnergyBurned).components(separatedBy: " ")
        self.exerciseCaloriesOutlet?.text = exerciseArray[0]
        //print(energyFormatter.string(fromJoules: activeEnergyBurned))
        
        refreshRemaining()
        //refreshStatistics()
    }
    private func didSetEnergyConsumed(_ oldValue: Double) {
        
        let foodArray = energyFormatter.string(fromJoules:  energyConsumed).components(separatedBy: " ")
        //self.foodCaloriesOutlet?.text = foodArray[0]
        //print(energyFormatter.string(fromJoules: energyConsumed))
        
        refreshRemaining()
        //refreshStatistics()
    }
    
    var mealToPass: String!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toViewFoods") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! ViewFoodsVC
            // your new view controller should have property that will store passed value
            viewController.meal = mealToPass
        }
    }
    
}


