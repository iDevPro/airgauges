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
        title = "часы"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        title = "часы"
    }
    
    override func drawRect(rect:CGRect) {
        // obtain context
        let ctx = UIGraphicsGetCurrentContext()
        
        // decide on radius
        let rad = CGRectGetWidth(rect)/2
        
        let endAngle = CGFloat(2*M_PI)
        
        // add the circle to the context
        CGContextAddArc(ctx, CGRectGetMidX(rect), CGRectGetMidY(rect), rad, 0, endAngle, 1)
        
        // set fill color
        CGContextSetFillColorWithColor(ctx,UIColor.grayColor().CGColor)
        
        // set stroke color
        CGContextSetStrokeColorWithColor(ctx,UIColor.whiteColor().CGColor)
        
        // set line width
        CGContextSetLineWidth(ctx, 4.0)
        // use to fill and stroke path (see http://stackoverflow.com/questions/13526046/cant-stroke-path-after-filling-it )
        
        // draw the path
        CGContextDrawPath(ctx,  CGPathDrawingMode.FillStroke);
        
        secondMarkers(ctx!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 60, color: UIColor.whiteColor())
        
        drawText(rect, ctx: ctx!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 12, color: UIColor.whiteColor())
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