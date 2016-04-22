//
//  RpmView.swift
//  AviaGauges
//
//  Created by Pavel Subach on 19.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class RpmView: AltView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let helper = object as! DataHelper
        let gaugesData = helper.indicators
        
        if (gaugesData.keys.contains("rpm_hour") && gaugesData.keys.contains("rpm_min")) {
            let rpmHour = gaugesData["rpm_hour"]
            let rpmMin = gaugesData["rpm_min"]
            self.setRpm(rpmHour!, min: rpmMin!, rpmDevider: 1000)
        } else {
            self.setRpm(0, min: 0, rpmDevider: 1000)
        }
    }
    
    func setRpm(hour: Double, min: Double, rpmDevider: Double) {
        UIView.animateWithDuration(0.5) {
            let degree = 360 * M_PI / 180
            let hourTransform = CGAffineTransformMakeRotation(CGFloat((hour * degree) / (10 * rpmDevider)))
            let minTransform = CGAffineTransformMakeRotation(CGFloat((min * degree) / rpmDevider))
            
            self.arrowHour?.transform = hourTransform
            self.arrowMinute?.transform = minTransform
        }
    }
    
}

