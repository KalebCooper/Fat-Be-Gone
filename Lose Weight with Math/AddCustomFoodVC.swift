//
//  AddCustomFoodVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 8/10/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class AddCustomFoodVC: UITableViewController {
    
    //Variables
    
    //Outlets
    @IBOutlet weak var nameOutlet: UITextField!
    @IBOutlet weak var emojiOutlet: UITextField!
    @IBOutlet weak var caloriesOutlet: UITextField!
    
    
    
    @IBAction func foodSaved(_ sender: Any) {
        
        if nameOutlet.text != "" && emojiOutlet.text != "" && caloriesOutlet.text != ""{
            
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let task = Foods(context: context)
            
            task.emoji = emojiOutlet.text!
            task.name = nameOutlet.text!
            
            //Convert label text to NSDate
            let date = Date()
            
            task.date = date
            task.meal = "None"
            task.servings = "1"
            task.calories = caloriesOutlet.text
            task.servingSize = "1.0 serving"
            task.ndbno = "Custom"
            
            //Save the data to CoreData
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            print("CoreData has been saved to")
            
            //self.dismiss(animated: true, completion: nil)
            _ = navigationController?.popViewController(animated: true)
            
        }
        else{
            let alert = UIAlertController(title: "Error", message: "Please enter a value for all three fields.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.tintColor = .white
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
        return 3
    }


}
