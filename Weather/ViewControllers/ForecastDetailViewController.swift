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
        navigationItem.title = forecastData.validDate?.dateText
        
        items = [ForecastDetailItem]()
        items.append(.temperature(value: forecastData.temp))
        if forecastData.pop ?? 0 > 0 {
            items.append(.precipitationProbability(value: forecastData.pop ?? 0))
        }
        if forecastData.precip ?? 0 > 1 {
            items.append(.precipitation(value: forecastData.precip ?? 0))
        }
        if forecastData.snow ?? 0 > 0 {
            items.append(.snow(value: forecastData.snow ?? 0))
        }
        items.append(.wind(speed: forecastData.windSpd, direction: forecastData.windCdir))
        items.append(.clouds(value: forecastData.clouds))
        if forecastData.rh ?? 0 > 0 {
            items.append(.humidity(value: forecastData.rh ?? 0))
        }
        items.append(.visibility(value: forecastData.vis))
        if forecastData.uv > 0 {
            items.append(.ultravioletIndex(value: forecastData.uv))
        }
        items.append(.pressure(value: forecastData.pres))
        items.append(.sunrise(value: forecastData.sunriseDate))
        items.append(.sunset(value: forecastData.sunsetDate))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastSummaryItemCell", for: indexPath) as! ForecastSummaryItemCell
            cell.setForecastData(forecastData)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastDetailItemCell", for: indexPath) as! ForecastDetailItemCell
        cell.setItem(items[indexPath.row])
        return cell
    }
}
