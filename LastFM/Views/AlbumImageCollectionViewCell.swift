//
//  AlbumImageCollectionViewCell.swift
//  LastFM
//
//  Created by Bruno Tavares on 24/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import UIKit

class AlbumImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: OnlineImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
}
