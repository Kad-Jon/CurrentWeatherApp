//
//  HourData.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-01-24.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import Foundation

class HourData: Decodable {
    
    var time: Double?
    var summary: String?
    var icon: String?
    var temperature: Float?
    
}
