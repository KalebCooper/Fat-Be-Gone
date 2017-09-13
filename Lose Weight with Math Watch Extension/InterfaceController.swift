//
//  InterfaceController.swift
//  Lose Weight Extension
//
//  Created by Kaleb Cooper on 7/28/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession?
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Fill in
    }
    

    //Outlets
    @IBOutlet var goalCaloriesOutlet: WKInterfaceLabel!
    @IBOutlet var foodCaloriesOutlet: WKInterfaceLabel!
    @IBOutlet var exerciseCaloriesOutlet: WKInterfaceLabel!
    @IBOutlet var remainingCaloriesOutlet: WKInterfaceLabel!
    
    //Variables

    //WCSessionDelegate functions
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //Use this to update the UI instantaneously (otherwise, takes a little while)
        DispatchQueue.main.async() {
            
            let goalText = message["goalMessage"] as! String
            let foodText = message["foodMessage"] as! String
            let exerciseText = message["exerciseMessage"] as! String
            let remainingText = message["remainingMessage"] as! String
            
            print(goalText)
            print(foodText)
            print(exerciseText)
            print(remainingText)
            
            
            
            self.goalCaloriesOutlet.setText(goalText)
            self.foodCaloriesOutlet.setText(foodText)
            self.exerciseCaloriesOutlet.setText(exerciseText)
            self.remainingCaloriesOutlet.setText(remainingText)
            
            let defaults = UserDefaults.standard
            
            defaults.set(goalText, forKey: "WatchGoalText")
            defaults.set(foodText, forKey: "WatchFoodText")
            defaults.set(exerciseText, forKey: "WatchExerciseText")
            defaults.set(remainingText, forKey: "WatchRemainingText")
        }
    }
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        
        let defaults = UserDefaults.standard
        
        self.goalCaloriesOutlet.setText(defaults.string(forKey: "WatchGoalText"))
        self.foodCaloriesOutlet.setText(defaults.string(forKey: "WatchFoodText"))
        self.exerciseCaloriesOutlet.setText(defaults.string(forKey: "WatchExerciseText"))
        self.remainingCaloriesOutlet.setText(defaults.string(forKey: "WatchRemainingText"))
        
        
//        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")
//        let sharedDefaults = UserDefaults
//        let goalText = sharedDefaults.object(forKey: "sharedGoalCalories") as! String
//        let foodText = sharedDefaults.object(forKey: "sharedFoodCalories") as! String
//        let exerciseText = sharedDefaults.object(forKey: "sharedExerciseCalories") as! String
//        let remainingText = sharedDefaults.object(forKey: "sharedRemainingCalories") as! String
//        let goalText = "1578"
//        let foodText = "0"
//        let exerciseText = "0"
//        let remainingText = "1578"
        
        
        
//        goalCaloriesOutlet.setText(goalText)
//        foodCaloriesOutlet.setText(foodText)
//        exerciseCaloriesOutlet.setText(exerciseText)
//        remainingCaloriesOutlet.setText(remainingText)
        
        
    }
    
    override func willActivate() {
        super.willActivate()
        
        if (WCSession.isSupported()) {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    

}
