//
//  WeightLogDetailsVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/27/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import HealthKit


class WeightLogDetailsVC: UITableViewController {
    
    
    //HealthKit
    var healthStore: HKHealthStore?
//    private var activeEnergyBurned: Double = 0.0 {
//        didSet {
//            didSetActiveEnergyBurned(oldValue)
//        }
//    }
//    private var energyConsumed: Double = 0.0 {
//        didSet {
//            didSetEnergyConsumed(oldValue)
//        }
//    }
    
    //Data passing through from WeightLogVC
    var weight: String!
    var date: String!
    var previousWeightChange: String!
    var caloricIntake: String!
    var caloriesBurned: String!
    var steps: String!
    var timeExercising: String!
    
    
    
    //Outlets
    @IBOutlet weak var weightLoggedOutlet: UILabel!
    @IBOutlet weak var previousWeightLoggedOutlet: UILabel!
    @IBOutlet weak var caloricIntakeOutlet: UILabel!
    @IBOutlet weak var caloriesBurnedOutlet: UILabel!
    @IBOutlet weak var stepsOutlet: UILabel!
    @IBOutlet weak var timeExercisingOutlet: UILabel!
    
    //Actions
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Logs] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.healthStore = HKHealthStore()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.tintColor = .white
        
        weightLoggedOutlet.text = weight
        previousWeightLoggedOutlet.text = previousWeightChange
        caloricIntakeOutlet.text = caloricIntake
        caloriesBurnedOutlet.text = caloriesBurned
        stepsOutlet.text = steps
        timeExercisingOutlet.text = timeExercising
        let navigationTitle : String! = "Logs for \(date!)"
        self.title = navigationTitle
        
//        do {
//            tasks = try context.fetch(Logs.fetchRequest())
//        } catch {
//            print("Fetching Failed")
//        }
//
//        let task = tasks[0]
//
//        if let curWeight = task.weight {
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func acceptData(weight: String){
        
    }
    
    //HealthKit related
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//
//        self.refreshControl?.addTarget(self, action: #selector(WeightLogDetailsVC.refreshStatistics), for: .valueChanged)
//
//
//        self.refreshStatistics()
//
//        NotificationCenter.default.addObserver(self, selector: #selector(WeightLogDetailsVC.refreshStatistics), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
//    }
    
    
    
    //MARK: - Reading HealthKit Data
    
//    @objc private func refreshStatistics() {
//        self.refreshControl?.beginRefreshing()
//
//        let activeEnergyBurnType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)
//        let energyConsumedType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryEnergyConsumed)
//
//
//        // First, fetch the sum of energy consumed samples from HealthKit. Populate this by creating your
//        // own food logging app or using the food journal view controller.
//        self.fetchSumOfSamplesTodayForType(energyConsumedType!, unit: HKUnit.joule()) {totalJoulesConsumed, error in
//
//            // Next, fetch the sum of active energy burned from HealthKit. Populate this by creating your
//            // own calorie tracking app or the Health app.
//            self.fetchSumOfSamplesTodayForType(activeEnergyBurnType!, unit: HKUnit.joule()) {activeEnergyBurned, error in
//
//                // Update the UI with all of the fetched values.
//                DispatchQueue.main.async {
//                    self.activeEnergyBurned = activeEnergyBurned
//                    self.energyConsumed = totalJoulesConsumed
//                    self.refreshControl?.endRefreshing()
//                }
//            }
//        }
//    }
//
//    private func fetchSumOfSamplesTodayForType(_ quantityType: HKQuantityType, unit: HKUnit, completion completionHandler: ((Double, Error?)->Void)?) {
//
//        let predicate = predicateForSamplesToday()
//
//        let query = HKStatisticsQuery(quantityType: quantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) {query, result, error in
//            let sum = result?.sumQuantity()
//
//            if completionHandler != nil {
//                let value: Double = sum?.doubleValue(for: unit) ?? 0.0
//
//                completionHandler!(value, error)
//            }
//        }
//        self.healthStore?.execute(query)
//    }
//
//    //MARK: - Convenience
//
//    private func predicateForSamplesToday() -> NSPredicate {
//        let calendar = Calendar.current
//
//        print("Date is \(date)")
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd-yyyy" //Your date format
//        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00") //Current time zone
//        let convertedDate = dateFormatter.date(from: date) //according to date format your date string
//        print("Converted Date is \(convertedDate)")
//
//        let now = convertedDate
//
//        let startDate = calendar.startOfDay(for: now!)
//        let endDate = (calendar as NSCalendar).date(byAdding: .day, value: -1, to: startDate, options: [])
//
//        return HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
//    }
//
//    //MARK: - NSEnergyFormatter
//
//    private lazy var energyFormatter: EnergyFormatter = {
//        let formatter = EnergyFormatter()
//        formatter.unitStyle = .long
//        formatter.isForFoodEnergyUse = true
//        formatter.numberFormatter.maximumFractionDigits = 0
//        return formatter
//    }()
//
//    //MARK: - Setter Overrides
//
//    private func didSetActiveEnergyBurned(_ oldValue: Double) {
//
//        let exerciseArray = energyFormatter.string(fromJoules: activeEnergyBurned).components(separatedBy: " ")
//        self.caloriesBurnedOutlet?.text = "\(exerciseArray[0]) calories"
//        print(energyFormatter.string(fromJoules: activeEnergyBurned))
//        refreshStatistics()
//        self.tableView.reloadData()
//    }
//    private func didSetEnergyConsumed(_ oldValue: Double) {
//
//        let foodArray = energyFormatter.string(fromJoules:  energyConsumed).components(separatedBy: " ")
//        self.caloricIntakeOutlet?.text = "\(foodArray[0]) calories"
//        print(energyFormatter.string(fromJoules: energyConsumed))
//        refreshStatistics()
//        self.tableView.reloadData()
//    }
}
