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
        addDoneButtonOnKeyboard()
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.black
        doneToolbar.isTranslucent = true

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))

        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)

        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        self.tripDescriptionTextView.inputAccessoryView = doneToolbar
        self.tripNameTextField.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.tripDescriptionTextView.resignFirstResponder()
        self.tripNameTextField.resignFirstResponder()
    }

    @IBAction func saveTripButtonTapped(_ sender: Any) {
        if let name = tripNameTextField.text, !name.isEmpty,
           let description = tripDescriptionTextView.text, !description.isEmpty {
            
            let date = datePicker.date
            let pictures = [String]()
            let trip = viewModel.createTrip(name: name, description: description, date: date.timeIntervalSince1970, pictures: pictures)
            viewModel.delegate?.updateCollectionView()
            
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
