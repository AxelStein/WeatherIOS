//
//  DailyForecastViewController.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class DailyForecastViewController: UITableViewController, LocationsDelegate {
    private let getLocations = GetLocationsInteractor()
    private let getCurrentWeather = GetCurrentWeatherInteractor()
    private let getDailyForecast = GetDailyForecastInteractor()
    
    private var loadingAlert: UIAlertController? = nil
    private var currentWeather: CurrentWeather?
    private var dailyForecast: DailyForecast?
    
    override func viewDidLoad() {
        if let location = getLocations.invoke().first {
            setCurrentLocation(location)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dailyForecast != nil ? 2 : 0
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 {
            return nil
        }
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dailyForecast!.data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return ""
        }
        let count = dailyForecast?.data.count ?? 0
        return "\(count)-day forecast"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showForecastDetail" {
            let vc = segue.destination as! ForecastDetailViewController
            guard let index = tableView.indexPathForSelectedRow else { return }
            vc.forecastData = dailyForecast?.data[index.row]
        }
        if segue.identifier == "showLocations" {
            let vc = segue.destination as! LocationsViewController
            vc.delegate = self
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherTableViewCell", for: indexPath) as! CurrentWeatherTableViewCell
            if let currentWeather = currentWeather {
                cell.setCurrentWeather(currentWeather)
            }
            cell.hideSeparator()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayForecastTableViewCell", for: indexPath) as! DayForecastTableViewCell
        let forecast = dailyForecast!.data[indexPath.row]
        cell.setForecast(forecast)
        cell.showSeparator()
        return cell
    }
    
    func setCurrentLocation(_ location: Location) {
        fetchCurrentWeather(at: location)
    }
}

extension UITableViewCell {
    func hideSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
    }

    func showSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

extension DailyForecastViewController {
    
    func fetchCurrentWeather(at location: Location) {
        self.loadingAlert = showActivityIndicatorAlert()
        
        getCurrentWeather.invoke(location: location) { weather in
            self.currentWeather = weather
            self.fetchDailyForecast(at: location)
        }
    }
    
    func fetchDailyForecast(at location: Location) {
        getDailyForecast.invoke(location: location) { dailyForecast in
            self.loadingAlert?.dismiss(animated: true)
            
            self.dailyForecast = dailyForecast
            self.navigationItem.title = dailyForecast?.cityName
            self.tableView.reloadData()
        }
    }
}
