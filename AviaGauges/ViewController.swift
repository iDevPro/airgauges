//
//  ViewController.swift
//  AviaGauges
//
//  Created by Pavel Subach on 17.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, DataHelperDelegate {

    @IBOutlet weak var collectionView: UICollectionView!

    var gaugesData: [String: Double]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DataHelper.sharedInstance.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshData(sender: UIButton) {
        DataHelper.sharedInstance.fetchIndicators()
    }

    func updateGauge(values: [String : Double]) {
        
        
        if (values["speed"]) != nil {
            
//            .setSpeed(values["speed"]!, max: 155.508)
        }
        
        if (values["altitude_hour"]) != nil && (values["altitude_min"]) != nil {
//            self.altView.setAlt(values["altitude_hour"]!, min: values["altitude_min"]!, altDevider: 1000)
        }
        
        self.gaugesData = values
        
        self.collectionView.reloadData()
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cell updated")
    
        
        if (self.gaugesData) != nil {
            
        }
        
        if indexPath == NSIndexPath(forItem: 0, inSection: 0) {
            let speedCell = collectionView.dequeueReusableCellWithReuseIdentifier("SpeedView", forIndexPath: indexPath)
            let speedView = speedCell.viewWithTag(100) as! SpeedView
            speedView.setSpeed(self.gaugesData["speed"], max: 155.508)
            return speedCell
        }
        
        let altCell = collectionView.dequeueReusableCellWithReuseIdentifier("AltView", forIndexPath: indexPath)
            let altView = altCell.viewWithTag(100) as! AltView
            altView.setAlt(self.gaugesData["altitude_hour"], min: self.gaugesData["altitude_min"], altDevider: 1000)
        return altCell
    
    }
    
    
}

