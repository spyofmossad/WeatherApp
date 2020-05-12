//
//  LocationManager.swift
//  Weather
//
//  Created by Dmitry on 11.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager();
    
    var locationUpdated: ((_ location: Location) -> ())?
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Got to user's location successfully")
            getCity(for: location) { city in
                let loc = Location(
                    city: city,
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude)
                self.locationUpdated?(loc)
                self.locationManager.stopUpdatingLocation()
            }
            
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    private func getCity(for location: CLLocation, completion: @escaping ((String) -> Void)) {
        let address = CLGeocoder.init()
        address.reverseGeocodeLocation(CLLocation.init(latitude: location.coordinate.latitude, longitude:location.coordinate.longitude)) { (places, error) in
                if error == nil{
                    if let place = places{
                        completion("\(place.first?.locality ?? "Unknown")")
                    }
                }
        }
    }
}
