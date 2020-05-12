//
//  ImageView.swift
//  Weather
//
//  Created by Dmitry on 11.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit

class ImageView: UIImageView {
    
    func fetchImage(by id: String?) {
        guard let id = id else { return }
        
        if let cachedImage = getCachedImage(by: id) {
            image = cachedImage
            return
        }
        
        ImageManager.shared.getImage(by: id) { (data) in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
            StorageDataManager.shared.saveData(data: data, with: id)
        }
    }
    
    private func getCachedImage(by id: String) -> UIImage? {
        if let cachedData = StorageDataManager.shared.getData(by: id) {
            return UIImage(data: cachedData)
        }
        return nil
    }
}
