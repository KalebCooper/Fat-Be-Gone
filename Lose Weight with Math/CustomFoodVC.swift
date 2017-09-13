//
//  CustomFoodVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 8/10/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class CustomFoodVC: UITableViewController {
    
    //Variables
    var foodEmoji: [String] = []
    var foodName: [String] = []
    var foodServings: [String] = []
    var foodServingSize: [String] = []
    var foodCalories: [String] = []
    var foodNDBNO: [String] = []
    
    var foodTasks : [NSManagedObject] = []
    
    
    //Outlets

    //Actions
    @IBAction func addButton(_ sender: Any) {
        
        self.performSegue(withIdentifier: "addCustomMeal", sender: self)
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        foodName.removeAll()
        foodEmoji.removeAll()
        foodCalories.removeAll()
        foodServings.removeAll()
        
        coreDataSetup()
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
        return foodName.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! FoodsTableViewCell
        
        
        let name = foodName[indexPath.row]
        cell.foodOutlet.text = name
        let emoji = foodEmoji[indexPath.row]
        cell.emojiOutlet.text = emoji
        let calories = foodCalories[indexPath.row]
        let servings = foodServings[indexPath.row]
        let description = "\(calories) calories from \(servings) serving(s)"
        cell.descriptionOutlet.text = description
       
    
        return cell
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            print("Deleted")
            //context.delete(foodTasks[indexPath.row])
            do {
                print("Deleted")
                
                //tableView.deleteRows(at: [indexPath], with:.fade)
                //tableView.reloadData()
                print("Deleted")
                

                    let fetchRequest =
                        NSFetchRequest<NSManagedObject>(entityName: "Foods")
                    let sectionSortDescriptor = NSSortDescriptor(key: "date", ascending: false)
                    let sortDescriptors = [sectionSortDescriptor]
                    fetchRequest.sortDescriptors = sortDescriptors
                    
                    
                    do{
                        //foodTasks = try context.fetch(Foods.fetchRequest())
                        foodTasks = try context.fetch(fetchRequest)
                        print(foodTasks.count)
                        
                        var beenDeleted = false
                        
                        for i in 0 ..< foodTasks.count-1 {
                            
                            
                            
                            let foodTask = foodTasks[i]
                            
                            if foodTask.value(forKey: "ndbno") as! String == "Custom" && beenDeleted == false  {
                                
                                print(foodTask.value(forKey: "name") as! String)
                                
                                if foodTask.value(forKey: "name") as! String == foodName[indexPath.row] {
                                    
                                    context.delete(foodTasks[i])
                                    try context.save()
                                    
                                    foodName.remove(at: indexPath.row)
                                    self.foodTasks.remove(at: i)
                                    beenDeleted = true
                                    
                                }
                                
                            }
                            
                        }
                        
                    }
                    catch{
                        print("Fetching Failed")
                    }
                
                
                print("Deleted")
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Deleted")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
            //tableView.reloadData()
        }
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
            
            for i in 0 ..< foodTasks.count {
                
                let foodTask = foodTasks[i]
                
                
                
                let foodNDBNOString: String = foodTask.value(forKey: "ndbno") as! String
                    
                if foodNDBNOString == "Custom"{
                    
                    print("Test")
                        
                    foodEmoji.append(foodTask.value(forKey: "emoji") as! String)
                    foodName.append(foodTask.value(forKey: "name") as! String)
                    foodServings.append(foodTask.value(forKey: "servings") as! String)
                    //foodServingSize.append(foodTask.value(forKey: "servingSize") as! String)
                    foodCalories.append(foodTask.value(forKey: "calories") as! String)
                    foodNDBNO.append(foodTask.value(forKey: "ndbno") as! String)
                        
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get Cell Label
        let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell! as! FoodsTableViewCell
        
        //Get Weight and Date from label to pass into details screen
        foodToPass = currentCell.foodOutlet.text
        ndbnoToPass = foodNDBNO[indexPath.row]
        emojiToPass = currentCell.emojiOutlet.text
        caloriesToPass = foodCalories[indexPath.row]
        
        self.performSegue(withIdentifier: "FoodDetails", sender: self)
    }
    
    
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
