//
//  DetailsViewController.swift
//  MyTravelGuideApp
//
//  Created by Medya Han on 3.12.2024.
//

import UIKit
import MapKit

class DetailsViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeNoteLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var selectedPlace: Place?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        setupView()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        guard let selectedPlace else {
            print("Selected place is nil")
            return
        }
        
        placeNameLabel.text = selectedPlace.name
        placeNoteLabel.text = selectedPlace.note
        categoryLabel.text = "Category: \(PlaceCategory(rawValue: selectedPlace.category ?? "")?.description ?? "None")"
        
        setupMapAnnotation(for: selectedPlace)
        centerMapOnPlace(selectedPlace)
    }
    
    private func setupMapAnnotation(for place: Place) {
        let annotation = MKPointAnnotation()
        annotation.title = place.name
        annotation.subtitle = place.note
        annotation.coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        mapView.addAnnotation(annotation)
    }
    
    private func centerMapOnPlace(_ place: Place) {
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
        
        guard annotation is MKPointAnnotation else { return nil }
        
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        annotationView.canShowCallout = true
        annotationView.tintColor = .black
        let button = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = button
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        openPlaceInMaps()
    }
    
    @IBAction func goButtonClicked(_ sender: Any) {
        openPlaceInMaps()
    }
    
    private func openPlaceInMaps() {
        guard let selectedPlace = selectedPlace else {
            print("Selected place is nil")
            return
        }
        
        let requestLocation = CLLocation(latitude: selectedPlace.latitude, longitude: selectedPlace.longitude)
        
        CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
            if let error = error {
                print("Reverse geocoding failed: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: "Could not find location.")
                return
            }
            
            guard let firstPlacemark = placemarks?.first else {
                self.showAlert(title: "Error", message: "No location data found.")
                return
            }
            
            let newPlacemark = MKPlacemark(placemark: firstPlacemark)
            let item = MKMapItem(placemark: newPlacemark)
            item.name = selectedPlace.name
            let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
            
            item.openInMaps(launchOptions: launchOptions)
        }
    }
    
    // MARK: - Alerts
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
