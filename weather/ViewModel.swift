//
//  ViewModel.swift
//  weather
//
//  Created by Diana Tsarkova on 17.11.2020.
//

import UIKit

class ViewModel {
    // MARK: - Private Props
    private let apiKey = "4dff56926e33371e08826b75d9bfa000"
    
    func grabWeatherData(lat: Double, lon: Double, onResponse: @escaping (Weather?) -> Void) {
        
        let baseURLString = "http://api.openweathermap.org/data/2.5/"
        let additionalString = "weather?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)"
        let allInAllString = baseURLString + additionalString
        
        guard let url = URL(string: allInAllString) else { onResponse(nil); return }
        
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                NSLog(error?.localizedDescription ?? "no description for error provided!\n")
                return
            }
            
            guard let data = data else { return }
            
            if let weather = try? JSONDecoder().decode(Weather.self, from: data) {
                onResponse(weather)
            }
            
        }
        
        task.resume()
    }
    
    func grabIcon(iconId: String, onResponse: @escaping (UIImage?) -> Void) {
        let urlString = "http://openweathermap.org/img/wn/\(iconId)@2x.png"
        
        guard let url = URL(string: urlString) else { onResponse(nil); return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                NSLog(error?.localizedDescription ?? "")
                return
            }
            DispatchQueue.main.async {
                onResponse(UIImage(data: data))
            }
        }
        task.resume()
    }
}
