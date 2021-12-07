//
//  PhotoCollectionViewCell.swift
//  ImagesGallaryGogreen
//
//  Created by Salman Azhar on 05/12/2021.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func prepareForReuse() {
        photoImageView.image = nil
        photoImageView.cancelImageLoad()
    }
    
}
