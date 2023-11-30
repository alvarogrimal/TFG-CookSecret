//
//  TimerViewModel.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import Foundation

class TimerViewModel: ObservableObject {
    
    @Published var selectedHoursAmount = 1
    @Published var selectedMinutesAmount = 0
    @Published var selectedSecondsAmount = 0

    let hoursRange = 0...23
    let minutesRange = 0...59
    let secondsRange = 0...59
    
    init(selectedHoursAmount: Int = 1, selectedMinutesAmount: Int = 0, selectedSecondsAmount: Int = 0) {
        self.selectedHoursAmount = selectedHoursAmount
        self.selectedMinutesAmount = selectedMinutesAmount
        self.selectedSecondsAmount = selectedSecondsAmount
    }
    
    init(value: Double) {
        let (hour, min, sec) = Utils.getTime(from: value)
        self.selectedHoursAmount = hour
        self.selectedMinutesAmount = min
        self.selectedSecondsAmount = sec
    }
}
