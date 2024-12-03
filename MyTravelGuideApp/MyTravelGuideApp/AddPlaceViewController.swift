//
//  AddPlaceViewController.swift
//  MyTravelGuideApp
//
//  Created by Medya Han on 3.12.2024.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class AddPlaceViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeNoteTextField: UITextField!
    @IBOutlet weak var categoryButton: UIButton!
    
    private var activeTextField: UITextField?
    
    var locationManager = CLLocationManager()
    var selectedLatitude: Double? = nil
    var selectedLongitude: Double? = nil
    
    var selectedCategory: PlaceCategory? = PlaceCategory.none
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        placeNameTextField.delegate = self
        placeNoteTextField.delegate = self
        
        setupNotificationObservers()
        setupLocationManager()
        setupRecognizer()
        setupCategoryButton()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupCategoryButton() {
        categoryButton.menu = createCategoryMenu()
        categoryButton.showsMenuAsPrimaryAction = true
    }
    
    // MARK: - Keyboard Management
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = activeTextField else { return }
        
        let topOfKeyboard = self.view.frame.height - keyboardFrame.height
        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
        let padding: CGFloat = 100.0
        
        if bottomOfTextField > topOfKeyboard {
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -(bottomOfTextField - topOfKeyboard + padding)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    // MARK: - Map Interaction
    
    @objc private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            if placeNameTextField.text?.isEmpty == true || placeNoteTextField.text?.isEmpty == true {
                showAlert(title: "Info", message: "Please fill in all fields first.")
                return
            }
            
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = placeNameTextField.text
            annotation.subtitle = placeNoteTextField.text
            mapView.addAnnotation(annotation)
            
            selectedLatitude = coordinate.latitude
            selectedLongitude = coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Category Menu
    
    private func createCategoryMenu() -> UIMenu {
        let actions = PlaceCategory.allCases.map { category in
            UIAction(title: category.description, handler: { _ in
                self.selectedCategory = category
                self.categoryButton.setTitle(category.description, for: .normal)
            })
        }
        return UIMenu(title: "Select Category", children: actions)
    }
    
    // MARK: - Add Place
    
    @IBAction private func addPlaceButtonClicked(_ sender: UIButton) {
        if placeNameTextField.text?.isEmpty ?? true {
            showAlert(title: "Error", message: "Please enter a place name.")
            return
        }
        
        if placeNoteTextField.text?.isEmpty ?? true {
            showAlert(title: "Error", message: "Please enter a note for the place.")
            return
        }
        
        if selectedLatitude == nil || selectedLongitude == nil {
            showAlert(title: "Error", message: "Please select a location on the map.")
            return
        }
        
        if selectedCategory == nil || selectedCategory == PlaceCategory.none {
            showAlert(title: "Error", message: "Please select a category.")
            return
        }
        
        createNewPlace()
    }
    
    private func createNewPlace() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Place", into: context)
        newPlace.setValue(UUID(), forKey: "id")
        newPlace.setValue(placeNameTextField.text, forKey: "name")
        newPlace.setValue(placeNoteTextField.text, forKey: "note")
        newPlace.setValue(selectedLatitude, forKey: "latitude")
        newPlace.setValue(selectedLongitude, forKey: "longitude")
        newPlace.setValue(Date(), forKey: "creationDate")
        newPlace.setValue(selectedCategory?.rawValue, forKey: "category")
        
        saveContext(context)
    }
    
    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            showAlert(title: "Error", message: "Something went wrong! Try again.")
        }
    }
    
    // MARK: - Alert
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
