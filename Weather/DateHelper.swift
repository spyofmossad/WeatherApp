//
//  DateHelper.swift
//  Weather
//
//  Created by Dmitry on 09.11.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation

enum DateFormat: String {
    case hours = "HH"
    case hoursMinutesSeconds = "HH:mm:ss"
    case weekDay = "EEEE"
}

class DateHelper {
    
    private var dateFormatter: DateFormatter
    
    static let shared = DateHelper()
    
    private init() {
        dateFormatter = DateFormatter()
    }
    
    func formatDate(from unixInt: Int, to: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: Double(unixInt))
        
        dateFormatter.dateFormat = to.rawValue
        return dateFormatter.string(from: date)
    }
}
