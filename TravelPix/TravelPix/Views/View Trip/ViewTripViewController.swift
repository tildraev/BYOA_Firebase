//
//  ViewTripViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import UIKit

class ViewTripViewController: UIViewController {

    var viewModel: HomePageViewModel!
    
    @IBOutlet weak var tripNameLabel: UILabel!
    @IBOutlet weak var tripDescriptionTextView: UITextView!
    @IBOutlet weak var pictureCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureCollectionView.dataSource = self
        pictureCollectionView.delegate = self
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        //TODO: Call updateTrip
        
        let storyboard = UIStoryboard(name: "HomePage", bundle: nil)
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        let homePageViewController = navigationController?.viewControllers[0] as? HomePageViewController
        homePageViewController?.viewModel = viewModel
        navigationController?.modalPresentationStyle = .fullScreen
        self.present(navigationController!, animated: true, completion: nil)
    }
}

extension ViewTripViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
