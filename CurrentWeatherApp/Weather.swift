//
//  Weather.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-01-23.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import Foundation

// This structure represents the encompassing object in the remote source data

struct Weather:Decodable {
    
    var latitude: Float?
    var longtitude: Float?
    var timezone: String?
    var currently: Currently?
    var hourly: Hourly?
    var offset: Float?
}
