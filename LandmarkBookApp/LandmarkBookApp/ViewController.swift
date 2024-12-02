//
//  ViewController.swift
//  LandmarkBookApp
//
//  Created by Medya Han on 1.12.2024.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedRow: Int?
    var landmarks = [
        Landmark(name: "Eiffel Tower", imageName: "eiffel", description: "in Paris, France"),
        Landmark(name: "Great Wall", imageName: "greatwall", description: "in Beijing, China"),
        Landmark(name: "Colosseum", imageName: "colosseum", description: "in Rome, Italy"),
        Landmark(name: "Statue of Liberty", imageName: "liberty", description: "in New York, USA"),
        Landmark(name: "Pyramids of Giza", imageName: "pyramids", description: "in Egypt")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = landmarks[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.landmarks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailsViewController {
            destination.selectedLandmark = landmarks[selectedRow!]
        }
    }
    
}

