//
//  SpeedView.swift
//  AviaGauges
//
//  Created by Pavel Subach on 18.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class AltView: UIView {
    var arrowMinute: UIView? = nil
    var arrowHour: UIView? = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = bounds.width/2
        layer.masksToBounds = true;
        
        let arrowCenter = UIView(frame: CGRect(x: -8, y: bounds.height/2 - 38, width: 20, height: 20))
        arrowCenter.layer.borderWidth = 1
        arrowCenter.layer.cornerRadius = 10;
        arrowCenter.layer.masksToBounds = true;
        arrowCenter.backgroundColor = UIColor.greenColor()
        
        arrowMinute = UIView(frame: CGRect(x: bounds.width/2, y: 0, width: 4, height: bounds.height/2))
        arrowMinute?.backgroundColor = UIColor.greenColor()
        arrowMinute?.layer.borderWidth = 1
        arrowMinute?.layer.position = CGPointMake(bounds.width/2, bounds.height/2)
        arrowMinute?.layer.anchorPoint = CGPointMake(0.5, 0.75)
        arrowMinute?.addSubview(arrowCenter)
        
        arrowHour = UIView(frame: CGRect(x: bounds.width/2, y: 0, width: 4, height: bounds.height/2))
        arrowHour?.backgroundColor = UIColor.redColor()
        arrowHour?.layer.borderWidth = 1
        arrowHour?.layer.position = CGPointMake(bounds.width/2, bounds.height/2)
        arrowHour?.layer.anchorPoint = CGPointMake(0.5, 0.75)
        arrowHour?.addSubview(arrowCenter)
        
        addSubview(arrowHour!)
        addSubview(arrowMinute!)
        
    }
    
    func setAlt(hour: Double, min: Double, altDevider: Double) {
        UIView.animateWithDuration(0.5) {
            let hourTransform = CGAffineTransformMakeRotation(CGFloat((hour * (360 * M_PI / 180)) / altDevider))
            let minTransform = CGAffineTransformMakeRotation(CGFloat((min * (360 * M_PI / 180)) % altDevider))
            

            self.arrowHour?.transform = hourTransform
            self.arrowMinute?.transform = minTransform
        }
    }
    
}
