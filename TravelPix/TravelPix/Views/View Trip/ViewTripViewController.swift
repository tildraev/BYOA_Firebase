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
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        viewModel.delegate = self
        tripNameLabel.text = viewModel.trip?.name
        tripDescriptionTextView.text = viewModel.trip?.description
        addDoneButtonOnKeyboard()
        getPictures()
        imageCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
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
        guard let trip = viewModel.trip else { return }
        viewModel.getPicturesFrom(trip: trip)
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
        self.imageCollectionView.reloadData()
    }
    
}

extension ViewTripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        let imageToSend = viewModel.pictures[indexPath.row]
        cell.imageCell.image = imageToSend
        cell.isUserInteractionEnabled = true
        cell.contentMode = .scaleAspectFit
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ImageDetail", bundle: nil)
        let imageDetailViewController = storyboard.instantiateViewController(withIdentifier: "ImageDetailViewController") as? ImageDetailViewController
        let collectionViewCell = imageCollectionView.cellForItem(at: indexPath) as? CollectionViewCell
        imageDetailViewController?.imageToView = collectionViewCell?.imageCell.image
        imageDetailViewController?.modalPresentationStyle = .popover
        self.present(imageDetailViewController!, animated: true, completion: nil)
    }
}

extension ViewTripViewController: HomePageViewModelDelegate {
    func updateCollectionView() {
        imageCollectionView.reloadData()
    }
}

extension ViewTripViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthToSet = (collectionView.contentSize.width/2)-10
        return CGSize(width: widthToSet, height: widthToSet)
    }
}
