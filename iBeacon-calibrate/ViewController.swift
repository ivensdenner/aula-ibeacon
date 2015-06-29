//
//  ViewController.swift
//  iBeacon-calibrate
//
//  Created by Ivens Denner on 29/06/15.
//  Copyright (c) 2015 Ivens Denner. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

// Não esquecer de CLLocationManagerDelegate
// Não esquecer de colocar os troço plist

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!
    @IBOutlet weak var txPowerLabel: UILabel!
    @IBOutlet weak var calibrateButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var region = CLBeaconRegion()
    var locationManager = CLLocationManager()
    let uuid = NSUUID(UUIDString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")
    
    var count : Int = 0
    var rssiSum : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.activityIndicator.hidden = true
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func calibrate(sender: UIButton) {
        majorTextField.resignFirstResponder()
        minorTextField.resignFirstResponder()
        
        let major : Int
        let minor : Int
        
        // Pegar major e minor dos TextFields
        if (majorTextField.text != "") {
            major = majorTextField.text.toInt()!
        } else {
            major = 0
        }
        
        if (minorTextField.text != "") {
            minor = minorTextField.text.toInt()!
        } else {
            minor = 0
        }
        
        // Criando region e iniciando ranging
        self.region = CLBeaconRegion(proximityUUID: uuid, major: CLBeaconMajorValue(major), minor: CLBeaconMinorValue(minor), identifier: "bepid")
        self.locationManager.startRangingBeaconsInRegion(self.region)
        
        loadingScreen(true)
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        let beacon = beacons[0] as! CLBeacon
        
        if (count < 20) {
            count++
            rssiSum += beacon.rssi
        } else {
            let result = rssiSum / count
            txPowerLabel.text = "\(result)"
            
            rssiSum = 0
            count = 0
            
            self.locationManager.stopRangingBeaconsInRegion(self.region)
            loadingScreen(false)
        }
    }
    
    func loadingScreen(enabled: Bool) {
        if (enabled) {
            self.majorTextField.enabled = false
            self.minorTextField.enabled = false
            self.calibrateButton.enabled = false
            
            self.activityIndicator.hidden = false
            self.activityIndicator.startAnimating()
        } else {
            self.majorTextField.enabled = true
            self.minorTextField.enabled = true
            self.calibrateButton.enabled = true
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.hidden = true
        }
    }

}
