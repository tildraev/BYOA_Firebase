//
//  CollectionViewCell.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/23/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCell: FirebaseImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageCell.image = nil
    }
}
