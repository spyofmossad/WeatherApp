//
//  ExtensionLoopable.swift
//  Weather
//
//  Created by Dmitry on 12.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation

protocol Loopable {
    func allProperties() -> [String: Any]
}

extension Loopable {
    func allProperties() -> [String: Any] {

        var result: [String: Any] = [:]

        let mirror = Mirror(reflecting: self)

        for (property, value) in mirror.children {
            guard let property = property else {
                continue
            }

            result[property] = value
        }

        return result
    }
}
