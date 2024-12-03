//
//  ViewController.swift
//  ArtBookApp
//
//  Created by Medya Han on 2.12.2024.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow: Int?
    var arts: [Art] = []
    
    var filteredArts: [Art] = []
    var isFiltering: Bool = false
    
    var selectedCriteria: SortCriteria?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup Methods
    private func setupView() {
        setupTableView()
        setupSearchBar()
        setupNavigationBar()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupSearchBar() {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.title = "Art Book"
        
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: self, action: #selector(showSortMenu))
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped)),
            sortButton
        ]
    }
    
    // MARK: - Data Management
    private func fetchData() {
        do {
            arts = try CoreDataManager.shared.fetchArts()
            sortArts(by: selectedCriteria ?? .creationDate)
            tableView.reloadData()
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    private func deleteArt(at index: Int) {
        let artToDelete = isFiltering ? filteredArts[index] : arts[index]
        
        do {
            try CoreDataManager.shared.deleteArt(artToDelete)
            if isFiltering {
                filteredArts.remove(at: index)
            } else {
                arts.remove(at: index)
            }
            tableView.reloadData()
        } catch {
            showAlert(title: "Error", message: error.localizedDescription)
        }
    }
    
    // MARK: - Sorting
    @objc private func showSortMenu() {
        let alert = UIAlertController(
            title: "Sort Options",
            message: "Choose how you want to sort the art pieces:",
            preferredStyle: .actionSheet
        )
        
        // Alphabetical sort by name
        let nameAction = UIAlertAction(
            title: "By Name (A-Z)",
            style: .default
        ) { _ in
            self.sortArts(by: .name)
        }
        
        // Sort by creation order
        let creationAction = UIAlertAction(
            title: "By Creation Date (Newest First)",
            style: .default
        ) { _ in
            self.sortArts(by: .creationDate)
        }
        
        // Sort by year
        let yearAction = UIAlertAction(
            title: "By Year (Ascending)",
            style: .default
        ) { _ in
            self.sortArts(by: .year)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(nameAction)
        alert.addAction(creationAction)
        alert.addAction(yearAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    
    private func sortArts(by criteria: SortCriteria) {
        selectedCriteria = criteria
        
        if isFiltering {
            filteredArts.sort { criteria.compare($0, $1) }
        } else {
            arts.sort { criteria.compare($0, $1) }
        }
        tableView.reloadData()
    }
    
    // MARK: - Navigation
    @objc private func addButtonTapped() {
        performSegue(withIdentifier: "toAddArtVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsViewController,
           let selectedRow = selectedRow {
            destination.selectedArt = isFiltering ? filteredArts[selectedRow] : arts[selectedRow]
        }
    }
    
    // MARK: - Alerts
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredArts.count : arts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtCell", for: indexPath) as? ArtCell else {
            return UITableViewCell()
        }
        
        let art = isFiltering ? filteredArts[indexPath.row] : arts[indexPath.row]
        
        cell.artNameLabel.text = art.name
        
        if let creationDate = art.creationDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            cell.creationDateLabel.text = "Created: \(dateFormatter.string(from: creationDate))"
        } else {
            cell.creationDateLabel.text = "Created: Unknown"
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteArt(at: indexPath.row)
        }
    }
}

// MARK: - UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            isFiltering = false
        } else {
            isFiltering = true
            filteredArts = arts.filter { $0.name?.lowercased().contains(searchText.lowercased()) ?? false }
        }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isFiltering = false
        searchBar.text = ""
        tableView.reloadData()
    }
}

