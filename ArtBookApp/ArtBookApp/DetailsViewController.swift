//
//  DetailsViewController.swift
//  ArtBookApp
//
//  Created by Medya Han on 2.12.2024.
//

import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailArtistLabel: UILabel!
    @IBOutlet weak var detailYearLabel: UILabel!
    
    var selectedArt: Art?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateData), name: NSNotification.Name("DataUpdated"), object: nil)
    }

    @objc func updateData() {
        if let selectedArt = selectedArt {
            if let imageData = selectedArt.image {
                detailImageView.image = UIImage(data: imageData)
            } else {
                detailImageView.image = UIImage(named: "placeholder") // Varsayılan görsel
            }
            detailNameLabel.text = "Name: \(selectedArt.name!)"
            detailArtistLabel.text = "Artist: \(selectedArt.artist!)"
            detailYearLabel.text = "Year: \(selectedArt.year)"
        }
    }
    
    
    @IBAction func editButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "toEditVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEditVC" {
            let destinationVC = segue.destination as! AddAndEditArtViewController
            destinationVC.selectedArt = selectedArt
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
