//
//  ViewController.swift
//  CurrencyConverterApp
//
//  Created by Medya Han on 4.12.2024.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var tryLabel: UILabel!
    @IBOutlet weak var euroTextField: UITextField!
    
    var jsonRateData: [String: Any]?
    
    private let apiKey = "880a013089c02bfab903cd07bce4720d"
    private let baseURL = "https://data.fixer.io/api/latest"
    
    private lazy var currencyLabels: [String: UILabel] = [
        "CAD": cadLabel,
        "CHF": chfLabel,
        "GBP": gbpLabel,
        "JPY": jpyLabel,
        "USD": usdLabel,
        "TRY": tryLabel
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        euroTextField.keyboardType = .numberPad
        euroTextField.text = "1"
        
        getData()
    }

    @IBAction func convertButtonClicked(_ sender: Any) {
        getData()
    }
    
    private func getData() {
        guard let url = URL(string: "\(baseURL)?access_key=\(apiKey)") else {
            showAlert("Error", message: "Invalid URL")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert("Error", message: error.localizedDescription)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert("Error", message: "No data received")
                }
                return
            }
            
            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let rates = jsonResponse["rates"] as? [String: Double] {
                    DispatchQueue.main.async {
                        self.jsonRateData = rates
                        self.updateRatesView()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert("Error", message: "Invalid response format")
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert("Error", message: error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    private func updateRatesView() {
        guard let rates = jsonRateData else { return }
        
        let euroValue = Double(euroTextField.text ?? "1") ?? 1.0
        
        for (currency, label) in currencyLabels {
            if let rate = rates[currency] as? Double {
                let calculatedValue = euroValue * rate
                label.text = currency + ": " + String(format: "%.2f", calculatedValue)
            } else {
                label.text = "N/A"
            }
        }
    }
    
    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
}

