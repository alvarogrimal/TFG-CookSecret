//
//  UIApplicationExtension.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 26/11/23.
//

import UIKit

extension UIApplication {
    func getTopVC() -> UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }
        return nil
    }
}
