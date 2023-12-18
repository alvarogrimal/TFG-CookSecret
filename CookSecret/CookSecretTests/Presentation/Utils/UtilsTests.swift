//
//  UtilsTests.swift
//  CookSecretTests
//
//  Created by Alvaro Grimal Cabello on 18/12/23.
//

import XCTest
@testable import CookSecret

final class UtilsTests: XCTestCase {
    
    func testGetTime() {
        // Given
        let hours = 2
        let minutes = 32
        let seconds = 45
        let timeInSeconds: Double = Double((hours * 3600) + (minutes * 60) + seconds)
        
        // When
        let timeComponents = Utils.getTime(from: timeInSeconds)
        
        // Then
        XCTAssertEqual(timeComponents.hours, hours)
        XCTAssertEqual(timeComponents.minutes, minutes)
        XCTAssertEqual(timeComponents.seconds, seconds)
    }
    
    func testShortTimeWithHoursAndMinutes() {
        // Given
        let hours = 2
        let minutes = 30
        let seconds = 45
        let timeInSeconds: Double = Double((hours * 3600) + (minutes * 60) + seconds)
        
        // When
        let shortTime = Utils.getShortTime(from: timeInSeconds)
        
        // Then
        XCTAssertEqual(shortTime, "2.5 " + "add_recipe_hours".localized)
    }
    
    func testShortTimeWithHours() {
        // Given
        let hours = 2
        let minutes = 0
        let seconds = 0
        let timeInSeconds: Double = Double((hours * 3600) + (minutes * 60) + seconds)
        
        // When
        let shortTime = Utils.getShortTime(from: timeInSeconds)
        
        // Then
        XCTAssertEqual(shortTime, "2 " + "add_recipe_hours".localized)
    }
    
    func testShortTimeOnlyMinutes() {
        // Given
        let hours = 0
        let minutes = 45
        let seconds = 45
        let timeInSeconds: Double = Double((hours * 3600) + (minutes * 60) + seconds)
        
        // When
        let shortTime = Utils.getShortTime(from: timeInSeconds)
        
        // Then
        XCTAssertEqual(shortTime, "\(minutes) " + "add_recipe_minutes".localized)
    }
}
