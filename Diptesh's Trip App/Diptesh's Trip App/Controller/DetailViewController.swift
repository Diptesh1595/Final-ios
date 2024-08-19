

import UIKit
import MapKit

class DetailViewController: UIViewController, WeatherManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var destinationLbl: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var trip: TripModel?
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .black
        
        weatherManager.delegate = self
        weatherManager.fetchWeather(cityName: trip?.destination ?? "")
        mapView.delegate = self
        
        tripNameLabel.text = "Trip Name: " + (trip?.title ?? "")
        destinationLbl.text = "Destination: \(trip?.destination ?? "")"
        originLbl.text = "Origin: \(trip?.originLocation ?? "")"
        dateLabel.text = "Start Date: \(formate(date: trip?.startDate ?? Date())) • End Date: \(formate(date: trip?.endDate ?? Date()))"
        
        showLocationsAndDistance(origin: trip?.originLocation ?? "", destination: trip?.destination ?? "")
    }
    
    @IBAction func addExpense(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddExpenseViewController") as! AddExpenseViewController
        vc.trip = trip
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { [self] in
            degreeLabel.text = "Degree: " + weather.temperatureString
            humidityLabel.text = "Humidity: \(weather.humidity)"
            windSpeedLabel.text = "Wind speed: \(weather.windSpeed)"
        }
    }
    
    func didFailWithError(error: Error) {
        self.showAlert(title: "Error", message: "Failed to fetch weather data at trip's destination.")
    }
    
    func showLocationsAndDistance(origin: String, destination: String) {
        let group = DispatchGroup()
        var originLocation: MKPlacemark?
        var destinationLocation: MKPlacemark?
        
        group.enter()
        searchLocation(byName: origin) { placemark in
            originLocation = placemark
            group.leave()
        }
        
        group.enter()
        searchLocation(byName: destination) { placemark in
            destinationLocation = placemark
            group.leave()
        }
        
        group.notify(queue: .main) {
            guard let location1 = originLocation, let location2 = destinationLocation else {
                self.showAlert(title: "Error", message: "Location could not be found")
                return
            }
            
            self.showSingleLocation(location: location2)
        }
    }
    
    func searchLocation(byName name: String, completion: @escaping (MKPlacemark?) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = name
        
        let localSearch = MKLocalSearch(request: searchRequest)
        localSearch.start { (response, error) in
            guard let response = response, let mapItem = response.mapItems.first else {
                print("Error searching for location: \(String(describing: error?.localizedDescription))")
                completion(nil)
                return
            }
            completion(mapItem.placemark)
        }
    }
    
    func showSingleLocation(location: MKPlacemark) {
        let annotation = MKPointAnnotation()
        annotation.title = location.name
        annotation.coordinate = location.coordinate
        
        mapView.showAnnotations([annotation], animated: true)
        
        let region = MKCoordinateRegion(center: annotation.coordinate,
                                        latitudinalMeters: 10000,
                                        longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
    }
}
