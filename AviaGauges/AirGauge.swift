//
//  ViewController.swift
//  AviaGauges
//
//  Created by Pavel Subach on 17.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class AirGauge: UICollectionViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func refreshData(sender: UIButton) {
        DataHelper.sharedInstance.start()
    }
    
    @IBAction func stopUpdate(sender: UIButton) {
        DataHelper.sharedInstance.stop()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeaderView", forIndexPath: indexPath)
        return headerView
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        print("cell updated")
    
        if indexPath == NSIndexPath(forItem: 0, inSection: 0) {
            let speedCell = collectionView.dequeueReusableCellWithReuseIdentifier("SpeedView", forIndexPath: indexPath)
            return speedCell
        }
        
        if indexPath == NSIndexPath(forItem: 1, inSection: 0) {
            let altCell = collectionView.dequeueReusableCellWithReuseIdentifier("AltView", forIndexPath: indexPath)
            return altCell
        }
        
        if indexPath == NSIndexPath(forItem: 2, inSection: 0) {
            let rpmCell = collectionView.dequeueReusableCellWithReuseIdentifier("RpmView", forIndexPath: indexPath)
            return rpmCell
        }
        
        if indexPath == NSIndexPath(forItem: 3, inSection: 0) {
            let clockCell = collectionView.dequeueReusableCellWithReuseIdentifier("ClockView", forIndexPath: indexPath)
            return clockCell
        }
        
        return collectionView.dequeueReusableCellWithReuseIdentifier("RpmView", forIndexPath: indexPath)
    }
    
    
}

