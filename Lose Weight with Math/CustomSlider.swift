//
//  CustomSlider.swift
//  Lose Weight with Math
//
//  Created by Kaleb Cooper on 7/18/17.
//  Copyright © 2017 Kaleb Cooper. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSlider: UISlider {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var thumbImage: UIImage? {
        didSet{
            setThumbImage(thumbImage, for: .disabled)
        }
    }

}
