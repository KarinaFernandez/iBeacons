//
//  TransmitViewController.swift
//  iBeacons
//
//  Created by Karina on 04/01/2018.
//  Copyright © 2018 Karina. All rights reserved.
//


import CoreLocation
import CoreBluetooth
import UIKit

class TransmitViewController: UIViewController, CBPeripheralManagerDelegate {
    
    // Variables
    var beaconRegion: CLBeaconRegion! = nil
    var beaconPeripheralData: NSDictionary = NSDictionary()
    var peripheralManager: CBPeripheralManager = CBPeripheralManager()
    
    // Outlets
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var identityLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Actions
    @IBAction func transmitButtonTapped(_ sender: UIButton) {
        beaconPeripheralData = beaconRegion.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager.init(delegate: self, queue: nil)
    }
    
    @IBAction func beacon1Tapped(_ sender: UIButton) {
        beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: "8AEFB031-6C32-486F-825B-E26FA193487D")!,
                                           major: 1,
                                           minor: 0,
                                           identifier: "iPad")
        setLabels()
    }
    
    @IBAction func beacon2Tapped(_ sender: UIButton) {
        beaconRegion = CLBeaconRegion.init(proximityUUID: UUID.init(uuidString: "E06F95E4-FCFC-42C6-B4F8-F6BAE87EA1A0")!,
                                           major: 2,
                                           minor: 1,
                                           identifier: "iPod")
        setLabels()
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if (peripheral.state == .poweredOn) {
            peripheralManager .startAdvertising(beaconPeripheralData as? [String : Any])
            print("Powered On")
        } else {
            peripheralManager .stopAdvertising()
            print("Not Powered On, or some other error")
        }
    }
    
    func setLabels() {
        uuidLabel.text = beaconRegion.proximityUUID.uuidString
        majorLabel.text = beaconRegion.major?.stringValue
        minorLabel.text = beaconRegion.minor?.stringValue
        identityLabel.text = beaconRegion.identifier
    }

}
