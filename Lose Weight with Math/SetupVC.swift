//
//  SetupVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/24/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//


import Foundation
import UIKit
import CoreData
import HealthKit
import LocalAuthentication
import UserNotifications

class SetupVC: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, HavingHealthStore {
    
    var healthStore: HKHealthStore?
    
    var window: UIWindow?
    
    
    
    //var healthStore: HKHealthStore = HKHealthStore()
    
    
    
    var heightArrayFeet = ["1'", "2'", "3'", "4'", "5'", "6'", "7'", "8'"]
    var heightArrayInches = ["1\"", "2\"", "3\"", "4\"", "5\"", "6\"", "7\"", "8\"", "9\"", "10\"", "11\""]
    
    var activityLevelArray = ["Sedentary", "Light Activity", "Moderate Activity", "Very Active"]
    
    var desiredLossArray = ["Maintain Weight", "0.5 pounds / week", "1.0 pound / week", "1.5 pounds / week", "2.0 pounds / week"]
    
    var genderArray = ["Male", "Female"]
    
    var currentDate: String!
    
    
    
    //Outlets Profile Information
    @IBOutlet weak var firstOutlet: UITextField!
    @IBOutlet weak var lastOutlet: UITextField!
    @IBOutlet weak var ageOutlet: UITextField!
    @IBOutlet weak var dateOutlet: UILabel!
    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    @IBOutlet weak var genderOutlet: UILabel!
    @IBOutlet weak var genderPickerOutlet: UIPickerView!
    
    //Outlets Health Information
    @IBOutlet weak var heightOutlet: UILabel!
    @IBOutlet weak var heightPickerOutlet: UIPickerView!
    @IBOutlet weak var startWeightOutlet: UITextField!
    @IBOutlet weak var currentWeightOutlet: UITextField!
    @IBOutlet weak var goalWeightOutlet: UITextField!
    @IBOutlet weak var activityLevelOutlet: UILabel!
    @IBOutlet weak var activityLevelPickerOutlet: UIPickerView!
    @IBOutlet weak var desiredWeightOutlet: UILabel!
    
    @IBOutlet weak var desiredWeightPickerOutlet: UIPickerView!
    //Outlets App Settings
    @IBOutlet weak var touchIDOutlet: UISwitch!
    @IBOutlet weak var icloudBackupOutlet: UISwitch!
    @IBOutlet weak var healthAppOutlet: UISwitch!
    @IBOutlet weak var getNotificationOutlet: UISwitch!
    
    //Actions Profile Information
    @IBAction func dateSelected(_ sender: Any) {
    }
    @IBAction func datePickerChanged(_ sender: Any) {
        var selectedDate: String = ""
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        // Apply date format
        selectedDate = dateFormatter.string(from: (sender as AnyObject).date)
        
        print("Selected value \(selectedDate)")
        dateOutlet.text = selectedDate
    }
    //Actions Health Information
    @IBAction func heightSelected(_ sender: Any) {
    }
    @IBAction func activityLevelSelected(_ sender: Any) {
    }
    @IBAction func desiredWeightLossSelected(_ sender: Any) {
    }
    //Actions App Settings
    @IBAction func touchIDChanged(_ sender: Any) {
        if touchIDOutlet.isOn{
            print("Touch ID has been enabled")
        
            let context:LAContext = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please scan your finger to turn on TouchID Login.", reply: { (wasSuccessful, error) in
                    if wasSuccessful{
                        
                        OperationQueue.main.addOperation({ () -> Void in
                            print("TouchID authenticated.")
                            
                            //Set defaults to TouchID enabled
                            let defaults = UserDefaults.standard
                            
                            defaults.set(true, forKey: "TouchID")

                        })
                        
                        
                        
                    }
                    else{
                        print("TouchID not authenticated.")
                    }
                })
            }
            
        }
        else{
            print("Touch ID has been disabled")
            let defaults = UserDefaults.standard
            
            defaults.set(false, forKey: "TouchID")
            
        }
    }
    @IBAction func icloudBackupChanged(_ sender: Any) {
        if icloudBackupOutlet.isOn{
            print("iCloud Backup has been enabled")
            let defaults = UserDefaults.standard
            
            defaults.set(true, forKey: "iCloudBackup")
        }
        else{
            print("iCloud Backup has been disabled")
            let defaults = UserDefaults.standard
            
            defaults.set(false, forKey: "iCloudBackup")
        }
    }
    @IBAction func healthAppChanged(_ sender: Any) {
        
        if healthAppOutlet.isOn{
            print("Health App Integration has been enabled")
            
            let defaults = UserDefaults.standard
            
            defaults.set(true, forKey: "HealthApp")
            
            
            // Set up an HKHealthStore, asking the user for read/write permissions. The profile view controller is the
            // first view controller that's shown to the user, so we'll ask for all of the desired HealthKit permissions now.
            // In your own app, you should consider requesting permissions the first time a user wants to interact with
            // HealthKit data.
            if HKHealthStore.isHealthDataAvailable() {
                let writeDataTypes = self.dataTypesToWrite()
                let readDataTypes = self.dataTypesToRead()
                healthStore?.requestAuthorization(toShare: writeDataTypes, read: readDataTypes) {success, error in
                    if !success {
                        NSLog("You didn't allow HealthKit to access these read/write data types. In your app, try to handle this error gracefully when a user decides not to provide access. The error was: \(error!). If you're using a simulator, try it on a device.")
                        
                        return
                    }
                    
                }
            }
            
            
        }
        else{
            print("Health App Integration has been disabled")
            let defaults = UserDefaults.standard
            
            defaults.set(false, forKey: "HealthApp")
        }
    }
    @IBAction func getNotificationChanged(_ sender: Any) {
        if getNotificationOutlet.isOn{
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
            { (success, error) in
                if success {
                    print("Get Notifications has been enabled")
                    let defaults = UserDefaults.standard
                    
                    defaults.set(true, forKey: "GetNotifications")
                } else {
                    print("There was a problem!")
                }
            }
        }
        else{
            print("Get Notifications has been disabled")
            let defaults = UserDefaults.standard
            
            defaults.set(false, forKey: "GetNotifications")
        }
    }
    
    //Actions Footer
    @IBAction func setupDone(_ sender: Any) {
        
        if firstOutlet.text == ""{
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid First Name", message: "Please enter a valid First Name.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if lastOutlet.text == ""{
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Last Name", message: "Please enter a valid Last Name.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if ageOutlet.text == ""{
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Age", message: "Please enter a valid Age.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if dateOutlet.text == "" {
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Date of Birth", message: "Please enter a valid Date of Birth.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if genderOutlet.text == "" {
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Gender entry", message: "Please enter a valid gender.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if heightOutlet.text == "" {
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Height entry", message: "Please enter a valid height.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if startWeightOutlet.text == "" {
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Starting Weight entry", message: "Please enter a valid Starting Weight.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if currentWeightOutlet.text == "" {
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Current Weight entry", message: "Please enter a valid Current Weight.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if goalWeightOutlet.text == "" {
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Goal Weight entry", message: "Please enter a valid Goal Weight.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if activityLevelOutlet.text == "" {
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Activity Level entry", message: "Please enter a valid Activity Level.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if desiredWeightOutlet.text == "" {
            //Alert if user has letters in weight value
            let alert = UIAlertController(title: "Invalid Desired Weight Loss entry", message: "Please enter a valid Desired Weight Loss.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            self.saveProfile(firstName: firstOutlet.text!, lastName: lastOutlet.text!, age: ageOutlet.text!, date: dateOutlet.text!, gender: genderOutlet.text!)
            print("Personal Information Saved.")
            self.saveHealth(height: heightOutlet.text!, startWeight: startWeightOutlet.text!, currentWeight: currentWeightOutlet.text!, goalWeight: goalWeightOutlet.text!, activityLevel: activityLevelOutlet.text!, desiredWeight: desiredWeightOutlet.text!)
            print("Health Information Saved.")
            self.saveAppSettings(touchID: touchIDOutlet.isOn, healthApp: healthAppOutlet.isOn, getNotifications: getNotificationOutlet.isOn)
            print("App Settings Saved.")
            self.saveInitialWeight(currentWeight: currentWeightOutlet.text!)
            print("Initial Settings Saved.")
            
            
            
            self.performSegue(withIdentifier: "setupComplete", sender: self)
            
            
            
            
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
        view.endEditing(true)
        
        
        
    }
    
    
    var logs: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //HealthKit
        self.healthStore = HKHealthStore()
        // Do any additional setup after loading the view, typically from a nib.
        heightPickerOutlet.delegate = self
        activityLevelPickerOutlet.delegate = self
        desiredWeightPickerOutlet.delegate = self
        
        let defaults = UserDefaults.standard
        defaults.set("xxxx", forKey: "goalCalories")
        defaults.set("xxxx", forKey: "foodCalories")
        defaults.set("xxxx", forKey: "exerciseCalories")
        defaults.set("xxxx", forKey: "remainingCalories")
        
        UIApplication.shared.statusBarStyle = .default
        
        datePickerChanged()
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
        dateOutlet.text = result
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
    func toggleActivitypicker() {
        
        activityPickerHidden = !activityPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleDesiredpicker() {
        
        desiredPickerHidden = !desiredPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 3 {
            toggleDatepicker()
        }
        else if indexPath.section == 0 && indexPath.row == 5 {
            toggleGenderpicker()
        }
        else if indexPath.section == 1 && indexPath.row == 0 {
            toggleHeightpicker()
        }
        else if indexPath.section == 1 && indexPath.row == 5 {
            toggleActivitypicker()
        }
        else if indexPath.section == 1 && indexPath.row == 7 {
            toggleDesiredpicker()
        }
    }
    var datePickerHidden = true
    var heightPickerHidden = true
    var activityPickerHidden = true
    var desiredPickerHidden = true
    var genderPickerHidden = true

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 4 {
            return 0
        }
        else if genderPickerHidden && indexPath.section == 0 && indexPath.row == 6 {
            return 0
        }
        else if heightPickerHidden && indexPath.section == 1 && indexPath.row == 1 {
            return 0
        }
        else if activityPickerHidden && indexPath.section == 1 && indexPath.row == 6 {
            return 0
        }
        else if desiredPickerHidden && indexPath.section == 1 && indexPath.row == 8 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    
    
    
    //---------------------------------------------------------
    //CoreData
    func saveProfile(firstName: String, lastName: String, age: String, date: String, gender: String) {
        
        currentDate = date
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        // 1
        let managedContext = appDelegate.persistentContainer.viewContext

        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserProfile", in: managedContext)!

        let log = NSManagedObject(entity: entity, insertInto: managedContext)

        
        print("\(firstName)\(lastName)\(age)\(date)")
        // 3
        log.setValue(firstName, forKeyPath: "firstName")
        log.setValue(lastName, forKeyPath: "lastName")
        log.setValue(age, forKeyPath: "age")
        log.setValue(date, forKeyPath: "dateOfBirth")
        log.setValue(gender, forKeyPath: "gender")
        
        
        //Trying UserDefaults
        let defaults = UserDefaults.standard
        
        defaults.set(firstName, forKey: "FirstName")
        defaults.set(lastName, forKey: "LastName")
        defaults.set(age, forKey: "Age")
        defaults.set(date, forKey: "DateOfBirth")
        defaults.set(gender, forKey: "Gender")

        // 4
        do {
            try managedContext.save()
            print("Context was saved")
            
            //I believe the below code is for table view specifically
            //logs.append(log)
            //logs.insert(log, at: 0)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveHealth(height: String, startWeight: String, currentWeight: String, goalWeight: String, activityLevel: String, desiredWeight: String) {
        
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
        
        // 3
        log.setValue(height, forKeyPath: "height")
        log.setValue(startWeight, forKeyPath: "startWeight")
        log.setValue(currentWeight, forKeyPath: "currentWeight")
        log.setValue(goalWeight, forKeyPath: "goalWeight")
        log.setValue(activityLevel, forKeyPath: "activityLevel")
        log.setValue(desiredWeight, forKeyPath: "desiredLoss")
        
        //Trying UserDefaults
        let defaults = UserDefaults.standard
        
        defaults.set(height, forKey: "Height")
        defaults.set(startWeight, forKey: "StartWeight")
        defaults.set(currentWeight, forKey: "CurrentWeight")
        defaults.set(currentDate, forKey: "CurrentWeightDate")
        defaults.set(goalWeight, forKey: "GoalWeight")
        defaults.set(activityLevel, forKey: "ActivityLevel")
        defaults.set(desiredWeight, forKey: "DesiredWeight")
        
        // 4
        do {
            try managedContext.save()
            print("Context was saved")
            
            //I believe the below code is for table view specifically
            //logs.append(log)
            //logs.insert(log, at: 0)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveAppSettings(touchID: Bool, healthApp: Bool, getNotifications: Bool) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "UserAppSettings", in: managedContext)!
        
        let log = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        log.setValue(touchID, forKeyPath: "touchID")
        //log.setValue(icloudBackup, forKeyPath: "icloudBackup")
        log.setValue(healthApp, forKeyPath: "healthApp")
        log.setValue(getNotifications, forKeyPath: "getNotification")
        
        let defaults = UserDefaults.standard
        
        defaults.set(touchID, forKey: "TouchID")
        //defaults.set(icloudBackup, forKey: "iCloudBackup")
        defaults.set(healthApp, forKey: "HealthApp")
        defaults.set(getNotifications, forKey: "GetNotifications")
        
        // 4
        do {
            try managedContext.save()
            print("Context was saved")
            
            //I believe the below code is for table view specifically
            //logs.append(log)
            //logs.insert(log, at: 0)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func saveInitialWeight(currentWeight: String) {
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        let result = formatter.string(from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.date(from: result)
        print(result)
        //print(dateString)
        
        
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
        log.setValue(currentWeight, forKeyPath: "weight")
        log.setValue(dateString, forKeyPath: "date")
        
        // 4
        do {
            try managedContext.save()
            print("Context was saved")
            
            //I believe the below code is for table view specifically
            //logs.append(log)
            //logs.insert(log, at: 0)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    //PICKER VIEW FUNCTIONS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == heightPickerOutlet{
            return 2
        }
        else{
            return 1
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if pickerView == heightPickerOutlet {
            if component == 0{
                return heightArrayFeet.count
            }
            else{
                return heightArrayInches.count
            }
        }
        else if pickerView == genderPickerOutlet{
            return 2
        }
        else if pickerView == activityLevelPickerOutlet{
            return 4
        }
        else if pickerView == desiredWeightPickerOutlet {
            return 5
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == heightPickerOutlet {
            if component == 0 {
                return heightArrayFeet[row]
            }
            else{
                return heightArrayInches[row]
            }
        }
        else if pickerView == genderPickerOutlet{
            return genderArray[row]
        }
        else if pickerView == activityLevelPickerOutlet {
            return activityLevelArray[row]
        }
        else{
            return desiredLossArray[row]
        }

    }
    
    var firstComponentString: String = ""
    var secondComponentString: String = ""
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == heightPickerOutlet {
            
            
            
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
            
            heightOutlet.text = displayString
        }
        else if pickerView == genderPickerOutlet {
            genderOutlet.text = genderArray[row]
        }
        else if pickerView == activityLevelPickerOutlet {
            activityLevelOutlet.text = activityLevelArray[row]
        }
        else if pickerView == desiredWeightPickerOutlet {
            desiredWeightOutlet.text = desiredLossArray[row]
        }
    }
    
    
    //HealthKit Permissions
    //MARK: - HealthKit Permissions
    
    // Returns the types of data that Fit wishes to write to HealthKit.
    private func dataTypesToWrite() -> Set<HKSampleType> {
        let dietaryCalorieEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let activeEnergyBurnType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let heightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        
        return [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType]
    }
    
    // Returns the types of data that Fit wishes to read from HealthKit.
    private func dataTypesToRead() -> Set<HKObjectType> {
        let dietaryCalorieEnergyType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)!
        let activeEnergyBurnType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let heightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!
        let weightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let birthdayType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!
        let biologicalSexType = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!
        
        return [dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType]
    }
    
    
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.default
    }
    
    
    
    
    
}

extension HKHealthStore {
    
    // Fetches the single most recent quantity of the specified type.
    func aapl_mostRecentQuantitySampleOfType(_ quantityType: HKQuantityType, predicate: NSPredicate?, completion: ((HKQuantity?, Error?)->Void)?) {
        let timeSortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        // Since we are interested in retrieving the user's latest sample, we sort the samples in descending order, and set the limit to 1. We are not filtering the data, and so the predicate is set to nil.
        let query = HKSampleQuery(sampleType: quantityType, predicate: nil, limit: 1, sortDescriptors: [timeSortDescriptor]) {query, results, error in
            if results == nil {
                completion?(nil, error)
                
                return
            }
            
            if completion != nil {
                // If quantity isn't in the database, return nil in the completion block.
                let quantitySample = results!.first as? HKQuantitySample
                let quantity = quantitySample?.quantity
                
                completion!(quantity, error)
            }
        }
        
        self.execute(query)
    }
    
}



