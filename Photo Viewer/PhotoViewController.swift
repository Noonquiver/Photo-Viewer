//
//  PhotoViewController.swift
//  Photo Viewer
//
//  Created by Camilo Hernández Guerrero on 7/07/22.
//

import UIKit

class PhotoViewController: UIViewController {
    @IBOutlet var photoView: UIImageView!
    var selectedPhoto: String?
    
    override func viewDidLoad() {
        if let imageToLoad = selectedPhoto {
            photoView.image = UIImage(contentsOfFile: imageToLoad)
        }
    }
}
