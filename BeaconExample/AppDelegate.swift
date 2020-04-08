//
//  AppDelegate.swift
//  BeaconExample
//
//  Created by Masakazu Ohtsuka on 2020/04/08.
//  Copyright © 2020 maaash.jp. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var beacon :Beacon!
    var beaconMonitor :BeaconMonitor!
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        log()
        let operationModeBeacon = false
        if operationModeBeacon {
            beacon = Beacon()
        }
        else {
            beaconMonitor = BeaconMonitor()
        }

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = storyboard.instantiateInitialViewController()

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        log()
    }
}
