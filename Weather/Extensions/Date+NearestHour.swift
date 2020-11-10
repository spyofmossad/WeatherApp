//
//  ExtensionDate.swift
//  Weather
//
//  Created by Dmitry on 11.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation

extension Date {
    func nearestHour() -> Date {
        return Date(timeIntervalSinceReferenceDate:
                (timeIntervalSinceReferenceDate / 3600.0).rounded(.toNearestOrEven) * 3600.0)
    }
}
