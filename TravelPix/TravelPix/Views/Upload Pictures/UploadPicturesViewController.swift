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
    private let refresher = UIRefreshControl()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.dataSource = self
        imageCollectionView.delegate = self
        viewModel.delegate = self
        
        self.imageCollectionView.alwaysBounceVertical = true
        self.imageCollectionView.refreshControl = self.refresher
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.imageCollectionView!.addSubview(refresher)
        imageCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
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
        if let newImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            viewModel.pictures.append(newImage)
        }
        
        self.imageCollectionView.reloadData()
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let homePageViewController = navigationController?.viewControllers[0] as? HomePageViewController
        viewModel.pictures = []
        homePageViewController?.viewModel = viewModel
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(navigationController!, animated: true, completion: nil)
    }
    
    @objc func loadData() {
        self.imageCollectionView!.refreshControl?.beginRefreshing()
        imageCollectionView.reloadData()
        DispatchQueue.main.async {
            self.imageCollectionView!.refreshControl?.endRefreshing()
        }
    }
}

extension UploadPicturesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "picCell", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }

        cell.imageCell.image = viewModel.pictures[indexPath.row]
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

extension UploadPicturesViewController: HomePageViewModelDelegate {
    func updateCollectionView() {
        imageCollectionView.reloadData()
    }
}

extension UploadPicturesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthToSet = (collectionView.contentSize.width/2)-10
        return CGSize(width: widthToSet, height: widthToSet)
    }
}
