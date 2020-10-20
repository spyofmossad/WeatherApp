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

class ViewController: UIViewController {

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
    
    let headerViewConstant: CGFloat = 300
        
    var weatherData: WeatherData?
    var detailsData: [String : Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showSpinner()
        getDataFromStorageIfAvailable()
        getDataByLocation()
        recalculateSizes()
    }
        
    func getDataByLocation() {
        LocationManager.shared.locationUpdated = { location in
            NetworkManager.shared.fetchData(for: location) { (data) in
                DispatchQueue.main.async {
                    self.weatherData = data
                    self.detailsData = self.weatherData?.getDailyDetails()
                    guard let weatherData = self.weatherData else { return }
                    self.prepareView(with: weatherData, for: location.city)                    
                    StorageDataManager.shared.saveWeatherData(weather: weatherData);
                    self.removeSpinner()
                }
            }
        }
    }
    
    func getDataFromStorageIfAvailable() {
        if let data = StorageDataManager.shared.getWeatherData() {
            weatherData = data
            detailsData = weatherData?.getDailyDetails()
            prepareView(with: data, for: nil)
            recalculateSizes()
            self.removeSpinner()
        }
    }
    
    func prepareView(with weather: WeatherData, for city: String?) {
        if let city = city {
            self.city.text = city
        }
        shortDesc.text = "\(weather.current.weather.first?.main ?? "") (\(weather.current.weather.first?.weatherDescription ?? ""))"
        temp.text = "\(String(weather.current.temp.rounded(toPlaces: 1)))°"
        collectionView.reloadData()
        detailForecast.reloadData()
        weekForecastTable.reloadData()
        
        collectionViewContainer.addTopBorder(color: .lightGray, thickness: 1)
        collectionViewContainer.addBottomBorder(color: .lightGray, thickness: 1)
    }
    
    func recalculateSizes() {
        scrollViewTopOffset.constant = headerView.bounds.height + collectionView.bounds.height
        
        tableContainerHeight.constant = detailForecast.bounds.height + weekForecastTable.bounds.height + headerView.bounds.height + collectionView.bounds.height
    }
}

extension ViewController: UIScrollViewDelegate {
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

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case weekForecastTable:
            guard let dataCount = weatherData?.daily.count else { return 0 }
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
            guard let dailyData = weatherData?.daily else { return cell }
            cell.prepare(with: dailyData[indexPath.row])
            return cell
        case detailForecast:
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath) as! DetailsTableViewCell
            guard let detailsData = detailsData else { return cell }
            cell.prepare(title: detailsData[indexPath.row].key, subtitle: detailsData[indexPath.row].value)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
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

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.height / 2, height: collectionView.frame.height)
    }
}
