//
//  ViewFoodsVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 8/8/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class FoodsTableViewCell: UITableViewCell {
    @IBOutlet weak var emojiOutlet: UILabel!
    @IBOutlet weak var foodOutlet: UILabel!
    @IBOutlet weak var descriptionOutlet: UILabel!
}

class ViewFoodsVC: UITableViewController {
    
    
    //Food Variables
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
    
    //Variables
    var meal: String!
    var foodTasks : [NSManagedObject] = []
    
    //Outlets

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationController?.navigationBar.tintColor = .white
        
        self.navigationItem.title = meal
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
            breakfastEmoji.removeAll()
            breakfastName.removeAll()
            breakfastServings.removeAll()
            breakfastCalories.removeAll()
            breakfastNDBNO.removeAll()

            lunchEmoji.removeAll()
            lunchName.removeAll()
            lunchServings.removeAll()
            lunchCalories.removeAll()
            lunchNDBNO.removeAll()
            
            dinnerEmoji.removeAll()
            dinnerName.removeAll()
            dinnerServings.removeAll()
            dinnerCalories.removeAll()
            dinnerNDBNO.removeAll()
            
            snackEmoji.removeAll()
            snackName.removeAll()
            snackServings.removeAll()
            snackCalories.removeAll()
            snackNDBNO.removeAll()
        
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
        
        if meal == "Breakfast"{
            return breakfastName.count
        }
        else if meal == "Lunch" {
            return lunchName.count
        }
        else if meal == "Dinner" {
            return dinnerName.count
        }
        else {
            return snackName.count
        }
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! FoodsTableViewCell
        
        
        if meal == "Breakfast"{
            let name = breakfastName[indexPath.row]
            cell.foodOutlet.text = name
            let emoji = breakfastEmoji[indexPath.row]
            cell.emojiOutlet.text = emoji
            let calories = breakfastCalories[indexPath.row]
            let servings = breakfastServings[indexPath.row]
            let description = "\(calories) calories from \(servings) serving(s)"
            cell.descriptionOutlet.text = description
        }
        else if meal == "Lunch"{
            let name = lunchName[indexPath.row]
            cell.foodOutlet.text = name
            let emoji = lunchEmoji[indexPath.row]
            cell.emojiOutlet.text = emoji
            let calories = lunchCalories[indexPath.row]
            let servings = lunchServings[indexPath.row]
            let description = "\(calories) calories from \(servings) serving(s)"
            cell.descriptionOutlet.text = description
        }
        else if meal == "Dinner"{
            let name = dinnerName[indexPath.row]
            cell.foodOutlet.text = name
            let emoji = dinnerEmoji[indexPath.row]
            cell.emojiOutlet.text = emoji
            let calories = dinnerCalories[indexPath.row]
            let servings = dinnerServings[indexPath.row]
            let description = "\(calories) calories from \(servings) serving(s)"
            cell.descriptionOutlet.text = description
        }
        else if meal == "Snack"{
            let name = snackName[indexPath.row]
            print(name)
            cell.foodOutlet.text = name
            let emoji = snackEmoji[indexPath.row]
            cell.emojiOutlet.text = emoji
            let calories = snackCalories[indexPath.row]
            let servings = snackServings[indexPath.row]
            let description = "\(calories) calories from \(servings) serving(s)"
            cell.descriptionOutlet.text = description
        }
        

        // Configure the cell...

        return cell
    }
 

    // EDIT CELL
    
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

                if meal == "Breakfast"{
                    
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
                            
                            if foodTask.value(forKey: "meal") as! String == meal && beenDeleted == false  {
                                
                                print(foodTask.value(forKey: "name") as! String)
                                
                                if foodTask.value(forKey: "name") as! String == breakfastName[indexPath.row] {
                                    
                                    context.delete(foodTasks[i])
                                    try context.save()
                                    
                                    breakfastName.remove(at: indexPath.row)
                                    self.foodTasks.remove(at: i)
                                    beenDeleted = true
                                    
                                }
                            }
                        }
                    }
                    catch{
                        print("Fetching Failed")
                    }
                }
                else if meal == "Lunch" {
                    
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
                            
                            if foodTask.value(forKey: "meal") as! String == meal && beenDeleted == false  {
                                
                                print(foodTask.value(forKey: "name") as! String)
                                
                                if foodTask.value(forKey: "name") as! String == lunchName[indexPath.row] {
                                    
                                    context.delete(foodTasks[i])
                                    try context.save()
                                    
                                    lunchName.remove(at: indexPath.row)
                                    self.foodTasks.remove(at: i)
                                    beenDeleted = true
                                    
                                }
                            }
                        }
                    }
                    catch{
                        print("Fetching Failed")
                    }
                }
                else if meal == "Dinner" {
                    
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

                            if foodTask.value(forKey: "meal") as! String == meal && beenDeleted == false {
                                
                                print(foodTask.value(forKey: "name") as! String)
                                print(dinnerName[0])
                                print(indexPath.row)
                                print(i)
                                print(foodTasks.count-1)
                                
                                if foodTask.value(forKey: "name") as! String == dinnerName[indexPath.row] {
                                    
                                    print("Same string")
                                    
                                    context.delete(foodTasks[i])
                                    try context.save()
                                    
                                    dinnerName.remove(at: indexPath.row)
                                    self.foodTasks.remove(at: i)
                                    beenDeleted = true
                                    
                                }
                            }
                        }
                    }
                    catch{
                        print("Fetching Failed")
                    }
                }
                else {
                    
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
                            
                            if foodTask.value(forKey: "meal") as! String == meal && beenDeleted == false  {
                                
                                print(foodTask.value(forKey: "name") as! String)
                                
                                if foodTask.value(forKey: "name") as! String == snackName[indexPath.row] {
                                    
                                    context.delete(foodTasks[i])
                                    try context.save()
                                    
                                    snackName.remove(at: indexPath.row)
                                    self.foodTasks.remove(at: i)
                                    beenDeleted = true
                                    
                                }
                            }
                        }
                        
                    }
                    catch{
                        print("Fetching Failed")
                    }
                }
                
                print("Deleted")
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                print("Deleted")
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
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
            
        }
        catch{
            print("Fetching Failed")
        }
        
        self.tableView.reloadData()
    }
}
