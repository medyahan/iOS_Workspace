//
//  ViewController.swift
//  GestureRecognizerWork
//
//  Created by Medya Han on 1.12.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconLabel: UILabel!
    
    var isTapped: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconImageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapIconImage))
        
        iconImageView.addGestureRecognizer(gestureRecognizer)
        
    }
    @objc func tapIconImage() {
        isTapped = !isTapped
        
        if(isTapped) {
            iconImageView.image = UIImage(named: "swift-icon")
            iconLabel.text = "Swift"
        }
        else {
            iconImageView.image = UIImage(named: "xcode-icon")
            iconLabel.text = "Xcode"
        }
    }


}

