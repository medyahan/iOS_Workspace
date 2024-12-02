//
//  DetailsViewController.swift
//  LandmarkBookApp
//
//  Created by Medya Han on 1.12.2024.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var landmarkNameLabel: UILabel!
    @IBOutlet weak var landmarkImageView: UIImageView!
    @IBOutlet weak var landmarkDescriptionLabel: UILabel!
    
    var selectedLandmark = Landmark(name: "", imageName: "", description: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        landmarkImageView.layer.cornerRadius = 10
        landmarkNameLabel.text = selectedLandmark.name
        landmarkImageView.image = UIImage(named: selectedLandmark.imageName)
        landmarkDescriptionLabel.text = selectedLandmark.description
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
