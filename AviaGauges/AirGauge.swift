//
//  ViewController.swift
//  AviaGauges
//
//  Created by Pavel Subach on 17.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class AirGauge: UICollectionViewController {

    
    let gauges = ["SpeedView", "AltView", "RpmView", "ClockView"];
    var longPressGesture: UILongPressGestureRecognizer? = nil
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(AirGauge.handleLongGesture(_:)))
        self.collectionView!.addGestureRecognizer(longPressGesture!)
        
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
        return gauges.count
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HeaderView", forIndexPath: indexPath)
        return headerView
    }
    
    override func collectionView(collectionView: UICollectionView, moveItemAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        print("from: \(sourceIndexPath.row) to: \(destinationIndexPath.row)")
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("gauge", forIndexPath: indexPath)
        switch gauges[indexPath.row] {
        case "SpeedView":
            let speedView = SpeedView.init(frame: cell.bounds)
            cell.backgroundView = speedView
            break
        case "AltView":
            let altView = AltView.init(frame: cell.bounds)
            cell.backgroundView = altView
            break
        case "RpmView":
            let rpmView = RpmView.init(frame: cell.bounds)
            cell.backgroundView = rpmView
            break
        case "ClockView":
            let clockView = ClockView.init(frame: cell.bounds)
            cell.backgroundView = clockView
            break
        default:
            break
        }
        return cell
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.Began:
            guard let selectedIndexPath = self.collectionView!.indexPathForItemAtPoint(gesture.locationInView(self.collectionView)) else {
                break
            }
            collectionView!.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            collectionView!.updateInteractiveMovementTargetPosition(gesture.locationInView(gesture.view!))
        case UIGestureRecognizerState.Ended:
            collectionView!.endInteractiveMovement()
        default:
            collectionView!.cancelInteractiveMovement()
        }
    }
    
}