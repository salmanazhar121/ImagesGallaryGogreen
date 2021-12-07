//
//  AlbumTableViewCell.swift
//  ImagesGallaryGogreen
//
//  Created by Salman Azhar on 05/12/2021.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
