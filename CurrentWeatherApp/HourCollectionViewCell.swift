//
//  HourCollectionViewCell.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-02-06.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import UIKit

class HourCollectionViewCell: UICollectionViewCell {
    
    // Reference to views in prototype cell
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    
    // Instantiate and position SKYIconView
    let skyconImageView = SKYIconView(frame: CGRect(x: -15, y: -15, width: 40, height: 48))
    
    // Property to hold HourData object, timezone and temperature unit selection status
    var data:HourData?
    var timeZoneIdentifier: String?
    var fahrenheitIsSelected = true
    
    // Method to set label texts
    func setUI() {
        
        iconImageView.addSubview(skyconImageView)
        timeLabel.text = getLocalTime(unixTime: data!.time!, timezone: timeZoneIdentifier!)
        setTemp()
        setIcon()
    }
    
    // Method to set temperature in either celsius or fahrenheit, depending on status
    func setTemp() {
        if fahrenheitIsSelected == true {
            tempLabel.text = "\(data!.temperature!)"
        } else if fahrenheitIsSelected == false {
            let tempF = data!.temperature!
            let tempC = (tempF - 32)*(5/9)
            tempLabel.text = String(format: "%.2f", tempC)
        }
    }
    
    // Function takes in unix time from API and converts it into hh time
    func getLocalTime(unixTime: Double, timezone: String) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh a"
        formatter.timeZone = TimeZone(identifier: timeZoneIdentifier!)
        
        return formatter.string(from: date)
    }
    
    // method sets skycon stype depending on forecast icon property
    func setIcon() {
        
        
        skyconImageView.setColor = UIColor.white
        skyconImageView.backgroundColor = UIColor.clear
        
        if data!.icon! == "clear-day" {
            skyconImageView.setType = .clearDay
        } else if data!.icon! == "clear-night" {
            skyconImageView.setType = .clearNight
        } else if data!.icon! == "rain" {
            skyconImageView.setType = .rain
        } else if data!.icon! == "sleet" {
            skyconImageView.setType = .sleet
        } else if data!.icon! == "wind" {
            skyconImageView.setType = .wind
        } else if data!.icon! == "fog" {
            skyconImageView.setType = .fog
        } else if data!.icon! == "cloudy" {
            skyconImageView.setType = .cloudy
        } else if data!.icon! == "partly-cloudy-day" {
            skyconImageView.setType = .partlyCloudyDay
        } else if data!.icon! == "partly-cloudy-night" {
            skyconImageView.setType = .partlyCloudyNight
        } else if data!.icon! == "snow" {
            skyconImageView.setType = .snow
        }
        
        skyconImageView.refresh()
        
    }
    
    // method to set colors of foreground (the bakground is clear colored)
    func setColor(color: UIColor) {
        tempLabel.textColor = color
        timeLabel.textColor = color
        skyconImageView.setColor = color
    }
}
