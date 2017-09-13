//
//  BarcodeReaderVC.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 8/6/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox


class BarcodeReaderVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate{
    
    
    var nameArray: Array<String> = []
    var ndbnoArray: Array<String> = []
    var emoji: String!


    var captureDevice:AVCaptureDevice?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var captureSession:AVCaptureSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white

        //self.loadData()
    }
    
    func loadData(){
        
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Scanner"
        view.backgroundColor = .white
        
        captureDevice = AVCaptureDevice.default(for: .video)
        // Check if captureDevice returns a value and unwrap it
        if let captureDevice = captureDevice {
            
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                
                captureSession = AVCaptureSession()
                guard let captureSession = captureSession else { return }
                captureSession.addInput(input)
                
                let captureMetadataOutput = AVCaptureMetadataOutput()
                captureSession.addOutput(captureMetadataOutput)
                
                captureMetadataOutput.setMetadataObjectsDelegate(self, queue: .main)
                captureMetadataOutput.metadataObjectTypes = [.code128, .qr, .ean13,  .ean8, .code39, .upce] //AVMetadataObject.ObjectType
                
                captureSession.startRunning()
                
                videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                videoPreviewLayer?.videoGravity = .resizeAspectFill
                videoPreviewLayer?.frame = view.layer.bounds
                view.layer.addSublayer(videoPreviewLayer!)
                
            } catch {
                print("Error Device Input")
            }
            
        }
        
        view.addSubview(codeLabel)
        codeLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        codeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        codeLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        codeLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let codeLabel:UILabel = {
        let codeLabel = UILabel()
        codeLabel.backgroundColor = .white
        codeLabel.translatesAutoresizingMaskIntoConstraints = false
        return codeLabel
    }()
    
    let codeFrame:UIView = {
        let codeFrame = UIView()
        codeFrame.layer.borderColor = UIColor.green.cgColor
        codeFrame.layer.borderWidth = 2
        codeFrame.frame = CGRect.zero
        codeFrame.translatesAutoresizingMaskIntoConstraints = false
        return codeFrame
    }()
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count == 0 {
            //print("No Input Detected")
            codeFrame.frame = CGRect.zero
            codeLabel.text = "No Data"
            return
        }
        
        let metadataObject = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        guard let stringCodeValue = metadataObject.stringValue else { return }
        
        view.addSubview(codeFrame)
        
        guard let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObject) else { return }
        codeFrame.frame = barcodeObject.bounds
        codeLabel.text = stringCodeValue
        
        // Play system sound with custom mp3 file
        if let customSoundUrl = Bundle.main.url(forResource: "beep", withExtension: "mp3") {
            var customSoundId: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(customSoundUrl as CFURL, &customSoundId)
            //let systemSoundId: SystemSoundID = 1016  // to play apple's built in sound, no need for upper 3 lines
            
            AudioServicesAddSystemSoundCompletion(customSoundId, nil, nil, { (customSoundId, _) -> Void in
                AudioServicesDisposeSystemSoundID(customSoundId)
            }, nil)
            
            AudioServicesPlaySystemSound(customSoundId)
        }
        
        // Stop capturing and hence stop executing metadataOutput function over and over again
        captureSession?.stopRunning()
        
        print(stringCodeValue)
        
        var stringCode = stringCodeValue
        
        stringCode.remove(at: stringCode.startIndex)
        
        print(stringCode)
        
        // Call the function which performs navigation and pass the code string value we just detected
        //displayDetailsViewController(scannedCode: stringCodeValue)
        
        if (stringCodeValue.count < 10){
           getResults(upc: stringCodeValue)
        }
        else{
            getResults(upc: stringCode)
            
            let when = DispatchTime.now() + 0.35 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                if(self.nameArray.isEmpty){
                    stringCode.insert("0", at: stringCode.startIndex)
                    stringCode.insert("0", at: stringCode.startIndex)
                    self.getResults(upc: stringCode)
                }
            }
        }
            let when = DispatchTime.now() + 0.75 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                
                if(self.nameArray.isEmpty){
                    let alert = UIAlertController(title: "Error", message: "Code is unable to be read", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    self.loadData()
                }
                else{
                    print("Performing Segue")
                    self.performSegue(withIdentifier: "codeFoodDetails", sender: self)
                    
                }
                
                
            }
        
    }
    
    //-----------------------------------------------------------------------
    
    
    func getResults(upc: String) {
        
        
        let apiKey: String = "MqE5OpBHdNfIdzxFjz2PCgDAU2Bxf7eIHxTOb1BU"
        let searchString: String = upc
        let escapedSearch: String = searchString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) as String!
        let numResults = 1
        
        //let when = DispatchTime.now() + 0.5
        DispatchQueue.main.async {
            let jsonUrlString = "https://api.nal.usda.gov/ndb/search/?format=json&q=\(escapedSearch)&sort=r&max=\(numResults)&offset=0&api_key=\(apiKey)"
            guard let url = URL(string: jsonUrlString) else { return }
            
            self.nameArray.removeAll()
            self.ndbnoArray.removeAll()
            
            
            
            URLSession.shared.dataTask(with: url) { (data, response, err) in
                
                guard let data = data else {
                    return
                }
                
                let dataAsString = String(data: data, encoding: .utf8)
                
                do {
                    
                    let data = dataAsString?.data(using: .utf8)!
                    if let json = try? JSONSerialization.jsonObject(with: data!) as? [String:Any] {
                        
                        
                        if let list = json?["list"] as? [String:Any] {
                            if let itemArray = list["item"] as? NSArray {
                                for item in itemArray {
                                    if let itemDict = item as? NSDictionary {
                                        if let name = itemDict.value(forKey: "name"){
                                            
                                            
                                            let nameString = name as! String
                                            let token = nameString.components(separatedBy: ", UPC:")
                                            let tokenTwo = token[0].components(separatedBy: ", GTIN:")
                                            
                                            //print(token[0])
                                            
                                            self.nameArray.append(tokenTwo[0])
                                            self.emoji = self.getEmoji(title: tokenTwo[0])
                                            
                                            print(self.nameArray)
                                            print(self.emoji)
                                            
                                            
                                            
                                            
                                        }
                                        if let ndbno = itemDict.value(forKey: "ndbno"){
                                            
                                            self.ndbnoArray.append(ndbno as! String)
                                            print(self.ndbnoArray)
                                            
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                            }
                        }
                    }
                } catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                }
                }.resume()
        }
    }
    
    
    func getEmoji(title: String) -> String{
        
        if title.localizedCaseInsensitiveContains("apple"){
            return "🍎"
        }
        else if title.localizedCaseInsensitiveContains("pear"){
            return "🍐"
        }
        else if title.localizedCaseInsensitiveContains("orange"){
            return "🍊"
        }
        else if title.localizedCaseInsensitiveContains("tangerine"){
            return "🍊"
        }
        else if title.localizedCaseInsensitiveContains("banana"){
            return "🍌"
        }
        else if title.localizedCaseInsensitiveContains("watermelon"){
            return "🍉"
        }
        else if title.localizedCaseInsensitiveContains("grape"){
            return "🍇"
        }
        else if title.localizedCaseInsensitiveContains("strawberry"){
            return "🍓"
        }
        else if title.localizedCaseInsensitiveContains("melon"){
            return "🍈"
        }
        else if title.localizedCaseInsensitiveContains("cherry"){
            return "🍒"
        }
        else if title.localizedCaseInsensitiveContains("cherries"){
            return "🍒"
        }
        else if title.localizedCaseInsensitiveContains("peach"){
            return "🍑"
        }
        else if title.localizedCaseInsensitiveContains("pineapple"){
            return "🍍"
        }
        else if title.localizedCaseInsensitiveContains("kiwi"){
            return "🥝"
        }
        else if title.localizedCaseInsensitiveContains("avocado"){
            return "🥑"
        }
        else if title.localizedCaseInsensitiveContains("tomato"){
            return "🍅"
        }
        else if title.localizedCaseInsensitiveContains("eggplant"){
            return "🍆"
        }
        else if title.localizedCaseInsensitiveContains("cucumber"){
            return "🥒"
        }
        else if title.localizedCaseInsensitiveContains("carrot"){
            return "🥕"
        }
        else if title.localizedCaseInsensitiveContains("peanut"){
            return "🥜"
        }
        else if title.localizedCaseInsensitiveContains("honey"){
            return "🍯"
        }
        else if title.localizedCaseInsensitiveContains("croissant"){
            return "🥐"
        }
        else if title.localizedCaseInsensitiveContains("bread"){
            return "🍞"
        }
        else if title.localizedCaseInsensitiveContains("baguette"){
            return "🥖"
        }
        else if title.localizedCaseInsensitiveContains("egg"){
            return "🥚"
        }
        else if title.localizedCaseInsensitiveContains("bacon"){
            return "🥓"
        }
        else if title.localizedCaseInsensitiveContains("pancake"){
            return "🥞"
        }
        else if title.localizedCaseInsensitiveContains("shrimp"){
            return "🍤"
        }
        else if title.localizedCaseInsensitiveContains("leg"){
            return "🍗"
        }
        else if title.localizedCaseInsensitiveContains("bone"){
            return "🍖"
        }
        else if title.localizedCaseInsensitiveContains("pizza"){
            return "🍕"
        }
        else if title.localizedCaseInsensitiveContains("pepper"){
            return "🌶"
        }
        else if title.localizedCaseInsensitiveContains("dog"){
            return "🌭"
        }
        else if title.localizedCaseInsensitiveContains("spaghetti"){
            return "🍝"
        }
        else if title.localizedCaseInsensitiveContains("pasta"){
            return "🍜"
        }
        else if title.localizedCaseInsensitiveContains("macaroni"){
            return "🍜"
        }
        else if title.localizedCaseInsensitiveContains("fetucinni"){
            return "🍜"
        }
        else if title.localizedCaseInsensitiveContains("burger"){
            return "🍔"
        }
        else if title.localizedCaseInsensitiveContains("mac"){
            return "🍔"
        }
        else if title.localizedCaseInsensitiveContains("nugget"){
            return "🐔"
        }
        else if title.localizedCaseInsensitiveContains("fries"){
            return "🍟"
        }
        else if title.localizedCaseInsensitiveContains("fry"){
            return "🍟"
        }
        else if title.localizedCaseInsensitiveContains("potato"){
            return "🥔"
        }
        else if title.localizedCaseInsensitiveContains("sandwich"){
            return "🥙"
        }
        else if title.localizedCaseInsensitiveContains("burrito"){
            return "🌯"
        }
        else if title.localizedCaseInsensitiveContains("taco"){
            return "🌮"
        }
        else if title.localizedCaseInsensitiveContains("salad"){
            return "🥗"
        }
        else if title.localizedCaseInsensitiveContains("dress"){
            return "🥗"
        }
        else if title.localizedCaseInsensitiveContains("sushi"){
            return "🍣"
        }
        else if title.localizedCaseInsensitiveContains("curry"){
            return "🍛"
        }
        else if title.localizedCaseInsensitiveContains("rice"){
            return "🍚"
        }
        else if title.localizedCaseInsensitiveContains("rice ball"){
            return "🍙"
        }
        else if title.localizedCaseInsensitiveContains("ice"){
            return "🍧"
        }
        else if title.localizedCaseInsensitiveContains("ice cream"){
            return "🍦"
        }
        else if title.localizedCaseInsensitiveContains("cream"){
            return "🍦"
        }
        else if title.localizedCaseInsensitiveContains("cake"){
            return "🍰"
        }
        else if title.localizedCaseInsensitiveContains("lemon"){
            return "🍋"
        }
        else if title.localizedCaseInsensitiveContains("lollipop"){
            return "🍭"
        }
        else if title.localizedCaseInsensitiveContains("popcorn"){
            return "🍿"
        }
        else if title.localizedCaseInsensitiveContains("corn"){
            return "🌽"
        }
        else if title.localizedCaseInsensitiveContains("donut"){
            return "🍩"
        }
        else if title.localizedCaseInsensitiveContains("chocolate"){
            return "🍫"
        }
        else if title.localizedCaseInsensitiveContains("candy"){
            return "🍬"
        }
        else if title.localizedCaseInsensitiveContains("cookie"){
            return "🍪"
        }
        else if title.localizedCaseInsensitiveContains("milk"){
            return "🥛"
        }
        else if title.localizedCaseInsensitiveContains("coffee"){
            return "☕️"
        }
        else if title.localizedCaseInsensitiveContains("tea"){
            return "🍵"
        }
        else if title.localizedCaseInsensitiveContains("beer"){
            return "🍺"
        }
        else if title.localizedCaseInsensitiveContains("wine"){
            return "🍷"
        }
        else if title.localizedCaseInsensitiveContains("liquor"){
            return "🥃"
        }
        else if title.localizedCaseInsensitiveContains("cocktail"){
            return "🍸"
        }
        else if title.localizedCaseInsensitiveContains("drink"){
            return "🍹"
        }
        else if title.localizedCaseInsensitiveContains("cheese"){
            return "🧀"
        }
        else if title.localizedCaseInsensitiveContains("fish"){
            return "🐟"
        }
        else if title.localizedCaseInsensitiveContains("crab"){
            return "🦀"
        }
        else if title.localizedCaseInsensitiveContains("mushroom"){
            return "🍄"
        }
        else if title.localizedCaseInsensitiveContains("turkey"){
            return "🦃"
        }
        else if title.localizedCaseInsensitiveContains("chicken"){
            return "🐔"
        }
        else if title.localizedCaseInsensitiveContains("pork"){
            return "🐖"
        }
        else if title.localizedCaseInsensitiveContains("beef"){
            return "🐄"
        }
        else if title.localizedCaseInsensitiveContains("steak"){
            return "🐄"
        }
        else if title.localizedCaseInsensitiveContains("venison"){
            return "🦌"
        }
        else if title.localizedCaseInsensitiveContains("mutton"){
            return "🐑"
        }
        else if title.localizedCaseInsensitiveContains("lamb"){
            return "🐑"
        }
        else if title.localizedCaseInsensitiveContains("squid"){
            return "🦑"
        }
        else if title.localizedCaseInsensitiveContains("duck"){
            return "🦆"
        }
        else if title.localizedCaseInsensitiveContains("bird"){
            return "🐦"
        }
        else if title.localizedCaseInsensitiveContains("cod"){
            return "🐟"
        }
        else if title.localizedCaseInsensitiveContains("salmon"){
            return "🐟"
        }
        else if title.localizedCaseInsensitiveContains("flounder"){
            return "🐟"
        }
        else if title.localizedCaseInsensitiveContains("tilapia"){
            return "🐟"
        }
        else if title.localizedCaseInsensitiveContains("icing"){
            return "🍰"
        }
        else if title.localizedCaseInsensitiveContains("sugar"){
            return "🍬"
        }
        else{
            return "🍽"
        }
        
        
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "codeFoodDetails") {
            
            // initialize new view controller and cast it as your view controller
            let viewController = segue.destination as! FoodDetailsVC
            // your new view controller should have property that will store passed value
            
            if(nameArray.isEmpty){
                let alert = UIAlertController(title: "Error", message: "Code is unable to be read", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
            else{
                viewController.food = nameArray[0]
                viewController.ndbno = ndbnoArray[0]
                viewController.emoji = emoji
            }
            
        }
    }
    
    
}

