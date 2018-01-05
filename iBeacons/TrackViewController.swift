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
        
        let uuid = ["E06F95E4-FCFC-42C6-B4F8-F6BAE87EA1A0", "8AEFB031-6C32-486F-825B-E26FA193487D"]
        let identifiers = ["iPod", "iPad"]
        
        for i in 0...uuid.count-1 {
            let beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: uuid[i])!,
                                                   identifier: identifiers[i])
            startScanningForBeaconRegion(beaconRegion: beaconRegion)
        }
    }
    
    func startScanningForBeaconRegion(beaconRegion: CLBeaconRegion) {
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    // Delegate Methods
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print(beacons)
        
        var closestBeacon: CLBeacon? = nil
        var closest: CLBeacon? = nil
        let minRSSI = -10000
        let minAccuracy: Double = -1000
        
        // Search the inmediate beacons
        let inmediateBeacons = beacons
            .filter { $0.proximity == CLProximity.immediate }
        
        for beacon in inmediateBeacons {
            if beacon.accuracy < CLLocationAccuracy.greatestFiniteMagnitude {
                closest = beacon
            }
        }
        closestBeacon = closest
        
        // Search the near beacons if the is not immediate beacon
        if closestBeacon == nil {
            var minBeacon: CLBeacon? = nil
            let nearBeacons = beacons
                .filter { $0.proximity == CLProximity.near }
            // Search the closest
            for beacon in nearBeacons {
                if beacon.accuracy < minAccuracy && beacon.rssi > minRSSI {
                    minBeacon = beacon
                }
            }
            closestBeacon = minBeacon
        }

        if beacons.count > 0 {
            print("beacons: \(beacons)")
            guard let beacon = closestBeacon else { return }
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
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Enter region")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exit region")
    }

}
