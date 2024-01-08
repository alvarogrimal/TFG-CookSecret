//
//  CalendarViewRepresentable.swift
//  CookSecret
//
//  Created by Alvaro Grimal Cabello on 6/12/23.
//

import SwiftUI
import FSCalendar

struct CalendarViewRepresentable: UIViewRepresentable {
    
    typealias UIViewType = FSCalendar
    @Binding var calendar: FSCalendar
    @Binding var selectedDate: Date
    @Binding var recipesPerDate: [CalendarItemViewModel]
    
    init(calendar: Binding<FSCalendar>,
         selectedDate: Binding<Date>,
         recipesPerDate: Binding<[CalendarItemViewModel]>) {
        _calendar = calendar
        _selectedDate = selectedDate
        _recipesPerDate = recipesPerDate
    }
    
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        calendar.scrollDirection = .vertical
        calendar.firstWeekday = 2
        calendar.appearance.selectionColor = UIColor(named: "Pelorous")
        calendar.appearance.eventDefaultColor = UIColor(named: "YellowSea")
        calendar.appearance.todayColor = UIColor(named: "CSIndigo")
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.weekdayTextColor = .black
        calendar.appearance.headerSeparatorColor = .red
        calendar.select(selectedDate)
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject,
                       FSCalendarDelegate,
                       FSCalendarDataSource {
        var parent: CalendarViewRepresentable
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar,
                      didSelect date: Date,
                      at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        
        func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
            return (parent.recipesPerDate
                .first(where: { $0.date == date })?.items.count ?? .zero) == .zero ? .zero : 1
        }
    }
}
