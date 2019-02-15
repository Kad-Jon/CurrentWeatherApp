//
//  WeatherModel.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-01-23.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import Foundation

// Declare the weather model protcol and required delegate method
protocol WeatherModelProtocol {
    
    // method for delegate to handle a retrieved weather forecast
    func forecastRetrieved(_ forecast:Weather)
}

class WeatherModel {
    
    // Delegate property
    var delegate:WeatherModelProtocol?
    
    // This function constructs an API call using the passed co-ordinates, and retrieves a forecast object. Once retrieved the delegate method is called to allow the delegate to handle the retrieved forecast object
    
    func getWeather(_ latitude: Double!,_ longtitude: Double!) {
        
        // Construct a string url using passed co-ordinates, in accordance with DarkSky's documentation. The exclude excludes all undesired data from the call
        
        let stringUrl = "https://api.darksky.net/forecast/29e8abf4c1f09ca0908010d851868321/\(latitude!),\(longtitude!)?exclude=minutely,daily,alerts,flags"
        
        // Initialize a url object using stringUrl and check that it is not nil
        
        let url = URL(string: stringUrl)
        
        guard url != nil else {
            print("Could not create url object")
            return
        }
        
        // Create a URL session object
        
        let urlSession = URLSession.shared
        
        // Create a dataTask
        
        let dataTask = urlSession.dataTask(with: url!) { (data, response, error) in
            
            // Check that there is no error and that there is data
            
            if error == nil && data != nil {
            
                // Attempt to decode json data object into structure type in a do-catch block as decode method throws
                
                do {
                    
                    // Declare the decoder
                    let decoder = JSONDecoder()
                    
                    // Attempt to decode the data into a weather struct and assign it to result
                    let result = try decoder.decode(Weather.self, from: data!)
                    
                    // Return to the main thread using dispatch queue and call forecatsRetrieved method
                    DispatchQueue.main.async {
                        self.delegate?.forecastRetrieved(result)
                    }
                }
                catch {
                    print("Shit fucked up")
                } // End of do catch block
            } // End of if
        } // End of data task
        
        dataTask.resume()
    } // End of get forecast method
} // End of weather model class
