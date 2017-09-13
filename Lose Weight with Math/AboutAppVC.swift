//
//  AboutAppVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/26/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AboutAppVC: UITableViewController {
    

    @IBAction func reviewTapped(_ sender: Any) {
        
        let url = URL(string: "itms-apps://itunes.apple.com/us/app/apple-store/1271295817?mt=8")!
            
        UIApplication.shared.openURL(url)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        // Do any additional setup after loading the view, typically from a nib.
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
