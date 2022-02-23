//
//  NewTripViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import UIKit

class NewTripViewController: UIViewController, UINavigationControllerDelegate, UITextViewDelegate {

    var viewModel: HomePageViewModel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripDescriptionTextView.delegate = self
    }

    @IBAction func saveTripButtonTapped(_ sender: Any) {
        if let name = tripNameTextField.text, !name.isEmpty,
           let description = tripDescriptionTextView.text, !description.isEmpty {
            
            let date = datePicker.date
            let pictures = [String]()
            let trip = viewModel.createTrip(name: name, description: description, date: date.timeIntervalSince1970, pictures: pictures)
            viewModel.delegate?.updateTableView()
            
            let storyboard = UIStoryboard(name: "UploadPicturesViewController", bundle: nil)
            guard let uploadPicturesViewController = storyboard.instantiateInitialViewController() as? UploadPicturesViewController else { return }
            uploadPicturesViewController.viewModel = self.viewModel
            uploadPicturesViewController.viewModel.trip = trip
            uploadPicturesViewController.modalPresentationStyle = .fullScreen
            self.present(uploadPicturesViewController, animated: true, completion: nil)
            
        } else {
            let alertController = UIAlertController(title: "Required fields left empty", message: "Please fill out all fields before moving forward", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func nameTextFieldDidEndEditing(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func saveDescriptionButtonTapped(_ sender: Any) {
        tripDescriptionTextView.resignFirstResponder()
    }
    
}

extension NewTripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
}
