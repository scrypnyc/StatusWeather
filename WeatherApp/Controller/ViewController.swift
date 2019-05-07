//
//  ViewController.swift
//  WeatherApp
//
//  Created by Alexander Skrypnyk on 4/23/19.
//  Copyright © 2019 skrypnyk. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var dayLabel: UILabel!
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var conditionLabel: UILabel!
  
  @IBOutlet weak var temperatureLabel: UILabel!
  @IBOutlet weak var backgroundView: UIView!
  
  
  
  let gradientLayer = CAGradientLayer()
  
  let apiKey = "762a34b466f8a3678e4f1717f1d9aaa2"
  var latitude = 2.33
  var longitude = 20.22
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.layer.addSublayer(gradientLayer)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setLightBackground()
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
  let location = locations[0]
    latitude = location.coordinate.latitude
    longitude = location.coordinate.longitude
  Alamofire.request("http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric").responseJSON { response in
      
  if let responseStr = response.result.value {
        let jsonResponse = JSON(responseStr)
        let jsonWeather = jsonResponse["weather"].array![0]
        let jsonTemp = jsonResponse["main"]
        let iconName = jsonWeather["icon"].stringValue
        
        self.locationLabel.text = jsonResponse["name"].stringValue
        self.imageView.image = UIImage(named: iconName)
        self.conditionLabel.text = jsonWeather["main"].stringValue
        self.temperatureLabel.text = "\(Int(round(jsonTemp["temp"].doubleValue)))"
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        self.dayLabel.text = dateFormatter.string(from: date)
        
        let suffix = iconName.suffix(1)
        if (suffix == "n") {
          self.setDarkBackground()
        } else {
          self.setLightBackground()
        }
      }
    }
    self.locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(error.localizedDescription)
  }
  
  func setLightBackground() {
    let topColor = UIColor.purple.cgColor
    let bottomColor = UIColor.purple.cgColor
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [topColor, bottomColor]
  }

  func setDarkBackground() {
    let topColor = UIColor.black.cgColor
    let bottomColor = UIColor.purple.cgColor
    gradientLayer.frame = view.bounds
    gradientLayer.colors = [topColor, bottomColor]
  }
}
