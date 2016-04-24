//
//  GaugesView.swift
//  AviaGauges
//
//  Created by Pavel Subach on 24.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class GaugesView: UIView {
    
    var title = ""
    var arrowMinute: UIView? = nil
    var arrowHour: UIView? = nil
    
    func degree2radian(a:CGFloat)->CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        preConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        preConfigure()
    }
    
    func preConfigure() {
        layer.cornerRadius = bounds.width/2
        layer.masksToBounds = true;
        self.backgroundColor = UIColor.darkGrayColor()
    }
    
    func circleCircumferencePoints(sides:Int,x:CGFloat,y:CGFloat,radius:CGFloat,adjustment:CGFloat=0)->[CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i -= 1;
        }
        return points
    }
    func secondMarkers(ctx:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
        // retrieve points
        let points = circleCircumferencePoints(sides,x: x,y: y,radius: radius)
        // create path
        let path = CGPathCreateMutable()
        // determine length of marker as a fraction of the total radius
        var divider:CGFloat = 1/16
        
        for p in points.enumerate() {
            if p.index % 5 == 0 {
                divider = 1/8
            }
            else {
                divider = 1/16
            }
            
            let xn = p.element.x + divider*(x-p.element.x)
            let yn = p.element.y + divider*(y-p.element.y)
            // build path
            CGPathMoveToPoint(path, nil, p.element.x, p.element.y)
            CGPathAddLineToPoint(path, nil, xn, yn)
            CGPathCloseSubpath(path)
            // add path to context
            CGContextAddPath(ctx, path)
        }
        // set path color
        let cgcolor = color.CGColor
        CGContextSetStrokeColorWithColor(ctx,cgcolor)
        CGContextSetLineWidth(ctx, 3.0)
        CGContextStrokePath(ctx)
        
    }
    
    func drawText(rect:CGRect, ctx:CGContextRef, x:CGFloat, y:CGFloat, radius:CGFloat, sides:Int, color:UIColor) {
        
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
                let text = CFAttributedStringCreate(nil, p.index.description, attr)
                // create the line of text
                let line = CTLineCreateWithAttributedString(text)
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

}