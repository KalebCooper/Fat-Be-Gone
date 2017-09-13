//
//  AddFoodVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 8/7/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import CoreData
import HealthKit


class AddFoodVC: UITableViewController{
    
    //Outlets
    @IBOutlet weak var firstEmoji: UILabel!
    @IBOutlet weak var firstTitle: UILabel!
    @IBOutlet weak var firstDescription: UILabel!
    
    @IBOutlet weak var secondEmoji: UILabel!
    @IBOutlet weak var secondTitle: UILabel!
    @IBOutlet weak var secondDescription: UILabel!
    
    @IBOutlet weak var thirdEmoji: UILabel!
    @IBOutlet weak var thirdTitle: UILabel!
    @IBOutlet weak var thirdDescription: UILabel!
    
    @IBOutlet weak var fourthEmoji: UILabel!
    @IBOutlet weak var fourthTitle: UILabel!
    @IBOutlet weak var fourthDescription: UILabel!
    
    @IBOutlet weak var fifthEmoji: UILabel!
    @IBOutlet weak var fifthTitle: UILabel!
    @IBOutlet weak var fifthDescription: UILabel!
    
    //Variables
    var emojiArray: [String] = []
    var foodArray: [String] = []
    var descriptionArray: [String] = []
    var ndbnoArray: [String] = []
    var foodCalories: [String] = []
    
    var foodTasks : [NSManagedObject] = []
    var count: Int!
    
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.tintColor = .white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return 3
        }
        else{
            return 6
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get Cell Label
        //let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell!
        
        //Get Weight and Date from label to pass into details screen
        //self.performSegue(withIdentifier: "toWeightLogDetails", sender: self)
        
        if indexPath.section == 0 && indexPath.row == 1{
            
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "InitialView") as! UITabBarController
            vc.selectedIndex = 3
            present(vc, animated: true, completion: nil)
            
        }
        else if indexPath.section == 0 && indexPath.row == 2 {
            self.performSegue(withIdentifier: "toCustomMeals", sender: self)
        }
        else if indexPath.section == 1 && indexPath.row == 1 && count >= 1 {
            //Get Weight and Date from label to pass into details screen
            emojiToPass = firstEmoji.text
            foodToPass = firstTitle.text
            ndbnoToPass = ndbnoArray[0]
            caloriesToPass = foodCalories[0]
            
            self.performSegue(withIdentifier: "FoodDetails", sender: self)
        }
        else if indexPath.section == 1 && indexPath.row == 2 && count >= 2 {
            //Get Weight and Date from label to pass into details screen
            emojiToPass = secondEmoji.text
            foodToPass = secondTitle.text
            ndbnoToPass = ndbnoArray[1]
            caloriesToPass = foodCalories[1]
            
            self.performSegue(withIdentifier: "FoodDetails", sender: self)
        }
        else if indexPath.section == 1 && indexPath.row == 3 && count >= 3 {
            //Get Weight and Date from label to pass into details screen
            emojiToPass = thirdEmoji.text
            foodToPass = thirdTitle.text
            ndbnoToPass = ndbnoArray[2]
            caloriesToPass = foodCalories[2]
            
            self.performSegue(withIdentifier: "FoodDetails", sender: self)
        }
        else if indexPath.section == 1 && indexPath.row == 4 && count >= 4 {
            //Get Weight and Date from label to pass into details screen
            emojiToPass = fourthEmoji.text
            foodToPass = fourthTitle.text
            ndbnoToPass = ndbnoArray[3]
            caloriesToPass = foodCalories[3]
            
            self.performSegue(withIdentifier: "FoodDetails", sender: self)
        }
        else if indexPath.section == 1 && indexPath.row == 5 && count >= 5 {
            //Get Weight and Date from label to pass into details screen
            emojiToPass = fifthEmoji.text
            foodToPass = fifthTitle.text
            ndbnoToPass = ndbnoArray[4]
            caloriesToPass = foodCalories[4]
            
            self.performSegue(withIdentifier: "FoodDetails", sender: self)
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ndbnoArray.removeAll()
        coreDataSetup()
    }
    
    
    
    func coreDataSetup(){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Foods")
        let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        
        do{
            //foodTasks = try context.fetch(Foods.fetchRequest())
            foodTasks = try context.fetch(fetchRequest)
            print(foodTasks.count)
            
            count = foodTasks.count
            
            if count > 4 {
                count = 5
            }
            
            
            if count == 0 {
                
                firstEmoji.text = ""
                firstTitle.text = ""
                firstDescription.text = ""
                
                secondEmoji.text = ""
                secondTitle.text = ""
                secondDescription.text = ""
                
                thirdEmoji.text = ""
                thirdTitle.text = ""
                thirdDescription.text = ""
                
                fourthEmoji.text = ""
                fourthTitle.text = ""
                fourthDescription.text = ""
                
                fifthEmoji.text = ""
                fifthTitle.text = ""
                fifthDescription.text = ""
                
            }
            
            for i in 0 ..< count {
                
                let foodTask = foodTasks[i]

                if i == 0{
                    
                    firstEmoji.text = (foodTask.value(forKey: "emoji") as! String)
                    firstTitle.text = (foodTask.value(forKey: "name") as! String)
                    ndbnoArray.append(foodTask.value(forKey: "ndbno") as! String)
                    foodCalories.append(foodTask.value(forKey: "calories") as! String)
                        
                    let calories = (foodTask.value(forKey: "calories") as! String)
                    let servings = (foodTask.value(forKey: "servings") as! String)
                    let description = "\(calories) calories from \(servings) serving(s)"
                    firstDescription.text = description
                        
                    if count-1 == i {
                        secondEmoji.text = ""
                        secondTitle.text = ""
                        secondDescription.text = ""
                            
                        thirdEmoji.text = ""
                        thirdTitle.text = ""
                        thirdDescription.text = ""
                            
                        fourthEmoji.text = ""
                        fourthTitle.text = ""
                        fourthDescription.text = ""
                            
                        fifthEmoji.text = ""
                        fifthTitle.text = ""
                        fifthDescription.text = ""
                    }
                }
                else if i == 1 {
                    
                        secondEmoji.text = (foodTask.value(forKey: "emoji") as! String)
                        secondTitle.text = (foodTask.value(forKey: "name") as! String)
                        ndbnoArray.append(foodTask.value(forKey: "ndbno") as! String)
                        foodCalories.append(foodTask.value(forKey: "calories") as! String)
                        
                        let calories = (foodTask.value(forKey: "calories") as! String)
                        let servings = (foodTask.value(forKey: "servings") as! String)
                        let description = "\(calories) calories from \(servings) serving(s)"
                        secondDescription.text = description
                    
                    
                    if count-1 == i {
                        thirdEmoji.text = ""
                        thirdTitle.text = ""
                        thirdDescription.text = ""
                        
                        fourthEmoji.text = ""
                        fourthTitle.text = ""
                        fourthDescription.text = ""
                        
                        fifthEmoji.text = ""
                        fifthTitle.text = ""
                        fifthDescription.text = ""
                    }
                }
                    
                else if i == 2 {
                    
                    thirdEmoji.text = (foodTask.value(forKey: "emoji") as! String)
                    thirdTitle.text = (foodTask.value(forKey: "name") as! String)
                    ndbnoArray.append(foodTask.value(forKey: "ndbno") as! String)
                    foodCalories.append(foodTask.value(forKey: "calories") as! String)
                        
                    let calories = (foodTask.value(forKey: "calories") as! String)
                    let servings = (foodTask.value(forKey: "servings") as! String)
                    let description = "\(calories) calories from \(servings) serving(s)"
                    thirdDescription.text = description
                    
                    if count-1 == i {
                        fourthEmoji.text = ""
                        fourthTitle.text = ""
                        fourthDescription.text = ""
                        
                        fifthEmoji.text = ""
                        fifthTitle.text = ""
                        fifthDescription.text = ""
                    }
                }
                else if i == 3 {
                    
                    fourthEmoji.text = (foodTask.value(forKey: "emoji") as! String)
                    fourthTitle.text = (foodTask.value(forKey: "name") as! String)
                    ndbnoArray.append(foodTask.value(forKey: "ndbno") as! String)
                    foodCalories.append(foodTask.value(forKey: "calories") as! String)
                        
                    let calories = (foodTask.value(forKey: "calories") as! String)
                    let servings = (foodTask.value(forKey: "servings") as! String)
                    let description = "\(calories) calories from \(servings) serving(s)"
                    fourthDescription.text = description
                    
                    if count-1 == i {
                        fifthEmoji.text = ""
                        fifthTitle.text = ""
                        fifthDescription.text = ""
                    }
    
                }
                else if i == 4 {

                    fifthEmoji.text = (foodTask.value(forKey: "emoji") as! String)
                    fifthTitle.text = (foodTask.value(forKey: "name") as! String)
                    ndbnoArray.append(foodTask.value(forKey: "ndbno") as! String)
                    foodCalories.append(foodTask.value(forKey: "calories") as! String)
                        
                    let calories = (foodTask.value(forKey: "calories") as! String)
                    let servings = (foodTask.value(forKey: "servings") as! String)
                    let description = "\(calories) calories from \(servings) serving(s)"
                    fifthDescription.text = description
                    
                    
                }
            }
            
        }
        catch{
            print("Fetching Failed")
        }
        
        self.tableView.reloadData()
    }
    
    var foodToPass:String!
    var ndbnoToPass:String!
    var emojiToPass:String!
    var caloriesToPass: String!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "FoodDetails") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! FoodDetailsVC
            // your new view controller should have property that will store passed value
            viewController.food = foodToPass
            viewController.ndbno = ndbnoToPass
            viewController.emoji = emojiToPass
            viewController.caloriesPassed = caloriesToPass
        }
    }

}
