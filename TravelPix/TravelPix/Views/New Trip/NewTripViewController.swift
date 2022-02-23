//
//  NewTripViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import UIKit

class NewTripViewController: UIViewController {

    var viewModel: HomePageViewModel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tripNameTextField: UITextField!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var uploadPicturesButton: UIButton!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func uploadPixButtonTapped(_ sender: Any) {
        // Present image picker and upload pic to cloud
        // FirebaseController().upload a pic
        //let imagePicker = UIImagePickerController()
    }
    
    @IBAction func saveTripButtonTapped(_ sender: Any) {
        guard let name = tripNameTextField.text, !name.isEmpty,
              let description = tripDescriptionTextView.text, !description.isEmpty
               else { return }
        
        let date = datePicker.date
        let pictures = [UIImage]()
        
        viewModel.createTrip(name: name, description: description, date: date.timeIntervalSince1970, pictures: pictures)
        
        viewModel.delegate?.updateTableView()
        navigationController?.popViewController(animated: true)
    }
    
}
