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
    
    private let locationManager = CLLocationManager();
    
    var locationUpdated: ((_ location: Result<CLLocation, Error>) -> ())?
    
    static let shared = LocationManager()
    
    private override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    func startUpdatelocation() {
        self.locationManager.startUpdatingLocation()
        print("Locating started")
    }
    
    func stopUpdateLocation() {
        self.locationManager.stopUpdatingLocation()
        print("Locating stopped")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Got to user's location successfully")
            self.locationUpdated?(.success(location))
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        self.locationUpdated?(.failure(error))
    }
    
    func getPlace(for location: CLLocation, completion: @escaping ((String) -> Void)) {
        let address = CLGeocoder()
        address.reverseGeocodeLocation(location) { (places, error) in
            if error == nil{
                if let place = places{
                    completion("\(place.first?.locality ?? "Unknown")")
                }
            }
        }
    }
}
