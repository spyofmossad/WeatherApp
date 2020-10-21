//
//  DetailsTableViewCell.swift
//  Weather
//
//  Created by Dmitry on 10.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet var title: UILabel!
    @IBOutlet var subtitle: UILabel!
    
    func prepare(title: String, subtitle: Any) {
        self.title.text = title.replacingOccurrences(of: "_", with: " ").uppercased()
        
        switch title {
        case "sunrise", "sunset":
            self.subtitle.text = formatDate(from: subtitle)
        case "temp", "feelsLike", "dewPoint":
            self.subtitle.text = "\(String(subtitle as! Double)) C°"
        default:
            switch subtitle {
            case is Double:
                self.subtitle.text = String(subtitle as! Double)
            case is Int:
                self.subtitle.text = String(subtitle as! Int)
            default:
                self.subtitle.text = "N/A"
            }
        }
    }
    
    private func formatDate(from unixTimestamp: Any) -> String {
        guard let unixTimestamp = unixTimestamp as? Int else { return "N/A" }
        
        let date = Date(timeIntervalSince1970: Double(unixTimestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
