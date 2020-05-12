//
//  ExtensionDictionary.swift
//  Weather
//
//  Created by Dmitry on 10.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation

extension Dictionary {
    subscript(i: Int) -> (key:Key, value:Value) {
        get {
            return self[index(startIndex, offsetBy: i)]
        }
    }
}
