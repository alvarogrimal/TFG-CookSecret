//
//  TimePickerView.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 19/11/23.
//

import SwiftUI

struct TimerView: View {
    
    // MARK: - Properties
    
    @ObservedObject var model: TimerViewModel
    
    // MARK: - Body
    
    var body: some View {
        HStack {
            TimePickerView(title: "add_recipe_hours".localized,
                           range: model.hoursRange,
                           binding: $model.selectedHoursAmount)
            TimePickerView(title: "add_recipe_minutes".localized,
                           range: model.minutesRange,
                           binding: $model.selectedMinutesAmount)
            TimePickerView(title: "add_recipe_seconds".localized,
                           range: model.secondsRange,
                           binding: $model.selectedSecondsAmount)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
        .foregroundColor(.black)
    }
}

struct TimePickerView: View {
    
    // MARK: - Properties
    
    private let pickerViewTitlePadding: CGFloat = 4.0
    let title: String
    let range: ClosedRange<Int>
    let binding: Binding<Int>
    
    // MARK: - Body
        
    var body: some View {
        HStack(spacing: -pickerViewTitlePadding) {
            Picker(title, selection: binding) {
                ForEach(range, id: \.self) { timeIncrement in
                    HStack {
                        Spacer()
                        Text("\(timeIncrement)")
                            .foregroundColor(.black)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .pickerStyle(InlinePickerStyle())
            .labelsHidden()
            
            Text(title)
        }
    }
}

#Preview {
    TimerView(model: .init())
}
