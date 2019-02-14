//
//  WeatherModel.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-01-23.
//  Copyright © 2019 Kjonza. All rights reserved.
//

/*
 
 Things to do:
 - Build basic interface to load up any given forecast request weather details
 - Find out how to integrate skycons project file to starts using SKYIcon view objects
 - Integrate a search bar which returns a list of locations using the native Apple MapKit API
 
In short what I want from the interface is detailed current weather conditions with summary, icon and temperature as the main data parts and perhaps a load of other peripheral ones 
 
 */

import Foundation

protocol WeatherModelProtocol {
    func forecastRetrieved(_ forecast:Weather)
}

class WeatherModel {
    
    var delegate:WeatherModelProtocol?
    
    func getWeather(_ latitude: Double!,_ longtitude: Double!) {
        
        if latitude == nil && longtitude == nil {
            return
        }
        
        print("\(latitude!),\(longtitude!)")
        
        // Construct a string url
        
        let stringUrl = "https://api.darksky.net/forecast/29e8abf4c1f09ca0908010d851868321/\(latitude!),\(longtitude!)?exclude=minutely,daily,alerts,flags"
        
        // Create a url object and check that it is not nil
        
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
                    
                    // Return to the main thread using dispatch queue
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
