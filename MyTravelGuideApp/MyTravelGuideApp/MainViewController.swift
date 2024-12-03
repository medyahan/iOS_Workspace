//
//  MainViewController.swift
//  MyTravelGuideApp
//
//  Created by Medya Han on 3.12.2024.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var places: [Place] = []
    var filteredPlaces: [Place] = []
    
    var selectedrow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTableView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentedControl.selectedSegmentIndex = 0
        fetchData()
        filterPlaces()
    }
    
    // MARK: - Setup
    private func setupView() {
        title = "My Travel Guide"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPlace))
        setupSegmentedControl()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupSegmentedControl() {
        segmentedControl.removeAllSegments()
        
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: false)
        for (index, category) in PlaceCategory.allCases.enumerated() where category != .none {
            segmentedControl.insertSegment(withTitle: category.description, at: index, animated: false)
        }
        
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(categoryChanged), for: .valueChanged)
    }
    
    
    @objc private func categoryChanged() {
        filterPlaces()
    }
    
    private func filterPlaces() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        let selectedCategory = PlaceCategory.allCases[selectedIndex]
        
        if selectedIndex == 0 {
            filteredPlaces = places // Tüm yerleri göster
        } else {
            filteredPlaces = places.filter { $0.category == selectedCategory.rawValue }
        }
        tableView.reloadData()
    }
    
    // MARK: - Data Management
    private func fetchData() {
        do {
            places = try CoreDataManager.shared.fetchPlaces()
            filterPlaces() // Veriyi filtrele ve tabloyu güncelle
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func deletePlace(at index: Int) {
        let placeToDelete = filteredPlaces[index]
        
        do {
            try CoreDataManager.shared.deletePlace(placeToDelete)
            places.remove(at: index)
            tableView.reloadData()
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    // MARK: - Methods
    @objc private func addPlace() {
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailsViewController, let selectedrow = selectedrow {
            destinationVC.selectedPlace = filteredPlaces[selectedrow]
        }
    }
    
    // MARK: - Alert
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceCell", for: indexPath) as? PlaceCell else {
            return UITableViewCell()
        }
        
        let place = filteredPlaces[indexPath.row]
        cell.placeNameLabel.text = place.name
        
        if let creationDate = place.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            cell.creationDateLabel.text = dateFormatter.string(from: creationDate)
        } else {
            cell.creationDateLabel.text = "Unknown"
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedrow = indexPath.row
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePlace(at: indexPath.row)
        }
    }
    
}
