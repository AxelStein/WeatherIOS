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
        navigationItem.title = forecastData.date.dateText
        
        items = [ForecastDetailItem]()
        items.append(.temperature(value: forecastData.temp))
        if forecastData.precipitationProbability > 0 {
            items.append(.precipitationProbability(value: forecastData.precipitationProbability))
        }
        if forecastData.precipitation > 1 {
            items.append(.precipitation(value: forecastData.precipitation))
        }
        if forecastData.accumulatedSnowfall > 0 {
            items.append(.snow(value: forecastData.accumulatedSnowfall))
        }
        items.append(.wind(speed: forecastData.windSpeed, direction: forecastData.windDirection))
        items.append(.clouds(value: forecastData.averageCloudCoverage))
        if forecastData.averageRelativeHumidity > 0 {
            items.append(.humidity(value: forecastData.averageRelativeHumidity))
        }
        items.append(.visibility(value: forecastData.visibility))
        if forecastData.ultraVioletIndex > 0 {
            items.append(.ultravioletIndex(value: forecastData.ultraVioletIndex))
        }
        items.append(.pressure(value: forecastData.averagePressure))
        items.append(.sunrise(value: forecastData.sunrise))
        items.append(.sunset(value: forecastData.sunset))
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
