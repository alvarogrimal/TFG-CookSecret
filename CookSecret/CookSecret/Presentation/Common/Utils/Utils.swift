//
//  Utils.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 29/11/23.
//

import Foundation

class Utils {
    
    static func getTime(from value: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let hours = Int(value / 3600)
        let minutes = Int((value.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(value.truncatingRemainder(dividingBy: 60))
        
        return (hours, minutes, seconds)
    }
    
    static func getShortTime(from value: Double) -> String {
        let (hours, minutes, _) = getTime(from: value)
        if hours == .zero {
            return "\(minutes) " + "add_recipe_minutes".localized
        } else {
            let hoursDecimal = value / 3600
            
            var formattedValue = ""
            if hoursDecimal.truncatingRemainder(dividingBy: 1) == 0 {
                formattedValue = String(format: "%.0f ", hoursDecimal)
            } else {
                formattedValue = String(format: "%.1f ", hoursDecimal)
            }
            
            return String(format: formattedValue, hoursDecimal) + "add_recipe_hours".localized
        }
    }
}
