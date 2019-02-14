//
//  Hourly.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-01-24.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import Foundation

class Hourly: Decodable {
    
    var summary: String?
    var icon: String?
    var data: [HourData]?
    
}
