//
//  MapViewController.swift
//  Weather
//
//  Created by Dmitry on 20.10.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var location: CLLocation?
    var completionHandler: ((CLLocation)->())?
    
    private var selectedPlace: MKPointAnnotation?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func mapTapped(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let viewPoint = sender.location(in: mapView)
            let coodrinates = mapView.convert(viewPoint, toCoordinateFrom: mapView)
            updateAnnotation(with: coodrinates)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let location = location {
            mapView.centerCoordinate = location.coordinate
            updateAnnotation(with: location.coordinate)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let selectedPlace = selectedPlace {
            self.completionHandler?(
                CLLocation(
                    latitude: selectedPlace.coordinate.latitude,
                    longitude: selectedPlace.coordinate.longitude))
        }
    }
    
    private func updateAnnotation(with coordinates: CLLocationCoordinate2D) {
        if let selectedPlace = selectedPlace {
            selectedPlace.coordinate = coordinates
            return
        }
        
        selectedPlace = MKPointAnnotation(__coordinate: coordinates)
        mapView.addAnnotation(selectedPlace!)
    }
}
