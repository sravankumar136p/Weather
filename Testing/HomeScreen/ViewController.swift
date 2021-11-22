//
//  ViewController.swift
//  Testing
//
//  Created by Arun Cheela on 11/11/21.
//

import UIKit
import MapKit
import CoreLocation

struct Location {
    let title: String
    let latitude: Double
    let longitude: Double
}

class ViewController: UIViewController, UISearchBarDelegate, MKLocalSearchCompleterDelegate ,MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet weak var mapkit_View: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    fileprivate var annotation: MKAnnotation!
    fileprivate var locationManager: CLLocationManager!
    fileprivate var isCurrentLocation: Bool = false
    var location: [Location] = []
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var latitude = ""
    var longitude = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setMapDelegateMethod()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.mapkit_View.addGestureRecognizer(tap)
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    func setMapDelegateMethod()  {
        self.mapkit_View.delegate = self
        self.mapkit_View.mapType = .hybrid
        self.searchCompleter.delegate = self
        self.searchBar?.delegate = self
        self.searchResultsTable?.delegate = self
        self.searchResultsTable?.dataSource = self
        let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap))
        mapkit_View.addGestureRecognizer(longTapGesture)
    }
    @objc func longTap(sender: UIGestureRecognizer){
        print("long tap")
        if sender.state == .began {
            let locationInView = sender.location(in: mapkit_View)
            let locationOnMap = mapkit_View.convert(locationInView, toCoordinateFrom: mapkit_View)
            addAnnotation(location: locationOnMap)
        }
    }

    func addAnnotation(location: CLLocationCoordinate2D){
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
           
        let locationData = Location(title: " Some Title", latitude: location.latitude, longitude: location.longitude)
        self.location.append(locationData)
        self.addAnnotation()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        mapkit_View.isHidden = true
        searchResults = completer.results
        searchResultsTable.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if !isCurrentLocation {
            return
        }
        
        isCurrentLocation = false
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
        {
            if let annotationTitle = view.annotation?.title
            {
                print(view.annotation?.coordinate as Any)
                print("User tapped on annotation with title: \(annotationTitle!)")
                let longitudedouble = view.annotation?.coordinate.longitude
                let latitudeDouble = view.annotation?.coordinate.latitude

                self.latitude = latitudeDouble!.string
                self.longitude = longitudedouble!.string
                let titleString  = view.annotation?.title
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let wheatherDataVC = storyBoard.instantiateViewController(withIdentifier: "LocationDataVC") as? LocationDataVC
                wheatherDataVC?.lat = self.latitude
                wheatherDataVC?.lng = self.longitude
                wheatherDataVC?.cityName = (titleString ?? "") ?? ""
                self.navigationController?.pushViewController(wheatherDataVC!, animated: true)
            }
        }

    func addAnnotation()  {
        for location in self.location {
            let annotation = MKPointAnnotation()
            annotation.title = location.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            self.mapkit_View.centerCoordinate = annotation.coordinate
            self.mapkit_View.addAnnotation(annotation)
        }
    }

}

// Setting up extensions for the table view

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: result)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            print(name)
            
            self.mapkit_View.isHidden = false
            self.longitude = String(coordinate.longitude)
            self.latitude = String(coordinate.latitude)

            let locationData = Location(title: name, latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.location.append(locationData)
            self.addAnnotation()
            self.view.endEditing(true)

        }
    }
}


extension LosslessStringConvertible {
    var string: String { .init(self) }
}
