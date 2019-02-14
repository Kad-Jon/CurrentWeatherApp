//
//  ViewController.swift
//  CurrentWeatherApp
//
//  Created by XCodeClub on 2019-01-23.
//  Copyright © 2019 Kjonza. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    // MARK:- Properties
    
    // Location manager to access the users current location co-ordinates
    let locationManager = CLLocationManager()
    
    // Reference to the Data Model which will pass a Weather object which forecast will refer to and hour data object will pass to the collection view
    var model = WeatherModel()
    var forecast: Weather?
    var hours:[HourData]?
    
    // Miwand Skycon's skyconImageView to display the 'current' icon result
    let skyconImageView = SKYIconView(frame: CGRect(x: 0, y: 0, width: 160, height: 90))
    
    // Reference to search bar incase of need for control
    var searchBar:UISearchBar?
    
    // locationString will hold the placename of the forecast location, which starts off as users current location
    var locationString: String?
    
    // Boolean variable to let units control know which button is selected
    var fahrenheitIsSelected: Bool = true
    
    // Reference to weather theme colors
    var collectionViewTextColor:UIColor?
    var backgroundColor:UIColor?
    var textColor:UIColor?
    
    /* reference to resultSearchController (need to understand this) -- A view controller that manages display of search results depending on interaction with a search bar which exists in the root view controller. When interaction begins, the results view controller is display overtop the root view controller */
    var resultSearchController: UISearchController? = nil
    
    // MARK:-  IB Outlet properties
    
    // Label and image outlets for general weather forecast views
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    // Reference to UIButton objects for unit setting
    @IBOutlet weak var fahrenheit: UIButton!
    @IBOutlet weak var celsius: UIButton!
    
    
    // Detail Stack View Label Outlets
    @IBOutlet weak var precipProbabilityLabel: UILabel!
    @IBOutlet weak var precipIntensityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var uvIndexLabel: UILabel!
    
    //MARK:- UIViewController override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set view controller as delegate for the weather model protocol
        model.delegate = self
        
        // Set the view controller as location manager delegate, set accuracy to best and request permission before requestiing location. Permission need only be recieved once
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        // Set the background of the SKYCon image view to clear so it merges with the background
        skyconImageView.backgroundColor = UIColor.clear
        
        // Instantiate a view controller from the storyboard as the LocationSearchTable which is a custom TableViewController Class
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        
        /* Initialize a search controller with the locationSearchTable controller as its search results updater and refer to it with resultSearchController. Set the location Search Table as the delegate */
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.delegate = self
        
        // Refer to and configure the UISearchBar property in resultSearchController and place it in the scene as navigation Item
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for weather in..."
        searchBar.backgroundColor = UIColor.clear
        navigationItem.titleView = resultSearchController?.searchBar
        
        // Define presentation characteristics
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        
        // Customize the pseudo custom control for setting the units of temperature (start off as fahrenheight, thus celsius is dimmed)
        celsius.alpha = 0.3
        fahrenheit.setTitleColor(textColor, for: .normal)
        fahrenheit.setTitleColor(textColor, for: .selected)
    }
    
    //MARK:- View Controller Custom Methods
    
    // This function takes in a given forecast object and displays its data
    func setCurrentForecastUI() {
        
        // Call function to recieve local time in location of forecat in hh:mm form as a String
        let localTime = getLocalTime(unixTime: forecast!.currently!.time!, timezone: forecast!.timezone!)
        
        // Display data by passing them to the relevant labels
        locationLabel.text = locationString!
        timeLabel.text = "\(localTime) local time"
        setCurrentIcon()
        summaryLabel.text = forecast!.currently!.summary!
        precipProbabilityLabel.text = "Precipitation Probability: \(forecast!.currently!.precipProbability!)"
        precipIntensityLabel.text = "Precipitation Intensity: \(forecast!.currently!.precipIntensity!)"
        humidityLabel.text = "Humidity: \(forecast!.currently!.humidity!)"
        windSpeedLabel.text = "Wind Speed: \(forecast!.currently!.windSpeed!)"
        pressureLabel.text = "Pressure: \(forecast!.currently!.pressure!)"
        uvIndexLabel.text = "UV Index: \(forecast!.currently!.uvIndex!)"
        setTemp()
        
    }
    
    // Function that determines state of temperature unit control and displays the temperature accordingly
    func setTemp() {
        if fahrenheitIsSelected == true {
            temperatureLabel.text = "\(forecast!.currently!.temperature!)"
        } else if fahrenheitIsSelected == false {
            let tempF = forecast!.currently!.temperature!
            let tempC = (tempF - 32)*(5/9)
            temperatureLabel.text = String(format: "%.2f", tempC)
        }
    }
    
    // Function to instiate the relevant Skycon depending on the API icon result
    func setCurrentIcon() {
        
        if forecast!.currently!.icon! == "clear-day" {
            skyconImageView.setType = .clearDay
            backgroundColor = UIColor.blue
            textColor = UIColor.white
            
        } else if forecast!.currently!.icon! == "clear-night" {
            skyconImageView.setType = .clearNight
            backgroundColor = UIColor.purple
            textColor = UIColor.yellow
            
        } else if forecast!.currently!.icon! == "rain" {
            skyconImageView.setType = .rain
            backgroundColor = UIColor.lightGray
            textColor = UIColor.blue
            
        } else if forecast!.currently!.icon! == "sleet" {
            skyconImageView.setType = .sleet
            backgroundColor = UIColor.lightGray
            textColor = UIColor.cyan
            
        } else if forecast!.currently!.icon! == "wind" {
            skyconImageView.setType = .wind
            backgroundColor = UIColor.lightGray
            textColor = UIColor.black
            
        } else if forecast!.currently!.icon! == "fog" {
            skyconImageView.setType = .fog
            backgroundColor = UIColor.lightGray
            backgroundColor = UIColor.white
            
        } else if forecast!.currently!.icon! == "cloudy" {
            skyconImageView.setType = .cloudy
            backgroundColor = UIColor.lightGray
            textColor = UIColor.black
            
        } else if forecast!.currently!.icon! == "partly-cloudy-day" {
            skyconImageView.setType = .partlyCloudyDay
            backgroundColor = UIColor.lightGray
            textColor = UIColor.black
            
        } else if forecast!.currently!.icon! == "partly-cloudy-night" {
            skyconImageView.setType = .partlyCloudyNight
            backgroundColor = UIColor.purple
            textColor = UIColor.yellow
            
            
        } else if forecast!.currently!.icon! == "snow" {
            skyconImageView.setType = .snow
            backgroundColor = UIColor.cyan
            textColor = UIColor.white
            
        }
        
        // Call the setColors fn to set the theme and then append the skyconview
        setColors(foreground: textColor!, background: backgroundColor!)
        iconImageView.addSubview(skyconImageView)
        
    }
    
    // Function that takes in unixTime and generic timezone string to produce local time in hh:mm format
    func getLocalTime(unixTime: Double, timezone: String) -> String {
        let date = Date(timeIntervalSince1970: unixTime)
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(identifier: timezone)
        
        return formatter.string(from: date)
    }
    
    // Function that sets the foreground and background colors or the scene
    func setColors(foreground: UIColor, background: UIColor) {
        
        // Set the label colors in the header stack views
        temperatureLabel.textColor = foreground
        summaryLabel.textColor = foreground
        locationLabel.textColor = foreground
        timeLabel.textColor = foreground
        
        // Set the label text colors in the detail stack view
        precipIntensityLabel.textColor = foreground
        precipProbabilityLabel.textColor = foreground
        humidityLabel.textColor = foreground
        windSpeedLabel.textColor = foreground
        pressureLabel.textColor = foreground
        uvIndexLabel.textColor = foreground
        fahrenheit.titleLabel!.textColor = foreground
        celsius.titleLabel!.textColor = foreground
        
        skyconImageView.setColor = foreground
        
        backgroundImageView.backgroundColor = background
    }
    
    // MARK:- IBAction Methods
    
    @IBAction func fahrenheitTapped(_ sender: UIButton) {
        
        // When fahrenheit is tapped, check if it is already selected, if so, do nothing. If not, then fade out the fahrenheit control and fade in the celsius button, making clear which control is selected and vice versa
        
        if fahrenheitIsSelected == true {
            return
        } else if fahrenheitIsSelected == false {
            // Make fahrenheit selected and celsisus unselected, reload temp label and collectionview cells
            fahrenheit.alpha = 1
            celsius.alpha = 0.3
            fahrenheitIsSelected = true
            setTemp()
            collectionView.reloadData()
        }
        
    }
    
    // Like the above function but in reverse
    @IBAction func celsiusTapped(_ sender: UIButton) {
        
        if fahrenheitIsSelected == true {
            fahrenheit.alpha = 0.3
            celsius.alpha = 1
            fahrenheitIsSelected = false
            setTemp()
            collectionView.reloadData()
            
        } else if fahrenheitIsSelected == false {
            return
        }
    }
    
}

// Delegate methods for the WeatherModelProtocol
extension ViewController: WeatherModelProtocol {
    
    // This method fires once a forecast has been successfully retrieved from DarkSky
    func forecastRetrieved(_ forecast: Weather) {
        // Store the retrieved forecast as a property
        self.forecast = forecast
        // Display the data from the forecast object
        setCurrentForecastUI()
        
        // Once data has arrived, it is now appropriatte to set the controller as the collectionview data source and delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // If the collectionview is displaying old data, a reload will clear and replace it with the new data
        collectionView.reloadData()
        
        // Make the collection view visible after hiding the transition process from forecasts
        collectionView.alpha = 1
        
        // Mask the more complicated state effects and animations by merging the colors for states with the colors of the overall theme
        fahrenheit.setTitleColor(textColor, for: .normal)
        fahrenheit.setTitleColor(textColor, for: .selected)
        celsius.setTitleColor(textColor, for: .normal)
        celsius.setTitleColor(textColor, for: .selected)
    }
}

// Delegate methods for CLLocation manager

extension ViewController: CLLocationManagerDelegate {
    
    // Methods gets called when the user responds to the permission dialog, if allowed by the user, a location request is sent of
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    // Method that gets called when the location request comes back, returning an array of locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("location: \(location)")
            locationString = "Your current location"
            
            
            model.getWeather(locationManager.location!.coordinate.latitude, locationManager.location!.coordinate.longitude)
            
        }
    }
    
    // Method to return an error message
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:\(error)")
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourDataCell", for: indexPath) as? HourCollectionViewCell
        cell!.timeZoneIdentifier = forecast!.timezone!
        cell!.data = forecast!.hourly!.data![indexPath.row]
        cell!.fahrenheitIsSelected = self.fahrenheitIsSelected
        cell?.setUI()
        cell?.setColor(color: textColor!)
        return cell!
    }
    
    
}

extension ViewController: LocationSearchDelegate {
    
    func remoteLocationRetrieved(location: MKMapItem) {
        locationString = location.name
        model.getWeather(location.placemark.location?.coordinate.latitude, location.placemark.location?.coordinate.longitude)
        collectionView.alpha = 0
        
    }
    
}


