//
//  TableViewCell.swift
//  Weather
//
//  Created by Dmitry on 10.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var weekDay: UILabel!
    @IBOutlet var minTemp: UILabel!
    @IBOutlet var maxTemp: UILabel!
    @IBOutlet var icon: ImageView!
    
    func prepare(with dayData: Daily) {
        weekDay.text = formatDate(from: dayData.dt)
        minTemp.text = String(dayData.temp.min.rounded(toPlaces: 1))
        maxTemp.text = String(dayData.temp.max.rounded(toPlaces: 1))
        icon.fetchImage(by: dayData.weather.first?.icon)
    }
    
    private func formatDate(from unixInt: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(unixInt))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
}
