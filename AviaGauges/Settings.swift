//
//  Settings.swift
//  AviaGauges
//
//  Created by Pavel Subach on 21.04.16.
//  Copyright © 2016 Pavel Subach. All rights reserved.
//

import UIKit

class Settings: UIViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBOutlet weak var ipField: UITextField!
    
    
    func checkHost(host: String) -> Bool {
        return DataHelper.sharedInstance.checkStatus(host)
    }
    
    @IBAction func storeSettings(sender: UIButton) {
        if (ipField != nil) {
            let strRawTarget: String? = ipField.text
            print("Input: " + strRawTarget!)
            
            let validIpAddressRegex = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
            let validHostnameRegex = "^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\\-]*[a-zA-Z0-9])\\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\\-]*[A-Za-z0-9])$"
            
            if strRawTarget == nil {
                let alert = UIAlertController(title: "Нет IP или Hostname", message: "Введите IP или Имя компьютера (лучше IP) с запущенной игрой Warthunder", preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)
               
            } else if (strRawTarget!.rangeOfString(validIpAddressRegex, options: .RegularExpressionSearch) != nil || strRawTarget!.rangeOfString(validHostnameRegex, options: .RegularExpressionSearch) != nil) {
                if checkHost(ipField.text!) {
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setURL(NSURL(string: "http://\(ipField.text!):8111"), forKey: "ipWarthunder")
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
            else {
                let alert = UIAlertController(title: "Нет IP или Hostname", message: "\(strRawTarget) не верно введен", preferredStyle: .Alert)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    @IBAction func discardSettings(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
