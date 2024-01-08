//
//  UIAlertControllerExtension.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 26/11/23.
//

import UIKit

extension UIAlertController {
    
    public static func getSettingsAction() -> UIAlertAction {

        let settingsAction = UIAlertAction(title: "",
                                           style: .cancel) { (_) -> Void in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }

        return settingsAction
    }
    
    public static func getCancelAction(title: String,
                                       handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction {

        return UIAlertAction(title: title, style: .default, handler: handler)
    }
}
