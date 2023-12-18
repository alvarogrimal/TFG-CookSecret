//
//  AppDelegate.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 18/12/23.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidFinishLaunching(_ application: UIApplication) {
        if CommandLine.arguments.contains("testing") {
            UIView.setAnimationsEnabled(false)
        }
    }
}
