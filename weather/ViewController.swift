//
//  ViewController.swift
//  weather
//
//  Created by Diana Tsarkova on 16.11.2020.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel = ViewModel()
    private let locationManager = CLLocationManager()
    // MARK: - Views
    private let locationLabel = UILabel()
    private let celciusLabel = UILabel()
    private let humidityLabel = UILabel()
    private let windSpeedLabel = UILabel()
    private let stateLabel = UILabel()
    private let iconImageView = UIImageView()
    // MARK: - Override Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background")
        view.addSubview(locationLabel)
        view.addSubview(celciusLabel)
        view.addSubview(humidityLabel)
        view.addSubview(iconImageView)
        view.addSubview(windSpeedLabel)
        view.addSubview(stateLabel)
        locationSetup()
        layoutConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        celciusLabel.font = UIFont.systemFont(ofSize: 26)
        locationLabel.font = UIFont.systemFont(ofSize: 16)
        humidityLabel.font = UIFont.systemFont(ofSize: 16)
        humidityLabel.textAlignment = .left
    }
}
// MARK: - Core Location
extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        NSLog("locations = \(locValue.latitude) \(locValue.longitude)")
        viewModel.grabWeatherData(lat: locValue.latitude, lon: locValue.longitude) { [weak self] weather in
            // Handle error
            guard let weather = weather else {
                let alert = UIAlertController(title: "Error", message: "Try again later", preferredStyle: .alert)
                self?.present(alert, animated: true) {
                    UIView.animate(withDuration: 1.5) {
                        alert.view.alpha = 0
                    }
                }
                return
            }
            // Setting up labels text
            DispatchQueue.main.async {
                self?.locationLabel.text = "Location: " + weather.name
                self?.celciusLabel.text = "Temperature: " + weather.main.temp.description + " °C"
                self?.humidityLabel.text = "Humidity: " + weather.main.humidity.description + " %"
                self?.windSpeedLabel.text = "Wind speed: " + weather.wind.speed.description + " meter/sec"
                self?.stateLabel.text = weather.weather.first?.main
            }
            // Getting icon of weather
            guard let iconId = weather.weather.first?.icon else { NSLog("Error: No first in weather array"); return }
            self?.viewModel.grabIcon(iconId: iconId) { image in
                DispatchQueue.main.async {
                    self?.iconImageView.image = image
                }
            }
        }
    }
}

// MARK: - Help Funcs
extension ViewController {
    private func locationSetup() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    private func layoutConstraints() {
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        celciusLabel.translatesAutoresizingMaskIntoConstraints = false
        humidityLabel.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        stateLabel.translatesAutoresizingMaskIntoConstraints = false
        windSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            iconImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            iconImageView.heightAnchor.constraint(equalToConstant: 48),
            iconImageView.widthAnchor.constraint(equalToConstant: 48),
            
            stateLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            stateLabel.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            
            celciusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            celciusLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 24),
            
            humidityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            humidityLabel.topAnchor.constraint(equalTo: celciusLabel.bottomAnchor, constant: 16),
            humidityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            locationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            locationLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 24),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            windSpeedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            windSpeedLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24),
            windSpeedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
