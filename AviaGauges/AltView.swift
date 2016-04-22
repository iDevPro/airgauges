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

        arrowMinute = UIView(frame: CGRect(x: bounds.width/2, y: 0, width: 4, height: bounds.height/2))
        arrowMinute?.backgroundColor = UIColor.greenColor()
        arrowMinute?.layer.borderWidth = 1
        arrowMinute?.layer.position = CGPointMake(bounds.width/2, bounds.height/2)
        arrowMinute?.layer.anchorPoint = CGPointMake(0.5, 0.75)
        
        arrowHour = UIView(frame: CGRect(x: bounds.width/2, y: 0, width: 4, height: bounds.height/2))
        arrowHour?.backgroundColor = UIColor.redColor()
        arrowHour?.layer.borderWidth = 1
        arrowHour?.layer.position = CGPointMake(bounds.width/2, bounds.height/2)
        arrowHour?.layer.anchorPoint = CGPointMake(0.5, 0.75)
        
        addSubview(arrowHour!)
        addSubview(arrowMinute!)
        
        // Add subscription for data update
        DataHelper.sharedInstance.addObserver(self, forKeyPath: "indicators", options: NSKeyValueObservingOptions.Initial, context: nil)
        DataHelper.sharedInstance.addObserver(self, forKeyPath: "indicators", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let helper = object as! DataHelper
        let gaugesData = helper.indicators
        
        if (gaugesData.keys.contains("altitude_hour") && gaugesData.keys.contains("altitude_min")) {
            let altHour = gaugesData["altitude_hour"]
            let altMin = gaugesData["altitude_min"]
            self.setAlt(altHour!, min: altMin!, altDevider: 1000)
        } else {
            self.setAlt(0, min: 0, altDevider: 1000)
        }
        
    }
    
    deinit {
        DataHelper.sharedInstance.removeObserver(self, forKeyPath: "indicators")
    }
    
    func setAlt(hour: Double, min: Double, altDevider: Double) {
        UIView.animateWithDuration(0.5) {
            let degree = 360 * M_PI / 180
            let hourTransform = CGAffineTransformMakeRotation(CGFloat((hour * degree) / (10 * altDevider)))
            let minTransform = CGAffineTransformMakeRotation(CGFloat((min * degree) / altDevider))
            
            self.arrowHour?.transform = hourTransform
            self.arrowMinute?.transform = minTransform
        }
    }
    
}
