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
        
        hour.text = formatDate(from: hourDetails.dt)
        temp.text = String(hourDetails.temp.rounded(toPlaces: 1))
        icon.fetchImage(by: hourDetails.weather.first?.icon)
    }
    
    func formatDate(from unixInt: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(unixInt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: date)
    }
}
