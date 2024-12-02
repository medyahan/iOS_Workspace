//
//  AddArtViewController.swift
//  ArtBookApp
//
//  Created by Medya Han on 2.12.2024.
//

import UIKit
import CoreData

class AddAndEditArtViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var artImageView: UIImageView!
    @IBOutlet weak var artNameTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    
    private var activeTextField: UITextField?
    var selectedArt: Art?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNotificationObservers()
        loadSelectedArt()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup Methods
    
    private func setupView() {
        yearTextField.keyboardType = .numberPad
        yearTextField.delegate = self
        artNameTextField.delegate = self
        artistTextField.delegate = self
        setupGestureRecognizers()
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        artImageView.isUserInteractionEnabled = true
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        artImageView.addGestureRecognizer(imageTapGesture)
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func loadSelectedArt() {
        guard let selectedArt = selectedArt else { return }
        artImageView.image = selectedArt.image != nil ? UIImage(data: selectedArt.image!) : UIImage(named: "placeholder")
        artNameTextField.text = selectedArt.name
        artistTextField.text = selectedArt.artist
        yearTextField.text = selectedArt.year != 0 ? String(selectedArt.year) : ""
    }
    
    // MARK: - Action Methods
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func selectImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        artImageView.image = info[.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction private func saveButtonClicked(_ sender: UIButton) {
        guard validateInputs() else { return }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        if let artToUpdate = selectedArt {
            updateArtObject(artToUpdate, context: context)
        } else {
            createNewArtObject(context: context)
        }
        
        saveContext(context)
    }
    
    // MARK: - Core Data Methods
    
    private func updateArtObject(_ art: Art, context: NSManagedObjectContext) {
        art.image = artImageView.image?.jpegData(compressionQuality: 0.8)
        art.name = artNameTextField.text
        art.artist = artistTextField.text
        art.year = Int32(yearTextField.text!) ?? 0
    }
    
    private func createNewArtObject(context: NSManagedObjectContext) {
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Art", into: context)
        newArt.setValue(UUID(), forKey: "id")
        newArt.setValue(artImageView.image?.jpegData(compressionQuality: 0.8), forKey: "image")
        newArt.setValue(artNameTextField.text, forKey: "name")
        newArt.setValue(artistTextField.text, forKey: "artist")
        newArt.setValue(Int16(yearTextField.text!) ?? 0, forKey: "year")
        newArt.setValue(Date(), forKey: "creationDate")
    }
    
    private func saveContext(_ context: NSManagedObjectContext) {
        do {
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name("DataUpdated"), object: nil)
            navigationController?.popViewController(animated: true)
        } catch {
            showAlert(title: "Error", message: "Something went wrong! Try again.")
        }
    }
    
    // MARK: - Validation
    
    private func validateInputs() -> Bool {
        if artImageView.image == nil || isImageEqual(artImageView.image, UIImage(named: "selectImage")) ||
            artNameTextField.text?.isEmpty == true ||
            artistTextField.text?.isEmpty == true ||
            yearTextField.text?.isEmpty == true {
            showAlert(title: "Error", message: "Please fill all fields")
            return false
        }
        return true
    }
    
    private func isImageEqual(_ image1: UIImage?, _ image2: UIImage?) -> Bool {
        guard let data1 = image1?.pngData(),
              let data2 = image2?.pngData() else { return false }
        return data1 == data2
    }
    
    // MARK: - Keyboard Management
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let activeTextField = activeTextField else { return }
        
        let topOfKeyboard = self.view.frame.height - keyboardFrame.height
        let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
        let padding: CGFloat = 50.0
        
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
    
    // MARK: - Alert
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}
