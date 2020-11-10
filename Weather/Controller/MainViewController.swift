//
//  ViewController.swift
//  Weather
//
//  Created by Dmitry on 09.05.2020.
//  Copyright © 2020 Dmitry. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MainViewController: UIViewController {

    @IBOutlet var headerViewHeight: NSLayoutConstraint!
    @IBOutlet var scrollViewTopOffset: NSLayoutConstraint!
    @IBOutlet var tableContainerHeight: NSLayoutConstraint!
    
    @IBOutlet var headerView: UIView!
    
    @IBOutlet var collectionViewContainer: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var detailForecast: UITableView!
    @IBOutlet var weekForecastTable: UITableView!
    
    @IBOutlet var city: UILabel!
    @IBOutlet var shortDesc: UILabel!
    @IBOutlet var temp: UILabel!
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Open map", message: "Select map SDK", preferredStyle: .alert)
        let mapKitAction = UIAlertAction(title: "Open MapKit", style: .default) { (_) in
            self.performSegue(withIdentifier: "openNativeMap", sender: nil)
        }
        let googleMapAction = UIAlertAction(title: "Open Google maps", style: .default) { (_) in
            self.performSegue(withIdentifier: "openGoogleMap", sender: nil)
        }
        alert.addAction(mapKitAction)
        alert.addAction(googleMapAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private let headerViewConstant: CGFloat = 300
    private let defaultLocation = CLLocation(latitude: 37.3230, longitude: -122.0322)
    private var weatherData: WeatherData?
    private var detailsData: [String : Any]?
    private var location: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner()
        getLastDataSnapshotFromStorage()
        
        LocationManager.shared.locationUpdated = { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let location):
                self.location = location
                self.getPlaceAndWeather(for: location)
                self.recalculateSizes()
                self.removeSpinner()
            case .failure(let error):
                self.getErrorAlert(for: error)
            }
        }
    }
    
    private func getErrorAlert(for error: Error) {
        let alert = UIAlertController(title: "Location is unavaliable", message: error.localizedDescription, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Try again", style: .default) { _ in
            LocationManager.shared.requestLocation()
        }
        let defaultPlaceAction = UIAlertAction(title: "Default place (Cupertino)", style: .cancel) { _ in
            self.getPlaceAndWeather(for: self.defaultLocation)
        }
        alert.addAction(retryAction)
        alert.addAction(defaultPlaceAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getLastDataSnapshotFromStorage() {
        guard let data = StorageDataManager.getWeatherData() else { assertionFailure("Failed to get weather data"); return }
        let location = CLLocation(latitude: data.latitude, longitude: data.longitude)
        LocationManager.shared.getPlace(for: location) { [weak self] (place) in
                guard let self = self else { return }
                self.weatherData = data
                self.detailsData = self.weatherData?.getDailyDetails()
                self.updateUI(with: data, for: place)
                self.recalculateSizes()
                self.removeSpinner()
            }
    }
    
    private func getPlaceAndWeather(for location: CLLocation) {
        LocationManager.shared.getPlace(for: location) { [weak self] (place) in
            guard let self = self else { return }
            
            NetworkManager.fetchData(for: location) { [weak self] (data) in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.weatherData = data
                    self.detailsData = self.weatherData?.getDailyDetails()
                    guard let weatherData = self.weatherData else { return }
                    self.updateUI(with: weatherData, for: place)
                    StorageDataManager.saveWeatherData(weather: weatherData);
                }
            }
        }
    }
    
    private func updateUI(with weather: WeatherData, for city: String) {
        self.city.text = city
        shortDesc.text = "\(weather.currentWeather.other.first?.mainDescription ?? "") (\(weather.currentWeather.other.first?.detailDescription ?? ""))"
        temp.text = "\(String(weather.currentWeather.temperature.rounded(toPlaces: 1)))°"
        collectionView.reloadData()
        detailForecast.reloadData()
        weekForecastTable.reloadData()
    }
    
    private func recalculateSizes() {
        scrollViewTopOffset.constant = headerView.bounds.height + collectionView.bounds.height
        tableContainerHeight.constant = detailForecast.bounds.height + weekForecastTable.bounds.height + headerView.bounds.height + collectionView.bounds.height
        
        collectionViewContainer.addTopBorder(color: .lightGray, thickness: 1)
        collectionViewContainer.addBottomBorder(color: .lightGray, thickness: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openNativeMap" {
            let mapVC = segue.destination as! MapKitViewController
            guard let location = location else { return }
            mapVC.location = location
            mapVC.completionHandler = { [weak self] (location) in
                guard let self = self else { return }
                self.location = location
                self.getPlaceAndWeather(for: location)
            }
        }
        if segue.identifier == "openGoogleMap" {
            let mapVC = segue.destination as! GoogleMapsViewController
            guard let location = location else { return }
            mapVC.location = location
            mapVC.completionHandler = { [weak self] (location) in
                guard let self = self else { return }
                self.location = location
                self.getPlaceAndWeather(for: location)
            }
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        
        if offsetY <= 0 {
            self.headerViewHeight.constant = abs(offsetY) + headerViewConstant
        }
        
        if offsetY > 0 {
            let newHeight = headerViewConstant - abs(offsetY)
            self.headerViewHeight.constant = max(newHeight, 70)
            
            let bounceProgress = min(1, 1 - offsetY / 100)
            self.temp.textColor = UIColor(white: 0, alpha: bounceProgress)
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case weekForecastTable:
            guard let dataCount = weatherData?.dailyWeather.count else { return 0 }
            return dataCount
        case detailForecast:
            guard let dataCount = detailsData?.count else { return 0 }
            return dataCount
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case weekForecastTable:
            let cell = tableView.dequeueReusableCell(withIdentifier: "weekDayCell", for: indexPath) as! TableViewCell
            guard let dailyData = weatherData?.dailyWeather else { return cell }
            cell.prepare(with: dailyData[indexPath.row])
            return cell
        case detailForecast:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
            guard let detailsData = detailsData else { return cell }
            let title = detailsData[indexPath.row].key.toCellTitle()
            let subtitle = convertSubtitle(kvPair: detailsData[indexPath.row])
            cell.prepare(title: title, subtitle: subtitle)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let hourData = weatherData?.getHourForecast() else { return 0 }
        return hourData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as! CollectionViewCell
        guard let hourData = weatherData?.getHourForecast() else { return cell }
        
        cell.prepare(with: hourData[indexPath.row])
        
        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height / 2, height: collectionView.frame.height)
    }
}

extension MainViewController {
    enum DetailProperty: String {
        case sunriseTime
        case sunsetTime
        case temperature
        case feelsLike
        case dewPoint
        case timestamp
    }
    
    private func convertSubtitle(kvPair: (key: String, value: Any)) -> String {
        switch kvPair.key {
        case DetailProperty.sunriseTime.rawValue,
             DetailProperty.sunsetTime.rawValue,
             DetailProperty.timestamp.rawValue:
            guard let unixTimestamp = kvPair.value as? Int else { return "N/A" }
                let date = DateHelper.shared.formatDate(from: unixTimestamp, to: .hoursMinutesSeconds)
                return date
        case DetailProperty.temperature.rawValue,
             DetailProperty.feelsLike.rawValue,
             DetailProperty.dewPoint.rawValue:
                return "\(String(kvPair.value as! Double)) C°"
        default:
            switch kvPair.value {
            case is Double:
                return String(kvPair.value as! Double)
            case is Int:
                return String(kvPair.value as! Int)
            default:
                return "N/A"
            }
        }
    }
}
