//
//  BeaconMonitor.swift
//  BeaconExample
//
//  Created by Masakazu Ohtsuka on 2020/04/08.
//  Copyright © 2020 maaash.jp. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreBluetooth
import UserNotifications

class BeaconMonitor: NSObject {
    var locationManager :CLLocationManager!

    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        monitorBeacons()

        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            log("granted: \(granted), error: \(error)")
        }
    }

    func monitorBeacons() {
        if CLLocationManager.isMonitoringAvailable(for:
                      CLBeaconRegion.self) {
            log("startMonitoring")
            let region = Beacon.createBeaconRegion()
            region.notifyOnEntry = true
            region.notifyOnExit = true
            region.notifyEntryStateOnDisplay = true
            self.locationManager.startMonitoring(for: region)
            self.locationManager.requestState(for: Beacon.createBeaconRegion())
        }
    }
}

extension BeaconMonitor :CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        log("didEnterRegion: \(region)")
        let content = UNMutableNotificationContent()
        content.title = "Enter"
        let notification = UNNotificationRequest(identifier: "Enter", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(notification) { (er) in
            if er != nil {
                log("notification error: \(er!)")
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        log("didExitRegion: \(region)")
        let content = UNMutableNotificationContent()
        content.title = "Exit"
        let notification = UNNotificationRequest(identifier: "Exit", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(notification) { (er) in
            if er != nil {
                log("notification error: \(er!)")
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        log("didDetermineState: \(state), region: \(region)")
    }
}

extension CLRegionState :CustomStringConvertible {
    public var description: String {
        switch self {
        case .inside:
            return "inside"
        case .outside:
            return "outside"
        case .unknown:
            return "unknown"
        }
    }
}
