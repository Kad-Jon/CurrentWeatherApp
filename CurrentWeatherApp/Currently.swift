//
//  Currently.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-01-23.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import Foundation

// This structure represents the currently object in the data call

struct Currently: Decodable {
    
    var time: Double?
    var summary: String?
    var icon: String?
    var precipIntensity: Float?
    var precipProbability: Float?
    var temperature: Float?
    var humidity: Float?
    var windSpeed: Float?
    var pressure: Float?
    var uvIndex: Float?
    
}
