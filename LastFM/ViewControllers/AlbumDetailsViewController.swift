//
//  AlbumDetailsViewController.swift
//  LastFM
//
//  Created by Bruno Tavares on 25/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import UIKit

class AlbumDetailsViewController: UIViewController {
    
    @IBOutlet weak var albumImageView: OnlineImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var trackAmountLabel: UILabel!
    @IBOutlet weak var publishingDateLabel: UILabel!
    @IBOutlet weak var albumPlaysLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var album: DetailedAlbum? {
        
        didSet {
            guard let album = album else { return }
            
            DispatchQueue.main.async {
                if let urlString = album.getImageUrl(forImageSize: .extraLarge) {
                    self.albumImageView.loadImage(fromUrlString: urlString)
                }
                if let publishDate = album.publishDate {
                    self.publishingDateLabel.text = "Published in \(publishDate)"
                } else {
                    self.publishingDateLabel.text = ""
                }
                self.albumNameLabel.text = album.name
                self.artistLabel.text = "\(album.artist) (\(album.listeners) Listeners)"
                self.trackAmountLabel.text = "\(album.trackAmount) Tracks"
                self.albumPlaysLabel.text = "Played \(album.playCount) times"
                self.activityIndicator.stopAnimating()
                self.loadingView.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
