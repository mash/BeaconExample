//
//  Beacon.swift
//  BeaconExample
//
//  Created by Masakazu Ohtsuka on 2020/04/08.
//  Copyright © 2020 maaash.jp. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth

class Beacon: NSObject {
    var peripheralManager :CBPeripheralManager!

    override init() {
        super.init()
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    // https://developer.apple.com/documentation/corelocation/turning_an_ios_device_into_an_ibeacon_device
    static func createBeaconRegion() -> CLBeaconRegion {
        let proximityUUID = UUID(uuidString:
                    "39ED98FF-2900-441A-802F-9C398FC199D2")
        let major : CLBeaconMajorValue = 100
        let minor : CLBeaconMinorValue = 1
        let beaconID = "jp.maaash.BeaconExample"

        return CLBeaconRegion(proximityUUID: proximityUUID!,
                    major: major, minor: minor, identifier: beaconID)
    }

    func advertiseDevice(region : CLBeaconRegion) {
        log("advertising region: \(region)")
        let peripheralData = region.peripheralData(withMeasuredPower: nil)
        peripheralManager.startAdvertising(((peripheralData as NSDictionary) as! [String : Any]))
    }
}

extension Beacon :CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        log("peripheralManagerDidUpdateState: \(peripheral.state)")
        if peripheral.state == .poweredOn {
            advertiseDevice(region: Beacon.createBeaconRegion())
        }
    }
}

extension CBManagerState :CustomStringConvertible {
    public var description: String {
        switch self {
        case .poweredOff:
            return "poweredOff"
        case .poweredOn:
            return "poweredOn"
        case .resetting:
            return "resetting"
        case .unauthorized:
            return "unauthorized"
        case .unknown:
            return "unknown"
        case .unsupported:
            return "unsupported"
        @unknown default:
            return "@unknown"
        }
    }
}
