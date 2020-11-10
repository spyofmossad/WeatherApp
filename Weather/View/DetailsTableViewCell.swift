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
    
    func prepare(title: String, subtitle: String) {
        self.title.text = title
        self.subtitle.text = subtitle
    }
}
