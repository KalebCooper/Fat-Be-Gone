//
//  AppDelegate.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/9/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import LocalAuthentication
import WatchConnectivity
import HealthKit

protocol HavingHealthStore: class {
    var healthStore: HKHealthStore? {get set}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WCSessionDelegate {
    
    
    //Apple Watch Code/Delegates
    var session: WCSession?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //Fill in
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //Fill in
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //Fill in
    }
    
    //Variables
    var window: UIWindow?

    var tabDestination: Int! = 2
    
    private var healthStore: HKHealthStore!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Get Watch App Data from iOS UserDefaults
        let defaults = UserDefaults.standard
        
        let goalText = defaults.string(forKey: "goalCalories")
        let foodText = defaults.string(forKey: "foodCalories")
        let exerciseText = defaults.string(forKey: "exerciseCalories")
        let remainingText = defaults.string(forKey: "remainingCalories")
        
        //Today View Setup
//        let sharedDefaults = UserDefaults(suiteName: "group.kalebcooper.lose-weight")!
//        sharedDefaults.set(goalText, forKey: "goalCalories")
//        sharedDefaults.set(foodText, forKey: "foodCalories")
//        sharedDefaults.set(exerciseText, forKey: "exerciseCalories")
//        sharedDefaults.set(remainingText, forKey: "remainingCalories")
        
        
        //Watch App Code
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
            
        let message = ["goalMessage":goalText, "foodMessage":foodText, "exerciseMessage":exerciseText, "remainingMessage":remainingText]
        print(message)
            
        session?.sendMessage(message, replyHandler: nil, errorHandler: nil)
        
        
        let swiftColor = UIColor(red: 205/255, green: 205/255, blue: 205/250, alpha: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: swiftColor], for: .normal)

        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        
        if launchedBefore {
            
            openAppAtTab()
            
            
            
            
        }
        else {
            print("First launch.")
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "FirstTime")
            self.window?.makeKeyAndVisible()
            

        }
        
        //HealthKit
        self.healthStore = HKHealthStore()
        
        
        return true
    }
    func processApplicationContext() {
        if let iPhoneContext = session?.applicationContext as? [String : Bool] {
            if iPhoneContext["switchStatus"] == true {
                //theSwitch.on = true
            } else {
                //theSwitch.on = false
            }
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //Get Watch App Data from iOS UserDefaults
        let defaults = UserDefaults.standard
        
        let goalText = defaults.string(forKey: "goalCalories")
        let foodText = defaults.string(forKey: "foodCalories")
        let exerciseText = defaults.string(forKey: "exerciseCalories")
        let remainingText = defaults.string(forKey: "remainingCalories")
        
        
        //Watch App Code
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        
        let message = ["goalMessage":goalText, "foodMessage":foodText, "exerciseMessage":exerciseText, "remainingMessage":remainingText]
        print(message)
        
        session?.sendMessage(message, replyHandler: nil, errorHandler: nil)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        //Get Watch App Data from iOS UserDefaults
        let defaults = UserDefaults.standard
        
        let goalText = defaults.string(forKey: "goalCalories")
        let foodText = defaults.string(forKey: "foodCalories")
        let exerciseText = defaults.string(forKey: "exerciseCalories")
        let remainingText = defaults.string(forKey: "remainingCalories")
        
        
        //Watch App Code
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
        }
        
        let message = ["goalMessage":goalText, "foodMessage":foodText, "exerciseMessage":exerciseText, "remainingMessage":remainingText]
        print(message)
        
        session?.sendMessage(message, replyHandler: nil, errorHandler: nil)
        
        tabDestination = 2
        self.saveContext()
    }
    
    func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool {
        return true
    }
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    
    // MARK: - Quick Actions
    
    //Everytime a user uses a uses a quick action, this code runs
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if shortcutItem.type == "com.kalebcooper.Lose-Weight-With-Math.Log-Weight"{
            //Go to Weight Log View
            tabDestination = 0
            openAppAtTab()
            
        }
        else if shortcutItem.type == "com.kalebcooper.Lose-Weight-With-Math.Add-Meal"{
            //Go to Weight Log View
            tabDestination = 2
            openAppAtTab()
            
        }
        else if shortcutItem.type == "com.kalebcooper.Lose-Weight-With-Math.Search-Food"{
            //Go to Weight Log View
            tabDestination = 3
            openAppAtTab()
            
        }
        else if shortcutItem.type == "com.kalebcooper.Lose-Weight-With-Math.Calculate-BMI"{
            tabDestination = 1
            openAppAtTab()
            
        }
    }

    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "weight")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Function for TouchID authentication
    
    func openAppAtTab() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let touchIDEnabled = UserDefaults.standard.bool(forKey: "TouchID")
        
        //Check for TouchID true/false value
        if touchIDEnabled{
            let context:LAContext = LAContext()
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil){
                context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Please scan your finger to log in.", reply: { (wasSuccessful, error) in
                    if wasSuccessful{
                        
                        OperationQueue.main.addOperation({ () -> Void in
                            print("TouchID authenticated.")
                            
                            print("Has launched before.")
                            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "InitialView")
                            self.window?.makeKeyAndVisible()

                            //Override point for customization after application launch.
                            let myTabBar = self.window?.rootViewController as! UITabBarController // Getting Tab Bar
                            myTabBar.selectedIndex = self.tabDestination //Selecting tab here
                        })
                        
                        
                        
                    }
                    else{
                        print("TouchID not authenticated.")
                    }
                })
            }
        }
        else{
            print("Has launched before.")
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "InitialView")
            self.window?.makeKeyAndVisible()
            
            
            
            //Override point for customization after application launch.
            let myTabBar = self.window?.rootViewController as! UITabBarController // Getting Tab Bar
            myTabBar.selectedIndex = self.tabDestination //Selecting tab here
        }
        
    }
    
    func applicationShouldRequestHealthAuthorization(_ application: UIApplication) {
        healthStore.handleAuthorizationForExtension { success, error in
        }
    }
    


}

