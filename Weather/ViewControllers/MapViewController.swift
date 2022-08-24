//
//  MapViewController.swift
//  Weather
//
//  Created by Александр Шерий on 21.08.2022.
//

import UIKit
import MapKit
import CoreData

protocol MapViewDelegate {
    func addLocation()
}

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    private var pointAnnotation: MKPointAnnotation? = nil
    private let getLocations = GetLocationsInteractor()
    private let addLocation = AddLocationInteractor()
    private var currentTitle = ""
    var delegate: MapViewDelegate? = nil
    
    override func viewDidLoad() {
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickOnMap))
        mapView.addGestureRecognizer(tapGestureRecognizer)
        
        getLocations.invoke()?.forEach {
            self.addAnnotation(at: $0)
        }
    }
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        showAddLocationAlert()
    }
    
    private func showAddLocationAlert() {
        guard let point = pointAnnotation else { return }

        let alert = UIAlertController(title: "location_title"~, message: nil, preferredStyle: .alert)
        alert.addTextField()
        if let textField = alert.textFields?.first {
            textField.font = UIFont(name: "System", size: 16)
            textField.autocapitalizationType = .sentences
            textField.text = currentTitle
        }
        alert.addAction(UIAlertAction(title: "ok"~, style: .default, handler: { action in
            if let textField = alert.textFields?.first {
                if let title = textField.text, !title.isEmpty {
                    self.addLocationImplAndClose(with: title, point: point)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "cancel"~, style: .cancel))
        present(alert, animated: true)
    }
    
    private func addLocationImplAndClose(with title: String, point: MKPointAnnotation) {
        self.addLocation.invoke(title: title, lat: point.coordinate.latitude, lon: point.coordinate.longitude)
        self.delegate?.addLocation()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clickOnMap(_ sender: UITapGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.ended { return }
        let touchLocation = sender.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { marks, error in
            if let city = marks?.first?.locality,
               let c = marks?.first?.isoCountryCode {
                self.currentTitle = "\(city), \(c)"
            }
        }
        
        if pointAnnotation != nil {
            pointAnnotation!.coordinate = locationCoordinate
        } else {
            pointAnnotation = MKPointAnnotation()
            pointAnnotation!.coordinate = locationCoordinate
            mapView.addAnnotation(
                pointAnnotation!
            )
        }
    }
    
    private func addAnnotation(at location: LocationModel) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: location.lat, longitude: location.lon)
        mapView.addAnnotation(annotation)
    }
}
