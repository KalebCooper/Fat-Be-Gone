//
//  MoreVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/26/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class MoreVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var window: UIWindow?
    var imagePicker = UIImagePickerController()
    
    
    //Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    //Actions

    @IBAction func addProfilePhoto(_ sender: Any) {
        
        let image = UIImagePickerController()
        image.delegate = self
        
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        image.allowsEditing = false
        
        self.present(image, animated: true){
            //After it is complete
        }
        
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
//            print("Button capture")
//
//
//
//            self.present(imagePicker, animated: true, completion: nil)
//        }
    }
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [UserProfile] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileVC.dismissKeyboard))
        //view.addGestureRecognizer(tap)
        self.imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary;
        imagePicker.allowsEditing = false
        
        let defaults = UserDefaults.standard
        
        let firstNameText: String! = defaults.string(forKey: "FirstName")
        let lastNameText: String! = defaults.string(forKey: "LastName")
        
        
        nameLabel.text = "\(firstNameText!) \(lastNameText!)"
        
        
        if let imageData = defaults.data(forKey: "ProfilePicture"){
            let profile = UIImage(data: imageData)
            imageView.contentMode = .scaleAspectFit
            imageView.image = profile
            buttonOutlet.setTitle("", for: .normal)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.performSegue(withIdentifier: "MyProfile", sender: self)
            print("MyProfile")
        }
        if indexPath.row == 2 {
            print("2")
            self.performSegue(withIdentifier: "MyGoals", sender: self)
        }
//        if indexPath.row == 3 {
//            print("3")
//            self.performSegue(withIdentifier: "Statistics", sender: self)
//        }
        if indexPath.row == 3 {
            print("4")
            self.performSegue(withIdentifier: "Settings", sender: self)
        }
        if indexPath.row == 4 {
            print("5")
            self.performSegue(withIdentifier: "AboutApp", sender: self)
        }
        
    }
    
    
    // MARK: - UIImagePickerControllerDelegate Methods
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = pickedImage
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            buttonOutlet.setTitle("", for: .normal)
            
            let imageData = UIImagePNGRepresentation(image)
            
            let defaults = UserDefaults.standard
            
            defaults.set(imageData, forKey: "ProfilePicture")
            
        }
        else{
            //Error Message
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        print("Image picker cancelled")
    }


    
    
   
}
