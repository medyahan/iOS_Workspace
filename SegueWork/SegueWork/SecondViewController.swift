//
//  SecondViewController.swift
//  SegueWork
//
//  Created by Medya Han on 26.11.2024.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        helloLabel.text = "Hello, \(userName)"
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
