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
    
    var selectedLandmarkName = ""
    var selectedLandmarkImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        landmarkImageView.layer.cornerRadius = 10
        landmarkNameLabel.text = selectedLandmarkName
        landmarkImageView.image = selectedLandmarkImage
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
