//
//  SettingsVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/26/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import HealthKit
import LocalAuthentication
import UserNotifications

class SettingsVC: UITableViewController, UIPickerViewDelegate, HavingHealthStore{
    
    var healthStore: HKHealthStore?
    var isGrantedNotificationAccess:Bool = false
    
    //Outlets
    @IBOutlet weak var notificationsOutlet: UISwitch!
    @IBOutlet weak var touchIDOutlet: UISwitch!
    @IBOutlet weak var healthOutlet: UISwitch!
    @IBOutlet weak var icloudOutlet: UISwitch!
    
    @IBOutlet weak var weightOutlet: UILabel!
    @IBOutlet weak var weightPicker: UIDatePicker!
    @IBOutlet weak var breakfastOutlet: UILabel!
    @IBOutlet weak var breakfastPicker: UIDatePicker!
    @IBOutlet weak var lunchOutlet: UILabel!
    @IBOutlet weak var lunchPicker: UIDatePicker!
    @IBOutlet weak var dinnerOutlet: UILabel!
    @IBOutlet weak var dinnerPicker: UIDatePicker!
    
    @IBOutlet weak var weightLogNotification: UISwitch!
    @IBOutlet weak var breakfastNotification: UISwitch!
    @IBOutlet weak var lunchNotification: UISwitch!
    @IBOutlet weak var dinnerNotification: UISwitch!
    
    
    //Actions
    @IBAction func notificationsAction(_ sender: Any) {
        if notificationsOutlet.isOn{
            
            
            
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
            { (success, error) in
                if success {
                    print("Get Notifications has been enabled")
                    let defaults = UserDefaults.standard
                    
                    defaults.set(true, forKey: "GetNotifications")
                    
                    DispatchQueue.main.async {
                        
                        self.toggleWeightRow()
                        self.toggleBreakfastRow()
                        self.toggleLunchRow()
                        self.toggleDinnerRow()
                    }
                    
                } else {
                    print("There was a problem!")
                }
            }
            
            
        }
        else{
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "GetNotifications")
            print("Get Notifications has been disabled")
            
            weightLogNotification.isOn = false
            breakfastNotification.isOn = false
            lunchNotification.isOn = false
            dinnerNotification.isOn = false
            
            
            
            DispatchQueue.main.async {
            
                self.toggleWeightRow()
                self.toggleBreakfastRow()
                self.toggleLunchRow()
                self.toggleDinnerRow()
            }
        }
    }
    
    
    
    
    

    @IBAction func weightLogNotificationAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if weightLogNotification.isOn{
            defaults.set(true, forKey: "GetWeightLogNotifications")
        }
        else{
            defaults.set(false, forKey: "GetWeightLogNotifications")
        }
    }
    @IBAction func breakfastNotificationAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if breakfastNotification.isOn{
            defaults.set(true, forKey: "GetBreakfastNotifications")
        }
        else{
            defaults.set(false, forKey: "GetBreakfastNotifications")
        }
    }
    @IBAction func lunchNotificationAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if lunchNotification.isOn{
            defaults.set(true, forKey: "GetLunchNotifications")
        }
        else{
            defaults.set(false, forKey: "GetLunchNotifications")
        }
    }
    @IBAction func dinnerNotificationAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        
        if dinnerNotification.isOn{
            defaults.set(true, forKey: "GetDinnerNotifications")
        }
        else{
            defaults.set(false, forKey: "GetDinnerNotifications")
        }
    }
    
    
    
    @IBAction func touchIDAction(_ sender: Any) {
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
            let context:LAContext = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please scan your finger to turn off TouchID Login.", reply: { (wasSuccessful, error) in
                    if wasSuccessful{
                        
                        OperationQueue.main.addOperation({ () -> Void in
                            print("TouchID authenticated.")
                            
                            //Set defaults to TouchID enabled
                            let defaults = UserDefaults.standard
                            
                            defaults.set(false, forKey: "TouchID")
                            
                        })
                        
                        
                        
                    }
                    else{
                        print("TouchID not authenticated.")
                    }
                })
            }
            
        }
        
    }
    @IBAction func healthAction(_ sender: Any) {
        if healthOutlet.isOn{
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
    @IBAction func icloudAction(_ sender: Any) {
        if icloudOutlet.isOn{
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "iCloudBackup")
        }
        else{
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "iCloudBackup")
        }
    }
    
    @IBAction func weightPickerChanged(_ sender: Any) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        // Apply date format
        let selectedTime = dateFormatter.string(from: (sender as AnyObject).date)
        
        print("Selected value \(selectedTime)")
        weightOutlet.text = selectedTime
        
        let defaults = UserDefaults.standard
        defaults.set(selectedTime, forKey: "WeightLogTime")
        
        
        if isGrantedNotificationAccess{
            
            let getNotifications = defaults.bool(forKey: "GetNotifications")
            
            if getNotifications == true {
            
            let isEnabled = defaults.bool(forKey: "GetWeightLogNotifications")
            
            if isEnabled == true{
                //add notification code here
                
                //Set the content of the notification
                let content = UNMutableNotificationContent()
                //content.subtitle = "From MakeAppPie.com"
                content.body = "Time to Log your Weight!"
                content.sound = UNNotificationSound.default()
                
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: weightPicker.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                
                //Set the request for the notification from the above
                let request = UNNotificationRequest(identifier: "weightlog.message", content: content, trigger: trigger)
                
                //Add the notification to the currnet notification center
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            }
            }
            
        }
        
        
        
        
        
        
        
        
        
    }
    @IBAction func breakfastPickerChanged(_ sender: Any) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        // Apply date format
        let selectedTime = dateFormatter.string(from: (sender as AnyObject).date)
        
        print("Selected value \(selectedTime)")
        breakfastOutlet.text = selectedTime
        
        let defaults = UserDefaults.standard
        defaults.set(selectedTime, forKey: "BreakfastLogTime")
        
        if isGrantedNotificationAccess{
            
            let getNotifications = defaults.bool(forKey: "GetNotifications")
            
            if getNotifications == true {
            
            let isEnabled = defaults.bool(forKey: "GetBreakfastNotifications")
            
            if isEnabled == true{
                //add notification code here
                
                //Set the content of the notification
                let content = UNMutableNotificationContent()
                //content.subtitle = "From MakeAppPie.com"
                content.body = "Time to Log your Breakfast!"
                content.sound = UNNotificationSound.default()
                
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: breakfastPicker.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                
                //Set the request for the notification from the above
                let request = UNNotificationRequest(identifier: "breakfast.message", content: content, trigger: trigger)
                
                //Add the notification to the currnet notification center
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            }
            }
            
        }
    }
    @IBAction func lunchPickerChanged(_ sender: Any) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        // Apply date format
        let selectedTime = dateFormatter.string(from: (sender as AnyObject).date)
        
        print("Selected value \(selectedTime)")
        lunchOutlet.text = selectedTime
        
        let defaults = UserDefaults.standard
        defaults.set(selectedTime, forKey: "LunchLogTime")
        
        if isGrantedNotificationAccess{
            
            let getNotifications = defaults.bool(forKey: "GetNotifications")
            
            if getNotifications == true {
            
            let isEnabled = defaults.bool(forKey: "GetLunchNotifications")
            
            if isEnabled == true{
                //add notification code here
                
                //Set the content of the notification
                let content = UNMutableNotificationContent()
                //content.subtitle = "From MakeAppPie.com"
                content.body = "Time to Log your Lunch!"
                content.sound = UNNotificationSound.default()
                
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: lunchPicker.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                
                //Set the request for the notification from the above
                let request = UNNotificationRequest(identifier: "lunch.message", content: content, trigger: trigger)
                
                //Add the notification to the currnet notification center
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            }
            }
            
        }
        
        
    }
    @IBAction func dinnerPickerChanged(_ sender: Any) {
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        // Apply date format
        let selectedTime = dateFormatter.string(from: (sender as AnyObject).date)
        
        print("Selected value \(selectedTime)")
        dinnerOutlet.text = selectedTime
        
        let defaults = UserDefaults.standard
        defaults.set(selectedTime, forKey: "DinnerLogTime")
        
        if isGrantedNotificationAccess{
            
            let getNotifications = defaults.bool(forKey: "GetNotifications")
            
            if getNotifications == true {
            
            let isEnabled = defaults.bool(forKey: "GetDinnerNotifications")
            
            if isEnabled == true{
                //add notification code here
                
                //Set the content of the notification
                let content = UNMutableNotificationContent()
                //content.subtitle = "From MakeAppPie.com"
                content.body = "Time to Log your Dinner!"
                content.sound = UNNotificationSound.default()
                
                let triggerDaily = Calendar.current.dateComponents([.hour,.minute], from: dinnerPicker.date)
                let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDaily, repeats: true)
                
                //Set the request for the notification from the above
                let request = UNNotificationRequest(identifier: "dinner.message", content: content, trigger: trigger)
                
                //Add the notification to the currnet notification center
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                
            }
            }
            
        }
    }
    
    
    //Variables
    
    var weightRowHidden = true
    var weightPickerHidden = true
    var breakfastRowHidden = true
    var breakfastPickerHidden = true
    var lunchRowHidden = true
    var lunchPickerHidden = true
    var dinnerRowHidden = true
    var dinnerPickerHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        
        self.healthStore = HKHealthStore()
        // Do any additional setup after loading the view, typically from a nib.
        
        let defaults = UserDefaults.standard
        
        let isEnabled = defaults.bool(forKey: "GetNotifications")
        
        if isEnabled == true {
            weightRowHidden = false
            weightPickerHidden = true
            breakfastRowHidden = false
            breakfastPickerHidden = true
            lunchRowHidden = false
            lunchPickerHidden = true
            dinnerRowHidden = false
            dinnerPickerHidden = true
            
            self.toggleWeightRow()
            self.toggleBreakfastRow()
            self.toggleLunchRow()
            self.toggleDinnerRow()
        }
        
        if let weightTime = defaults.string(forKey: "WeightLogTime"){
            weightOutlet.text = weightTime
        }
        if let breakfastTime = defaults.string(forKey: "BreakfastLogTime"){
            breakfastOutlet.text = breakfastTime
        }
        if let lunchTime = defaults.string(forKey: "LunchLogTime"){
            lunchOutlet.text = lunchTime
        }
        if let dinnerTime = defaults.string(forKey: "DinnerLogTime"){
            dinnerOutlet.text = dinnerTime
        }
        
        
        let weightEnabled = defaults.bool(forKey: "GetWeightLogNotifications")
        if weightEnabled == true {
            weightLogNotification.isOn = true
        }
        else{
            weightLogNotification.isOn = false
        }
        let breakfastEnabled = defaults.bool(forKey: "GetBreakfastNotifications")
        if breakfastEnabled == true {
            breakfastNotification.isOn = true
        }
        else{
            breakfastNotification.isOn = false
        }
        let lunchEnabled = defaults.bool(forKey: "GetLunchNotifications")
        if lunchEnabled == true {
            lunchNotification.isOn = true
        }
        else{
            lunchNotification.isOn = false
        }
        let dinnerEnabled = defaults.bool(forKey: "GetDinnerNotifications")
        if dinnerEnabled == true {
            dinnerNotification.isOn = true
        }
        else{
            dinnerNotification.isOn = false
        }
        
        let touchIDEnabled = defaults.bool(forKey: "TouchID")
        if touchIDEnabled == true {
            touchIDOutlet.isOn = true
        }
        else{
            touchIDOutlet.isOn = false
        }
        
        let healthEnabled = defaults.bool(forKey: "HealthApp")
        if healthEnabled == true {
            healthOutlet.isOn = true
        }
        else{
            healthOutlet.isOn = false
        }
        
        
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert,.sound,.badge],
            completionHandler: { (granted,error) in
                self.isGrantedNotificationAccess = granted
            }
        )
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    func toggleWeightRow() {
        
        weightRowHidden = !weightRowHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleWeightpicker() {
        
        weightPickerHidden = !weightPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleBreakfastRow() {
        
        breakfastRowHidden = !breakfastRowHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleBreakfastpicker() {
        
        breakfastPickerHidden = !breakfastPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleLunchRow() {
        
        lunchRowHidden = !lunchRowHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleLunchpicker() {
        
        lunchPickerHidden = !lunchPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleDinnerRow() {
        
        dinnerRowHidden = !dinnerRowHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    func toggleDinnerpicker() {
        
        dinnerPickerHidden = !dinnerPickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    
    

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 2 {
            toggleWeightpicker()
        }
        else if indexPath.section == 0 && indexPath.row == 5 {
            toggleBreakfastpicker()
        }
        else if indexPath.section == 0 && indexPath.row == 8 {
            toggleLunchpicker()
        }
        else if indexPath.section == 0 && indexPath.row == 11 {
            toggleDinnerpicker()
        }
    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let defaults = UserDefaults.standard
        
        let isEnabled = defaults.bool(forKey: "GetNotifications")
        
        if isEnabled == true {
            if weightPickerHidden && indexPath.section == 0 && indexPath.row == 3 {
                return 0
            }
            else if weightRowHidden && isEnabled == false &&  indexPath.section == 0 && indexPath.row == 1 {
                return 0
            }
            else if breakfastPickerHidden && indexPath.section == 0 && indexPath.row == 6 {
                return 0
            }
            else if breakfastRowHidden && isEnabled == false && indexPath.section == 0 && indexPath.row == 4 {
                return 0
            }
                
            else if lunchPickerHidden && indexPath.section == 0 && indexPath.row == 9 {
                return 0
            }
            else if lunchRowHidden && isEnabled == false && indexPath.section == 0 && indexPath.row == 7 {
                return 0
            }
            else if dinnerPickerHidden && indexPath.section == 0 && indexPath.row == 12 {
                return 0
            }
            else if dinnerRowHidden && isEnabled == false && indexPath.section == 0 && indexPath.row == 10 {
                return 0
            }
            else {
                return super.tableView(tableView, heightForRowAt: indexPath)
            }
            
            
            
            
        }
        else{
            if indexPath.section == 0 && indexPath.row == 1 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 2 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 3 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 4 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 5 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 6 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 7 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 8 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 9 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 10 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 11 {
                return 0
            }
            else if indexPath.section == 0 && indexPath.row == 12 {
                return 0
            }
            else {
                return super.tableView(tableView, heightForRowAt: indexPath)
            }

            
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
}

