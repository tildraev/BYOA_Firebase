//
//  ImageDetailViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/24/22.
//

import UIKit

class ImageDetailViewController: UIViewController {

    @IBOutlet weak var singleImageView: UIImageView!
    var imageToView: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        imageToView = nil
    }
    
    func updateViews() {
        singleImageView.contentMode = .scaleAspectFit
        singleImageView.image = imageToView
    }
}
