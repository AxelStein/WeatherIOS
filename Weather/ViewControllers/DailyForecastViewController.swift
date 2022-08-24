//
//  DailyForecastViewController.swift
//  Weather
//
//  Created by Александр Шерий on 20.08.2022.
//

import UIKit
import CoreData

class DailyForecastViewController: UITableViewController, LocationsDelegate {
    private let getLocations = GetLocationsInteractor()
    private let getForecast = GetForecastInteractor()
    
    private var loadingAlert: UIAlertController? = nil
    private var currentWeather: CurrentWeather?
    private var dailyForecast: DailyForecast?
    private var errorView: ErrorMessageView? = nil
    private var currentLocation: LocationModel? = nil
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        guard let app = UIApplication.shared.delegate as? AppDelegate else { fatalError() }
        container = app.persistentContainer
        
        if let location = getLocations.invoke()?.first {
            self.setCurrentLocation(location)
        }
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refreshData(refreshControl: UIRefreshControl) {
        if let currentLocation = currentLocation {
            fetchForecast(at: currentLocation, showAlert: false)
        } else {
            refreshControl.endRefreshing()
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
        return "\(count)\("n_day_forecast"~)"
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
    
    func setCurrentLocation(_ location: LocationModel) {
        currentLocation = location
        navigationItem.title = location.title
        fetchForecast(at: location)
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
    
    func fetchForecast(at location: LocationModel, showAlert: Bool = true) {
        if showAlert {
            self.loadingAlert = showActivityIndicatorAlert()
        }
        
        getForecast.invoke(location: location) { result in
            self.loadingAlert?.dismiss(animated: false)
            self.loadingAlert = nil
            self.tableView.refreshControl?.endRefreshing()
            
            switch result {
            case .success(let forecast):
                self.hideErrorMessgae()
                self.currentWeather = forecast.0
                self.dailyForecast = forecast.1
                
            case .failure(let error):
                self.currentWeather = nil
                self.dailyForecast = nil
                
                if let dataLoaderError = error as? DataLoaderError {
                    switch dataLoaderError {
                    case .invalidURL:
                        self.showErrorMessage("Invalid URL")
                    case .network(let e):
                        self.showErrorMessage(e?.localizedDescription ?? "Network error")
                    }
                } else if let apiError = error as? ApiError {
                    self.showErrorMessage(apiError.statusMessage)
                } else {
                    self.showErrorMessage(error.localizedDescription)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func showErrorMessage(_ message: String) {
        if errorView == nil {
            let guide = view.safeAreaLayoutGuide
            let width = guide.layoutFrame.size.width
            let height = guide.layoutFrame.size.height
            
            errorView = ErrorMessageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
            self.view.addSubview(errorView!)
        }
        if let errorView = self.errorView {
            errorView.messageLabel.text = message
        }
    }
    
    func hideErrorMessgae() {
        self.errorView?.removeFromSuperview()
        self.errorView = nil
    }
}
