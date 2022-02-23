//
//  UploadPicturesViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/23/22.
//

import UIKit

class UploadPicturesViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var viewModel: HomePageViewModel!
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadPixButtonTapped(_ sender: Any) {
        
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
            guard let trip = viewModel.trip else { return }
            viewModel.updateTrip(trip: trip, name: nil, description: nil, date: nil, pictures: trip.pictures)
        }
        self.imageCollectionView.reloadData()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let homePageViewController = navigationController?.viewControllers[0] as? HomePageViewController
        homePageViewController?.viewModel = viewModel
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(navigationController!, animated: true, completion: nil)
    }
}

extension UploadPicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.trip?.pictures.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
    
        if let userID = viewModel.userID,
           let imagePath = viewModel.trip?.pictures[indexPath.row],
           let tripName = viewModel.trip?.name,
           let imageURL = URL(string: imagePath){
            
            DispatchQueue.main.async {
                cell.imageCell.setImage(userID: userID, imagePath: imageURL, tripName: tripName)                
            }
        }
    
        return cell
    }
}
