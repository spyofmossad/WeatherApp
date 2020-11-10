//
//  CollectionViewCell.swift
//  Weather
//
//  Created by Dmitry on 10.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var hour: UILabel!
    @IBOutlet var icon: ImageView!
    @IBOutlet var temp: UILabel!
    
    func prepare(with hourDetails: Hourly) {
        hour.text = DateHelper.shared.formatDate(from: hourDetails.timestamp, to: .hours)
        temp.text = String(hourDetails.temperature.rounded(toPlaces: 1))
        icon.fetchImage(by: hourDetails.weather.first?.icon)
    }
}
