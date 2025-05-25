//
//  Date+Ext.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 16/05/2025.
//

import Foundation

extension Date {
    var asShortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
    
    func daysSinceEvent() -> String {
        let calendar = Calendar.current
        let now = Date()
        let startOfEstDate = calendar.startOfDay(for: self)
        let startOfToday = calendar.startOfDay(for: now)
        
        let components = calendar.dateComponents([.day], from: startOfEstDate, to: startOfToday)
        let dayCount = components.day ?? 0
        
        return dayCount == 1 ? "1 day ago" : "\(dayCount) days ago"
    }
}
