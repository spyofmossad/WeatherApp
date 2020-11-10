//
//  String+Extensions.swift
//  Weather
//
//  Created by Dmitry on 09.11.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation

extension String {
    func toCellTitle() -> String {
        return self.replacingOccurrences(of: "_", with: " ").uppercased()
    }
}
