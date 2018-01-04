//
//  ViewController.swift
//  iBeacons
//
//  Created by Karina on 04/01/2018.
//  Copyright © 2018 Karina. All rights reserved.
//

import CoreLocation
import UIKit

class TrackViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager : CLLocationManager!
    
    @IBOutlet weak var iBeaconFoundLabel: UILabel!
    @IBOutlet weak var proximityUUIDLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var accuracyLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager.init()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        startScanningForBeaconRegion(beaconRegion: getBeaconRegion())
    }
    
    // E06F95E4-FCFC-42C6-B4F8-F6BAE87EA1A0  - com.devfright.myRegion  /  8AEFB031-6C32-486F-825B-E26FA193487D - iPad
    func getBeaconRegion() -> CLBeaconRegion {
        let beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: "E06F95E4-FCFC-42C6-B4F8-F6BAE87EA1A0")!,
                                               identifier: "com.devfright.myRegion")
        return beaconRegion
    }
    
    func startScanningForBeaconRegion(beaconRegion: CLBeaconRegion) {
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    // Delegate Methods
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        let beacon = beacons.first  // The higger RSSI is the closest to the device and the beacons are sorted
        
        if beacons.count > 0 {
            guard let beacon = beacon else { return }
            
            iBeaconFoundLabel.text = "Yes"
            proximityUUIDLabel.text = beacon.proximityUUID.uuidString
            majorLabel.text = beacon.major.stringValue
            minorLabel.text = beacon.minor.stringValue
            accuracyLabel.text = String(describing: beacon.accuracy)
            if beacon.proximity == CLProximity.unknown {
                distanceLabel.text = "Unknown Proximity"
            } else if beacon.proximity == CLProximity.immediate {
                distanceLabel.text = "Immediate Proximity"
            } else if beacon.proximity == CLProximity.near {
                distanceLabel.text = "Near Proximity"
            } else if beacon.proximity == CLProximity.far {
                distanceLabel.text = "Far Proximity"
            }
            rssiLabel.text = String(describing: beacon.rssi)
        } else {
            iBeaconFoundLabel.text = "No"
            proximityUUIDLabel.text = ""
            majorLabel.text = ""
            minorLabel.text = ""
            accuracyLabel.text = ""
            distanceLabel.text = ""
            rssiLabel.text = ""
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit region")
    }

}
