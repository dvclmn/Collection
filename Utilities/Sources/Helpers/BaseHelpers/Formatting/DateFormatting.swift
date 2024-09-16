//
//  File.swift
//  
//
//  Created by Dave Coleman on 11/7/2024.
//

import Foundation
import SwiftUI

public extension Date {
    
    // Date Format Cheatsheet:
    //
    // Day of Week:
    // Thu          E           (Short)
    // Thursday     EEEE        (Full)
    //
    // Month:
    // Jul          MMM         (Short)
    // July         MMMM        (Full)
    // 07           MM          (Number, padded)
    // 7            M           (Number, not padded)
    //
    // Day of Month:
    // 1            d           (Not padded)
    // 01           dd          (Padded)
    //
    // Year:
    // 2023         yyyy        (Full)
    // 23           yy          (Short)
    //
    // Time:
    // 1:34 PM      h:mm a      (12-hour)
    // 13:34        HH:mm       (24-hour)
    // 1:34:56 PM   h:mm:ss a   (With seconds, 12-hour)
    // 13:34:56     HH:mm:ss    (With seconds, 24-hour)
    //
    // Examples:
    // "EEEE, MMMM d, yyyy"           -> "Thursday, July 6, 2023"
    // "E, MMM d, yy"                 -> "Thu, Jul 6, 23"
    // "yyyy-MM-dd'T'HH:mm:ss"        -> "2023-07-06T13:34:56"
    // "h:mm a 'on' MMMM d, yyyy"     -> "1:34 PM on July 6, 2023"
    
    /// Returns the date formatted as "Thu, July 11, 2024"
    var mediumDateFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMMM d, yyyy"
        return formatter.string(from: self)
    }
    
    /// Returns the date and time formatted as "Thu, July 11, 2024 at 1:34pm"
    var mediumDateTimeFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMMM d, yyyy 'at' h:mma"
        return formatter.string(from: self).replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
    }
    
    /// Returns the date and time formatted as "1:34pm"
    var friendlyDateAndTime: AttributedString {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: now)
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        var friendlyPart = ""
        var datePart = ""
        
        if let days = components.day {
            if days == 0 {
                friendlyPart = "Today, "
                formatter.dateFormat = "h:mma"
            } else if days == 1 {
                friendlyPart = "Yesterday, "
                formatter.dateFormat = "h:mma"
            } else if days < 7 {
                friendlyPart = "Last "
                formatter.dateFormat = "EEEE"
            } else if calendar.isDate(self, equalTo: now, toGranularity: .year) {
                formatter.dateFormat = "EEEE, d MMMM"
            } else {
                formatter.dateFormat = "EEEE, d MMMM yyyy"
            }
        } else {
            formatter.dateFormat = "EEEE, d MMMM yyyy"
        }
        
        datePart = formatter.string(from: self)
        datePart = datePart.replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
        
        var attributedString = AttributedString(friendlyPart)
        attributedString += AttributedString(datePart)
        
        if !friendlyPart.isEmpty {
            attributedString.foregroundColor = .secondary.opacity(0.7)
            
            if let dateRange = attributedString.range(of: datePart) {
                attributedString[dateRange].foregroundColor = .primary.opacity(0.7)
            }
        } else {
            attributedString.foregroundColor = .primary.opacity(0.7)
        }
        
        return attributedString
    }
    
    /// Returns the date and time formatted as "1:34pm"
    var mediumTimeFormat: String {
        
        let today = Date.now
        var todayString: String = ""
        
        if today == self {
            todayString = "Today at "
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "\(todayString)h:mma"
        return formatter.string(from: self).replacingOccurrences(of: "AM", with: "am").replacingOccurrences(of: "PM", with: "pm")
    }
    
    /// Returns the date formatted as "July 11 2024"
    var shortDateFormat: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d yyyy"
        return formatter.string(from: self)
    }
}