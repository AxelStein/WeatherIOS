//
//  ForecastDetailViewController.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit

class ForecastDetailViewController: UITableViewController {
    private var items: [ForecastDetailItem]!
    
    var forecastData: ForecastData!
    
    override func viewDidLoad() {
        items = [ForecastDetailItem]()
        items.append(.temperature(value: forecastData.temp))
        items.append(.wind(speed: forecastData.wind_spd, direction: forecastData.wind_cdir))
        if forecastData.pop > 0 {
            items.append(.precipitation(value: forecastData.pop))
        }
        items.append(.clouds(value: forecastData.clouds))
        items.append(.humidity(value: forecastData.rh))
        if forecastData.snow > 0 {
            items.append(.snow(value: forecastData.snow))
        }
        items.append(.sunrise(value: forecastData.sunriseDate))
        items.append(.sunset(value: forecastData.sunsetDate))
        
        print(forecastData.sunriseDate)
        print(forecastData.sunsetDate)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastDetailItemCell", for: indexPath) as! ForecastDetailItemCell
        cell.setItem(items[indexPath.row])
        return cell
    }
}
