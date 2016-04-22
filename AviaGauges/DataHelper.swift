//
//  DataHelper.swift
//  AviaGauges
//
//  Created by Pavel Subach on 17.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import Foundation

class DataHelper: NSObject {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    dynamic var indicators = [String: Double]()
    dynamic var stats =  [String: Double]()

    var timer: NSTimer?
    
    static let sharedInstance = DataHelper()
    
    private override init() {
        
        // Default ip 127.0.0.1
        if (defaults.URLForKey("ipWarthunder") == nil) {
            defaults.setURL(NSURL(string: "http://127.0.0.1:8111"), forKey: "ipWarthunder")
        }
        
    }
    
    @objc private func update() {
        let indicators = defaults.URLForKey("ipWarthunder")?.URLByAppendingPathComponent("indicators")
        do {
            let dataIndicators = try NSData(contentsOfURL: indicators!, options: .DataReadingUncached)
            do {
                var objects = [String: Double]()
                let json = try NSJSONSerialization.JSONObjectWithData(dataIndicators, options: .MutableContainers) as? [String: AnyObject]
                if (json != nil) {
                    for jsonKey in json!.keys {
                        if json![jsonKey] != nil {
                            objects[jsonKey] = json![jsonKey] as? Double
                        }
                    }
                }
                self.indicators = objects
            }
        } catch {
            return self.indicators = ["error":-1]
        }
    }
    

    func start() {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(DataHelper.update), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
//    var indicators: [String: Double] {
//        get {
//            
//        }
//    }
//    
//    var stats: String {
//        get {
//            let stats = defaults.URLForKey("ipWarthunder")?.URLByAppendingPathComponent("stats")
//            return stats!.absoluteString
//        }
//    }

    func checkStatus(host: String) -> Bool {
        var status = false
        var wtHost = defaults.URLForKey("ipWarthunder")
        if (host != "") {
            wtHost = NSURL(string:"http://\(host):8111")
        }
        do {
            let data = try NSData(contentsOfURL: wtHost!, options: .DataReadingUncached)
            if data.length > 0 {
                status = true
            }
        } catch {
            return status
        }
        return status
    }
    
}
