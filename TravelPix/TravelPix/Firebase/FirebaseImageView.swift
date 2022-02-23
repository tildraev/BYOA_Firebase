//
//  FirebaseImageView.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/23/22.
//

import UIKit
import Firebase

class FirebaseImageView: UIImageView {

    let storageRef = Storage.storage().reference()
    
    func setImage(userID: String, imagePath: URL, tripName: String) {
        let imageRef = storageRef.child(userID).child(tripName).child(imagePath.lastPathComponent)
        let downloadTask = imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                self.image = UIImage(data: data!)
            }
        }
    }
}
