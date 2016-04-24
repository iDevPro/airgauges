//
//  SpeedView.swift
//  AviaGauges
//
//  Created by Pavel Subach on 18.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class SpeedView: GaugesView {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.title = "скорость"
        configure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.title = "скорость"
        configure()
    }
    
    func configure() {
        
        arrowHour = UIView(frame: CGRect(x: bounds.width/2, y: 0, width: 4, height: bounds.height/2))
        arrowHour?.backgroundColor = UIColor.greenColor()
        arrowHour?.layer.borderWidth = 1
        arrowHour?.layer.position = CGPointMake(bounds.width/2, bounds.height/2)
        arrowHour?.layer.anchorPoint = CGPointMake(0.5, 0.75)
        
        addSubview(arrowHour!)
        
        // Add subscription for data update
        DataHelper.sharedInstance.addObserver(self, forKeyPath: "indicators", options: NSKeyValueObservingOptions.Initial, context: nil)
        DataHelper.sharedInstance.addObserver(self, forKeyPath: "indicators", options: NSKeyValueObservingOptions.New, context: nil)
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
        
        drawText(rect, ctx: ctx!, x: CGRectGetMidX(rect), y: CGRectGetMidY(rect), radius: rad, sides: 9, color: UIColor.whiteColor())
    }
    
    
    override func drawText(rect:CGRect, ctx:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
        
        // Flip text co-ordinate space, see: http://blog.spacemanlabs.com/2011/08/quick-tip-drawing-core-text-right-side-up/
        CGContextTranslateCTM(ctx, 0.0, CGRectGetHeight(rect))
        CGContextScaleCTM(ctx, 1.0, -1.0)
        // dictates on how inset the ring of numbers will be
        let inset:CGFloat = radius/3.5
        // An adjustment of 270 degrees to position numbers correctly
        let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius-inset,adjustment:270)
        _ = CGPathCreateMutable()
        // see
        for p in points.enumerate() {
            if p.index > 0 {
                // Font name must be written exactly the same as the system stores it (some names are hyphenated, some aren't) and must exist on the user's device. Otherwise there will be a crash. (In real use checks and fallbacks would be created.) For a list of iOS 7 fonts see here: http://support.apple.com/en-us/ht5878
                let aFont = UIFont(name: "DamascusBold", size: radius/5)
                // create a dictionary of attributes to be applied to the string
                let attr:CFDictionaryRef = [NSFontAttributeName:aFont!,NSForegroundColorAttributeName:UIColor.whiteColor()]
                // create the attributed string
                let text: CFAttributedString?
                if p.index == sides {
                    text = CFAttributedStringCreate(nil, "", attr)
                } else {
                    text = CFAttributedStringCreate(nil, p.index.description+"0", attr)
                }
                // create the line of text
                let line = CTLineCreateWithAttributedString(text!)
                // retrieve the bounds of the text
                let bounds = CTLineGetBoundsWithOptions(line, CTLineBoundsOptions.UseOpticalBounds)
                // set the line width to stroke the text with
                CGContextSetLineWidth(ctx, 1.5)
                // set the drawing mode to stroke
                CGContextSetTextDrawingMode(ctx, CGTextDrawingMode.FillStroke)
                // Set text position and draw the line into the graphics context, text length and height is adjusted for
                let xn = p.element.x - bounds.width/2
                let yn = p.element.y - bounds.midY
                CGContextSetTextPosition(ctx, xn, yn)
                // the line of text is drawn - see https://developer.apple.com/library/ios/DOCUMENTATION/StringsTextFonts/Conceptual/CoreText_Programming/LayoutOperations/LayoutOperations.html
                // draw the line of text
                CTLineDraw(line, ctx)
            }
        }
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
            self.arrowHour?.transform = speedTransform
        }
    }
    
}
