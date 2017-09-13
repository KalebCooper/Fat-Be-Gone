//
//  FoodDetailsVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 8/5/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit


class FoodDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    
    
    //Data passing through from SearchFoodVC
    var food: String!
    var ndbno: String!
    var emoji: String!
    var caloriesPassed: String!
    
    var servingSize = Array(1...50)
    var servingMultiplier: Int! = 1
    
    var servingLabel: String!
    
    var window: UIWindow?
    var tabDestination: Int! = 2
    
    //Serving Size
    
    //Protein NutrientID 203
    var protein: String!
    //Sugar NutrientID 269
    var sugar: String!
    //Fat NutrientID 204
    var fat: String!
    //Carbs NutrientID 205
    var carbs: String!
    //Cholesterol NutrientID 601
    var cholestrol: String!
    //Potassium NutrientID 306
    var potassium: String!
    //Energy NutrientID 208
    var calories: String!
    //Fiber NutrientID 291
    var fiber: String!
    //Sodium NutrientID 307
    var sodium: String!
    
    var baseCalories: String!
    var servingSizeRaw: String!
    
    
    
    //Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emojiOutlet: UILabel!
    @IBOutlet weak var foodOutlet: UILabel!
    @IBOutlet weak var calorieOutlet: UILabel!
    @IBOutlet weak var servingPickerOutlet: UIPickerView!
    @IBOutlet weak var fatOutlet: UILabel!
    @IBOutlet weak var cholesterolOutlet: UILabel!
    @IBOutlet weak var sodiumOutlet: UILabel!
    @IBOutlet weak var carbsOutlet: UILabel!
    @IBOutlet weak var proteinOutlet: UILabel!
    @IBOutlet weak var sugarOutlet: UILabel!
    @IBOutlet weak var potassiumOutlet: UILabel!
    @IBOutlet weak var fiberOutlet: UILabel!
    @IBOutlet weak var servingSizeOutlet: UILabel!
    
    
    
    
    //Extra Outlets for Custom Food
    @IBOutlet weak var customFatOutlet: UILabel!
    @IBOutlet weak var customCholesterolOutlet: UILabel!
    @IBOutlet weak var customSodiumOutlet: UILabel!
    @IBOutlet weak var customCarbsOutlet: UILabel!
    @IBOutlet weak var customProteinOutlet: UILabel!
    @IBOutlet weak var customSugarOutlet: UILabel!
    @IBOutlet weak var customPotassiumOutlet: UILabel!
    @IBOutlet weak var customFiberOutlet: UILabel!
    
    
    
    //Actions
    @IBAction func addAction(_ sender: Any) {
        print("Add Food")
        
        //-----
        //Save food to Coredata...
        
        
        //-----
        
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "InitialView") as! UITabBarController
//        vc.selectedIndex = 2
//        present(vc, animated: true, completion: nil)
        
        let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
        
            self.emojiToPass = self.emojiOutlet.text
            self.foodToPass = self.foodOutlet.text
            self.servingsToPass = String(self.servingMultiplier)
            self.servingSizeToPass = self.servingSizeRaw
            self.baseCaloriesToPass = self.baseCalories
            self.caloriesToPass = self.calorieOutlet.text
            
            self.ndbnoToPass = self.ndbno
            
            self.performSegue(withIdentifier: "toAddFood", sender: self)
            
        }
    }
    
    
    
    var timer = Timer()
    
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        print("Updating")
        self.proteinOutlet.text = self.protein
        self.sugarOutlet.text = self.sugar
        self.fatOutlet.text = self.fat
        self.carbsOutlet.text = self.carbs
        self.cholesterolOutlet.text = self.cholestrol
        self.potassiumOutlet.text = self.potassium
        self.calorieOutlet.text = self.calories
        self.fiberOutlet.text = self.fiber
        self.sodiumOutlet.text = self.sodium
        self.servingSizeOutlet.text = self.servingLabel
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //scrollView.contentSize = CGSizeMake(self.view.frame.width, self.view.frame.height+100)
    
        //self.healthStore = HKHealthStore()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        getNutrients(ndbno: ndbno)
        
        let navigationTitle : String! = "Add Food"
        self.title = navigationTitle
        
        self.foodOutlet.text = food
        self.emojiOutlet.text = emoji
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show the navigation bar on other view controllers
        
        
        
        if timer.isValid{
            
        }
        else{
            scheduledTimerWithTimeInterval()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    
    func getNutrients(ndbno: String){
        
        print(ndbno)
        
        
        
        if ndbno == "Custom" {
            
            emojiOutlet.text = emoji
            foodOutlet.text = food
            
            print(caloriesPassed)
            
            let calculatedDouble: Double =  Double(caloriesPassed)!
            
            self.baseCalories = caloriesPassed
            
            let calculated = calculatedDouble * Double(self.servingMultiplier)
            
            let calculatedInt = Int(calculated)
            
            let subtitleString = "\(calculatedInt)"
            
            self.calories = subtitleString
            
            
            //Make unused labels blank
            customFatOutlet.text = ""
            customCholesterolOutlet.text = ""
            customSodiumOutlet.text = ""
            customCarbsOutlet.text = ""
            customProteinOutlet.text = ""
            customSugarOutlet.text = ""
            customPotassiumOutlet.text = ""
            customFiberOutlet.text = ""
            
            
        }
        else{
            
            //-----------------------------------------------------------------------------
            //Get Calories
            //-----------------------------------------------------------------------------
            //let when = DispatchTime.now() + 1.0 // change 2 to desired number of seconds
            //DispatchQueue.main.asyncAfter(deadline: when) {
            DispatchQueue.main.async {
                let apiKey: String = "MqE5OpBHdNfIdzxFjz2PCgDAU2Bxf7eIHxTOb1BU"
                let jsonUrlString = "https://api.nal.usda.gov/ndb/nutrients/?format=json&api_key=\(apiKey)&nutrients=208&nutrients=203&nutrients=204&nutrients=205&nutrients=291&nutrients=269&nutrients=307&nutrients=601&nutrients=306&ndbno=\(ndbno)"
                let url = URL(string: jsonUrlString)
                
                print("Getting calories")
                
                
                
                URLSession.shared.dataTask(with: url!) { (data, response, err) in
                    
                    guard let data = data else {
                        return
                    }
                    
                    let dataAsString = String(data: data, encoding: .utf8)
                    
                    do {
                        
                        
                        
                        let data = dataAsString?.data(using: .utf8)!
                        if let json = try? JSONSerialization.jsonObject(with: data!) as? [String:Any] {
                            
                            
                            
                            if let report = json!["report"] as? [String:Any]{
                                
                                if let foods = report["foods"] as? NSArray{
                                    //print(foods[0])
                                    if let nutrients = foods[0] as? [String:Any]{
                                        let measureSize: String = (nutrients["measure"]) as! String
                                        
                                        self.servingSizeRaw = measureSize
                                        //let servingSize = measureSize.components(separatedBy: " ")
                                        
                                        self.servingLabel = "Serving Size: \(measureSize)"
                                        
                                        if let nextNutrients = nutrients["nutrients"] as? NSArray {
                                            
                                            
                                            //Protein
                                            if let info = nextNutrients[0] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.protein = value
                                                    
                                                    print(self.protein)
                                                }
                                                else{
                                                    
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let subtitleString = "\(calculated)g"
                                                    
                                                    self.protein = subtitleString
                                                    
                                                    print(self.protein)
                                                }
                                            }
                                            //Sugar
                                            if let info = nextNutrients[1] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.sugar = value
                                                    
                                                    print(self.sugar)
                                                }
                                                else{
                                                    
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let subtitleString = "\(calculated)g"
                                                    
                                                    self.sugar = subtitleString
                                                    
                                                    print(self.sugar)
                                                }
                                            }
                                            //Fat
                                            if let info = nextNutrients[2] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.fat = value
                                                    
                                                    print(self.fat)
                                                }
                                                else{
                                                    
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let subtitleString = "\(calculated)g"
                                                    
                                                    self.fat = subtitleString
                                                    
                                                    print(self.fat)
                                                }
                                            }
                                            //Carbs
                                            if let info = nextNutrients[3] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.carbs = value
                                                    
                                                    print(self.carbs)
                                                }
                                                else{
                                                    
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let subtitleString = "\(calculated)g"
                                                    
                                                    self.carbs = subtitleString
                                                    
                                                    print(self.carbs)
                                                }
                                            }
                                            //Cholesterol
                                            if let info = nextNutrients[4] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.cholestrol = value
                                                    
                                                    print(self.cholestrol)
                                                }
                                                else{
                                                    
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let subtitleString = "\(calculated)mg"
                                                    
                                                    self.cholestrol = subtitleString
                                                    
                                                    print(self.cholestrol)
                                                }
                                            }
                                            //Potassium
                                            if let info = nextNutrients[5] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.potassium = value
                                                    
                                                    print(self.potassium)
                                                }
                                                else{
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let subtitleString = "\(calculated)mg"
                                                    
                                                    self.potassium = subtitleString
                                                    
                                                    print(self.potassium)
                                                }
                                                
                                                
                                            }
                                            //Calories
                                            if let info = nextNutrients[6] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.calories = value
                                                    
                                                    print(self.calories)
                                                }
                                                else{
                                                    
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    self.baseCalories = value
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let calculatedInt = Int(calculated)
                                                    
                                                    let subtitleString = "\(calculatedInt)"
                                                    
                                                    self.calories = subtitleString
                                                    
                                                    print(self.calories)
                                                }
                                            }
                                            //Fiber
                                            if let info = nextNutrients[7] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.fiber = value
                                                    
                                                    print(self.fiber)
                                                }
                                                else{
                                                    
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let subtitleString = "\(calculated)g"
                                                    
                                                    self.fiber = subtitleString
                                                    
                                                    print(self.fiber)
                                                }
                                            }
                                            //Sodium
                                            if let info = nextNutrients[8] as? [String:Any] {
                                                let value: String = info["value"] as! String
                                                
                                                if value == "--"{
                                                    self.sodium = value
                                                    
                                                    print(self.sodium)
                                                }
                                                else{
                                                    
                                                    let calculatedDouble: Double =  Double(value)!
                                                    
                                                    let calculated = calculatedDouble * Double(self.servingMultiplier)
                                                    
                                                    let subtitleString = "\(calculated)mg"
                                                    
                                                    self.sodium = subtitleString
                                                    
                                                    print(self.sodium)
                                                }
                                            }
                                        }
                                        
                                    }
                                    
                                    
                                }
                            }
                        }
                        
                        //print(self.descriptionArray.count)
                        //print(self.nameArray.count)
                        
                        
                    } catch let jsonErr {
                        print("Error serializing json:", jsonErr)
                    }
                    
                    }.resume()
                
                
                
                
                
                
                
            }
            
            //-----------------------------------------------------------------------------
            //-----------------------------------------------------------------------------
            
            
            
        }
        
        
        
    }
    
    
    //PICKER VIEW FUNCTIONS
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        if component == 0 {
            return servingSize.count
        }
        else{
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0{
            return String(servingSize[row])
        }
        else{
            return "serving(s)"
        }
        
        
        
    }

    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        servingMultiplier = servingSize[row]
        getNutrients(ndbno: ndbno)
        
    }
    
    var emojiToPass:String!
    var foodToPass:String!
    var servingsToPass:String!
    var servingSizeToPass: String!
    var baseCaloriesToPass:String!
    var caloriesToPass:String!
    var ndbnoToPass:String!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toAddFood") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! ConfirmFoodVC
            // your new view controller should have property that will store passed value
            viewController.emoji = emojiToPass
            viewController.food = foodToPass
            viewController.servings = servingsToPass
            viewController.servingSizeRaw = servingSizeToPass
            viewController.baseCalories = baseCaloriesToPass
            viewController.calories = caloriesToPass
            viewController.ndbno = ndbnoToPass
        }
    }
    
    
    
}
