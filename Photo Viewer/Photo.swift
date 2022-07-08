//
//  Photo.swift
//  Photo Viewer
//
//  Created by Camilo Hernández Guerrero on 7/07/22.
//

import UIKit

class Photo: Codable {
    var image: String
    var caption: String
    
    init(image: String, caption: String) {
        self.image = image
        self.caption = caption
    }
}
