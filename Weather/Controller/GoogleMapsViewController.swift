//
//  GoggleMapsViewController.swift
//  Weather
//
//  Created by Dmitry on 21.10.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {
    
    var location: CLLocation?
    var completionHandler: ((CLLocation) -> ())?
    
    private var marker: GMSMarker?
    private var mapView: GMSMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        addTitle()
        
        if let location = location {
            addMapView(with: location)
            updateMarker(with: location.coordinate)
            
        }
    }
    
    private func updateMarker(with coordinate: CLLocationCoordinate2D) {
        if let marker = marker {
            marker.position = coordinate
            return
        }
        
        marker = GMSMarker()
        marker?.position = coordinate
        marker?.map = mapView
    }
    
    private func addMapView(with location: CLLocation) {
        let camera = GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude,
            zoom: 6.0)
                    
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 40, width: self.view.bounds.width, height: self.view.bounds.height), camera: camera)
        self.view.addSubview(mapView!)
        mapView?.delegate = self
    }
    
    private func addTitle() {
        let title = UILabel()
        title.text = "GoogleMaps"
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(title)
        
        let constraints = [
            title.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension GoogleMapsViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        updateMarker(with: coordinate)
        completionHandler?(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}
