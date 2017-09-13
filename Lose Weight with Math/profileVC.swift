//
//  profileVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/17/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class profileVC: UIViewController {
    
    
    @IBOutlet weak var firstNameTest: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Logs] = []
    
    @IBAction func viewTutorial(_ sender: Any) {
        //UserDefaults.standard.set(true, forKey: "launchedBefore")
        self.performSegue(withIdentifier: "viewSetup", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        
//        do {
//            tasks = try context.fetch(Logs.fetchRequest())
//        } catch {
//            print("Fetching Failed")
//        }
//        
//        let task = tasks[0]
//        
//        if let curWeight = task.weight {
//            firstNameTest.text = curWeight
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
}
