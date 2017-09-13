//
//  TodayViewController.swift
//  Lose Weight with Math Today Extension
//
//  Created by Kaleb Cooper on 7/29/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var goalOutlet: UILabel!
    @IBOutlet weak var foodOutlet: UILabel!
    @IBOutlet weak var exerciseOutlet: UILabel!
    @IBOutlet weak var remainingOutlet: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        //Today View Setup
        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
            
        let goalText = sharedDefaults.string(forKey: "goalCalories")
        let foodText = sharedDefaults.string(forKey: "foodCalories")
        let exerciseText = sharedDefaults.string(forKey: "exerciseCalories")
        let remainingText = sharedDefaults.string(forKey: "remainingCalories")
        //print(goalText)
        
        goalOutlet.text = goalText
        foodOutlet.text = foodText
        exerciseOutlet.text = exerciseText
        remainingOutlet.text = remainingText
        
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
