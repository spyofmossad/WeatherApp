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
        weekDay.text = DateHelper.shared.formatDate(from: dayData.timestamp, to: .weekDay)
        minTemp.text = String(dayData.temperature.min.rounded(toPlaces: 1))
        maxTemp.text = String(dayData.temperature.max.rounded(toPlaces: 1))
        icon.fetchImage(by: dayData.weather.first?.icon)
    }
}
