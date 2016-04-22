//
//  SpeedView.swift
//  AviaGauges
//
//  Created by Pavel Subach on 18.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class SpeedView: UIView {
    var arrow: UIView? = nil
    var zeroValue: CGFloat = CGFloat(M_PI)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        arrow = UIView(frame: CGRect(x: bounds.width/2, y: 0, width: 4, height: bounds.height/2))
        arrow?.backgroundColor = UIColor.greenColor()
        arrow?.layer.borderWidth = 1
        arrow?.layer.position = CGPointMake(bounds.width/2, bounds.height/2)
        arrow?.layer.anchorPoint = CGPointMake(0.5, 0.75)
        layer.cornerRadius = bounds.width/2
        layer.masksToBounds = true;
        
        addSubview(arrow!)
        
        // Add subscription for data update
        DataHelper.sharedInstance.addObserver(self, forKeyPath: "indicators", options: NSKeyValueObservingOptions.Initial, context: nil)
        DataHelper.sharedInstance.addObserver(self, forKeyPath: "indicators", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let helper = object as! DataHelper
        let gaugesData = helper.indicators
    
        if (gaugesData.keys.contains("speed")) {
            let speed = gaugesData["speed"]
            self.setSpeed(speed!, max: 155.508)
        } else {
            self.setSpeed(0, max: 155.508)
        }
        
    }
    
    func setSpeed(speed: Double, max: Double) {
        UIView.animateWithDuration(0.5) {
            let currentSpeed = (speed > max) ? max : speed
            let speedTransform = CGAffineTransformMakeRotation(CGFloat((currentSpeed * (320 * M_PI / 180)) / max))
            self.arrow?.transform = speedTransform
        }
    }
    
}
