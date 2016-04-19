//
//  DataHelper.swift
//  AviaGauges
//
//  Created by Pavel Subach on 17.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import Foundation

protocol DataHelperDelegate {
    func updateGauge(values: [String: Double])
}

class DataHelper {
    
    let indicators = NSURL(string: "http://127.0.0.1:8111/indicators")
    let stats = NSURL(string: "http://127.0.0.1:8111/stats")
    
    static let sharedInstance = DataHelper()
    
    var delegate:DataHelperDelegate?
    
    private init() {}
    
    func fetchIndicators() -> AnyObject {
        do {
            let data = try NSData(contentsOfURL: indicators!, options: .DataReadingUncached)
            do {
                var objects = [String: Double]()
                let json =  try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String: AnyObject]
                if ((json) != nil) {
                    for jsonKey in json!.keys {
                        if ((json![jsonKey]) != nil) {
                            objects[jsonKey] = json![jsonKey] as? Double
                        }
                    }
                    
                    delegate?.updateGauge(objects)
                }
                return objects
            }
        } catch {
            return "Error"
        }
    }
    
    
    
    func fetchStats() -> String {
        return stats!.absoluteString
    }
    
}
