//
//  ClockView.swift
//  AviaGauges
//
//  Created by Pavel Subach on 21.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class ClockView: AltView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let helper = object as! DataHelper
        let gaugesData = helper.indicators
        
        if (gaugesData.keys.contains("clock_hour") && gaugesData.keys.contains("clock_min")) {
            let clockHour = gaugesData["clock_hour"]
            let clockMin = gaugesData["clock_min"]
            self.setTime(clockHour!, min: clockMin!)
        }
    }
    
    func setTime(hour: Double, min: Double) {
        UIView.animateWithDuration(0.5) {
            let degree = 360 * M_PI / 180
            let hourTransform = CGAffineTransformMakeRotation(CGFloat((hour * degree) / 12))
            let minTransform = CGAffineTransformMakeRotation(CGFloat((min * degree) / 60))
            
            self.arrowHour?.transform = hourTransform
            self.arrowMinute?.transform = minTransform
        }
    }
    
}