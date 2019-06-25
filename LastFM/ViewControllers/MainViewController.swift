//
//  ViewController.swift
//  LastFM
//
//  Created by Bruno Tavares on 23/06/2019.
//  Copyright © 2019 Bruno Tavares. All rights reserved.
//

import UIKit

import UIKit

class MainViewController: UIViewController {
    
    let kImageCellReuseIdentifier = "imageCell"
    let kAlbumDetailsSegueIdentifier = "goToAlbumDetails"
    let kHeightLeftUntilRefreshStarts: CGFloat = 1500.0
    let kNumberOfCellsPerRow: CGFloat = 2
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var albumList: [TopAlbum] = []
    var selectedIndexPath: IndexPath?
    var gettingMoreAlbums: Bool = false
    var currentPage: Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.invalidateLayout()
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.gettingMoreAlbums = false
        AppReviewManager().checkToShowReviewView()
        
        LastFMApi.service.getTopAlbums(forTag: "hiphop", andPage: 1, onSuccess: { [weak self] (topAlbums) in
            
            guard let weakSelf = self else { return }
            weakSelf.albumList = topAlbums
            
            DispatchQueue.main.async {
                weakSelf.collectionView.reloadData()
            }
            
            }, onError: { (error) in
                
                print(error)
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            layout.invalidateLayout()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == kAlbumDetailsSegueIdentifier {
            
            let destinationVC = segue.destination as? AlbumDetailsViewController
            
            guard let indexPath = selectedIndexPath else {
                
                return
            }
            
            let selectedAlbum = albumList[indexPath.row]
            LastFMApi.service.getAlbumDetails(forAlbumName: selectedAlbum.albumName, andArtist: selectedAlbum.artist.name, onSuccess: { (detailedAlbum) in
                
                destinationVC?.album = detailedAlbum
                
            }, onError: { (error) in
                
                print(error)
            })
        }
    }
    
    func getMoreAlbums() {
        
        gettingMoreAlbums = true
        currentPage += 1
        
        LastFMApi.service.getTopAlbums(forTag: "hiphop", andPage: currentPage, onSuccess: { [weak self] (topAlbums) in
            
            guard let weakSelf = self else { return }
            weakSelf.albumList.append(contentsOf: topAlbums)
            weakSelf.gettingMoreAlbums = false
            
            DispatchQueue.main.async {
                weakSelf.collectionView.reloadData()
            }
            
            }, onError: { (error) in
                
                print(error)
        })
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return albumList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kImageCellReuseIdentifier, for: indexPath) as! AlbumImageCollectionViewCell
        
        let currentAlbum = albumList[indexPath.row]
        cell.titleLabel.text = currentAlbum.albumName
        
        if let urlString = currentAlbum.getImageUrl(forImageSize: .extraLarge) {
            
            cell.imageView.loadImage(fromUrlString: urlString)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedIndexPath = indexPath
        performSegue(withIdentifier: kAlbumDetailsSegueIdentifier, sender: self)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            
            let horizontalSpacing = flowLayout.minimumInteritemSpacing
            let cellWidth = (view.frame.width - max(0, kNumberOfCellsPerRow - 1) * horizontalSpacing) / kNumberOfCellsPerRow
            
            return CGSize(width: cellWidth, height: cellWidth)
        }
        
        return CGSize(width: 180, height: 180)
    }
}

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY <= 0 {
            return
        }
        
        if offsetY > contentHeight - scrollView.frame.height - kHeightLeftUntilRefreshStarts && !gettingMoreAlbums {
            getMoreAlbums()
        }
    }
}
