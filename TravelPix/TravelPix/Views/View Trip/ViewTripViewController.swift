//
//  ViewTripViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import UIKit

class ViewTripViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var viewModel: HomePageViewModel!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureCollectionView.dataSource = self
        pictureCollectionView.delegate = self
        tripNameLabel.text = viewModel.trip?.name
        tripDescriptionTextView.text = viewModel.trip?.description
        addDoneButtonOnKeyboard()
        getPictures()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.pictures = []
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

    }

    @objc func doneButtonAction()
    {
        self.tripDescriptionTextView.resignFirstResponder()
    }
    
    func getPictures() {
        guard let viewModel = viewModel else { return }
        guard let trip = viewModel.trip else { return }
        let pictures = trip.pictures
        
        
        for imageURLString in pictures {
            guard let imageURL = URL(string: imageURLString) else { return }
            FirebaseController().getImage(userID: viewModel.userID ?? "", imagePath: imageURL, tripName: trip.name) { result in
                switch result {
                    
                case .success(let decodedImage):
                    viewModel.pictures.append(decodedImage)
                    DispatchQueue.main.async {
                        self.pictureCollectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        guard let trip = viewModel.trip,
              let descriptionText = tripDescriptionTextView.text, !descriptionText.isEmpty else { return }
        viewModel.updateTrip(trip: trip, name: nil, description: descriptionText, date: nil, pictures: nil)
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let homePageViewController = navigationController?.viewControllers[0] as? HomePageViewController
        viewModel.pictures = []
        homePageViewController?.viewModel = viewModel
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(navigationController!, animated: true, completion: nil)
    }
    
    @IBAction func uploadMorePicsButtonTapped(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL,
           let tripName = viewModel.trip?.name {
            viewModel.uploadPicture(imagePath: imageURL, tripName: tripName)
            viewModel.trip?.pictures.append(imageURL.lastPathComponent)
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                viewModel.pictures.append(selectedImage)
            }
            guard let trip = viewModel.trip else { return }
            viewModel.updateTrip(trip: trip, name: nil, description: tripDescriptionTextView.text, date: nil, pictures: trip.pictures)
        }
        self.pictureCollectionView.reloadData()
    }
    
}

extension ViewTripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
    
//        if let userID = viewModel.userID,
//           let imagePath = viewModel.trip?.pictures[indexPath.row],
//           let tripName = viewModel.trip?.name,
//           let imageURL = URL(string: imagePath){
//
//            DispatchQueue.main.async {
//                cell.imageCell.setImage(userID: userID, imagePath: imageURL, tripName: tripName)
//            }
//
//        }
        
        cell.imageCell.image = viewModel.pictures[indexPath.row]
        return cell
    }
}
