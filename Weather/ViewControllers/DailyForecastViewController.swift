//
//  DailyForecastViewController.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class DailyForecastViewController: UITableViewController {
    private let getDailyForecast = GetDailyForecastInteractor()
    private let locationLutsk = Location(lat: 50.7482711757513, lon: 25.329339998846542)
    private var dailyForecast: DailyForecast?
    
    override func viewDidLoad() {
        fetchDailyForecast(at: locationLutsk)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return dailyForecast != nil ? 2 : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return dailyForecast!.data.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Current weather"
        }
        let count = dailyForecast != nil ? dailyForecast!.data.count : 0
        return "\(count)-day forecast"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeatherTableViewCell", for: indexPath) as! CurrentWeatherTableViewCell
            if let dailyForecast = dailyForecast {
                cell.setForecast(dailyForecast)
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DayForecastTableViewCell", for: indexPath) as! DayForecastTableViewCell
        if let dailyForecast = dailyForecast {
            let forecast = dailyForecast.data[indexPath.row]
            cell.setForecast(forecast)
        }
        return cell
    }
}

extension DailyForecastViewController {
    
    func fetchDailyForecast(at location: Location) {
        getDailyForecast.invoke(location: location) { dailyForecast in
            self.dailyForecast = dailyForecast
            self.tableView.reloadData()
        }
    }
}
