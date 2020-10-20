//
//  UIViewController+Extension.swift
//  iTunesCatalog
//
//  Created by Dmitry on 05.10.2020.
//

import Foundation
import UIKit

var pView: UIView?

extension UIViewController {
    func showSpinner() {
        DispatchQueue.main.async {
            if let pView = pView {
                pView.removeFromSuperview()
            }
            let placeholderView = UIView(frame: self.view.bounds)
            placeholderView.backgroundColor = .white
            let activityIndicator = UIActivityIndicatorView(style: .medium)
            activityIndicator.startAnimating()
            activityIndicator.center = placeholderView.center
            placeholderView.addSubview(activityIndicator)
            self.view.addSubview(placeholderView)
            
            pView = placeholderView
        }
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            pView?.removeFromSuperview()
            pView = nil
        }
    }
}
