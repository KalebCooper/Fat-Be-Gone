//
//  bmiVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/9/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import UIKit

class BmiVC: UIViewController {
    
    
    
    //Outlets
    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var footLabel: UITextField!
    @IBOutlet weak var inchLabel: UITextField!
    @IBOutlet weak var poundLabel: UITextField!
    
    
    @IBOutlet weak var sliderOutlet: UISlider!
    
    @IBOutlet var backgroundOutlet: UIView!
    
    @IBOutlet weak var arrowOutlet: UIImageView!
    
    

    @IBAction func feetChanging(_ sender: Any) {
        if(footLabel.text != ""){
            if footLabel.text!.characters.count > 1 {
                footLabel.deleteBackward()
                print("Value is not nil")
                updateOutput()
                
            }
            else{
                print("Value is not nil")
                updateOutput()
            }
        }
        else{
            print("Value is nil")
        }
    }
    
    @IBAction func inchesChanging(_ sender: Any) {
        if(inchLabel.text != ""){
            
            let inchInt: Int = Int(inchLabel.text!)!
            
            if inchInt > 11{
                inchLabel.text = "11"
            }
            
            if inchLabel.text!.characters.count > 2 {
                inchLabel.deleteBackward()
                print("Value is not nil")
                updateOutput()
                
            }
            else{
                print("Value is not nil")
                updateOutput()
            }
            
        }
        else{
            print("Value is nil")
        }
    }
    
    @IBAction func weightChanging(_ sender: Any) {
        if(poundLabel.text != ""){
            if poundLabel.text!.characters.count > 3 {
                poundLabel.deleteBackward()
                print("Value is not nil")
                updateOutput()
                
            }
            else{
                print("Value is not nil")
                updateOutput()
            }
        }
        else{
            //print("Value is nil")
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        print(self.sliderOutlet.value)
    }
    
    func updateOutput(){
        
        let when = DispatchTime.now() + 0.1 // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            let feet:String? = self.footLabel.text!
            let inches:String? = self.inchLabel.text!
            let pounds:String? = self.poundLabel.text!
            
            var feetValue:Double = 0.0
            var inchesValue:Double = 0.0
            var poundsValue:Double = 0.0
            
            
            if let feetDouble:Double = Double(feet!){
                feetValue = feetDouble
            }
            else{
            }
            if let inchesDouble:Double = Double(inches!){
                inchesValue = inchesDouble
            }
            else{
            }
            if let poundsDouble:Double = Double(pounds!){
                poundsValue = poundsDouble
            }
            else{
            }
            
            var inchesVariable:Double
            var heightVariable:Double
            var bmi:Double
            
            inchesVariable = ((feetValue * 12) + inchesValue)
            heightVariable = inchesVariable * inchesVariable
            bmi = ((poundsValue / heightVariable) * 703)
            
            
            
            self.bmiLabel.text = String(format: "%.1f", bmi)
            
            UIView.animate(withDuration: 0.75, animations: {
                self.sliderOutlet.setValue(Float(bmi), animated:true)
            })
            
            
            if(bmi < 8){
                UIView.transition(with: self.bmiLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { self.bmiLabel.textColor = UIColor.black }, completion: nil)
            }
            else if(bmi < 13.5 && bmi >= 8){
                UIView.transition(with: self.bmiLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { self.bmiLabel.textColor = UIColor.red }, completion: nil)
            }
            else if(bmi < 18.5 && bmi >= 13.5){
                UIView.transition(with: self.bmiLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { self.bmiLabel.textColor = UIColor.orange }, completion: nil)
            }
            else if(bmi >= 18.5 && bmi < 25){
                UIView.transition(with: self.bmiLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { self.bmiLabel.textColor = UIColor.green }, completion: nil)
            }
            else if(bmi >= 25 && bmi < 30){
                UIView.transition(with: self.bmiLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { self.bmiLabel.textColor = UIColor.orange }, completion: nil)
            }
            else if(bmi >= 30){
                UIView.transition(with: self.bmiLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { self.bmiLabel.textColor = UIColor.red }, completion: nil)
            }
            
            
            
            print("Feet: \(feetValue)")
            print("Inches: \(inchesValue)")
            print("Pounds: \(poundsValue)")
            print("heightVariable: \(heightVariable)")
            print("BMI: \(bmi)")
            
            
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Logs] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Set initial values in calculator
        
        let defaults = UserDefaults.standard
        let heightText = defaults.string(forKey: "Height")
        let weightText = defaults.string(forKey: "CurrentWeight")
        
        let heightString: String! = heightText
        let heightArrayOne = heightString.components(separatedBy: "'")
        let heightArrayTwo = heightArrayOne[1].components(separatedBy: "\"")
        
        print(heightArrayOne)
        print(heightArrayTwo)
        print(heightArrayOne[0])
        print(heightArrayTwo[0])
        
        let weightArray = weightText?.components(separatedBy: (" "))

        footLabel.text = heightArrayOne[0]
        inchLabel.text = heightArrayTwo[0]
        poundLabel.text = weightArray?[0]
        
        
        //poundLabel.size
        

        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BmiVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        updateOutput()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let defaults = UserDefaults.standard
        let heightText = defaults.string(forKey: "Height")
        let weightText = defaults.string(forKey: "CurrentWeight")
        
        let heightString: String! = heightText
        let heightArrayOne = heightString.components(separatedBy: "'")
        let heightArrayTwo = heightArrayOne[1].components(separatedBy: "\"")
        
        print(heightArrayOne)
        print(heightArrayTwo)
        print(heightArrayOne[0])
        print(heightArrayTwo[0])
        
        let weightArray = weightText?.components(separatedBy: (" "))
        
        footLabel.text = heightArrayOne[0]
        inchLabel.text = heightArrayTwo[0]
        poundLabel.text = weightArray?[0]
        
        updateOutput()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
}


