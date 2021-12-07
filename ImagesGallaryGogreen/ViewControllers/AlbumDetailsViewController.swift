//
//  AlbumDetailsViewController.swift
//  ImagesGallaryGogreen
//
//  Created by Salman Azhar on 05/12/2021.
//

import UIKit

class AlbumDetailsViewController: UIViewController {

    
    @IBOutlet weak var authorView: UIView!
    
    @IBOutlet weak var albumTitleLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userDetail1Label: UILabel!
    
    @IBOutlet weak var userDetail2Label: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var album : Album!
    
    var photos = [Photo]()
    
    @IBOutlet weak var largePhotoView: UIView!
    
    @IBOutlet weak var largeImageView: UIImageView!
    
    var isLoadingData = true
    var currentPage = 1
    
    var isFromUserDetails = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.largePhotoView.isHidden = true
        
        
        self.setupAuthorView()
        self.loadPhotos()
    }
    
    func setupAuthorView()
    {
        self.authorView.layer.borderWidth = 1
        self.authorView.layer.borderColor = UIColor.magenta.cgColor
        self.authorView.layer.masksToBounds = true
        self.authorView.layer.cornerRadius = 8
        
        self.albumTitleLabel.text = self.album.title ?? ""
        self.userNameLabel.text = self.album.user?.name ?? ""
        self.userDetail1Label.text = self.album.user?.phone ?? ""
        self.userDetail2Label.text = self.album.user?.email ?? ""
    }
    
    func loadPhotos()
    {
        if let albumID = self.album.id
        {
            APIManager.shared.getAllPhotosForAlbum(albumID: albumID, page: self.currentPage) { photosList, success in
                
                if(success == true)
                {
                    if let phts = photosList
                    {
                        if(phts.count > 0)
                        {
                            self.photos.append(contentsOf: phts)
                            
                            DispatchQueue.main.async {
                                self.collectionView.reloadData()
                                self.isLoadingData = false
                            }
                        }
                    }
                }
                else
                {
                    
                }
                
            }
            
        }
    }
    
    @IBAction func showUserDetails(_ sender: Any)
    {
        if(self.isFromUserDetails == false)
        {
            self.performSegue(withIdentifier: "showUserDetails", sender: self)
        }
    }
    
    
    @IBAction func closePopup(_ sender: Any)
    {
        self.largeImageView.image = nil
        self.largePhotoView.isHidden = true
    }
    
    func showPopup(urlStr : String)
    {
        if let url = URL(string: urlStr)
        {
            self.largeImageView.loadImage(at: url)
            self.largePhotoView.isHidden = false
        }
    }
    
    
//photoCell
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //showUserDetails
        
        if segue.identifier == "showUserDetails"
        {
            if let vc = segue.destination as? UserDetailsViewController
            {
                if let usrDetails = self.album.user
                {
                    vc.userDetails = usrDetails
                }
            }
        }
    }
    

}
extension AlbumDetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        
        if let url = URL(string: self.photos[indexPath.item].thumbnailUrl ?? "")
        {
            cell.photoImageView.loadImage(at: url)
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.photos.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width = ((collectionView.frame.width) / 2) - 10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
        if let url = self.photos[indexPath.item].url
        {
            self.showPopup(urlStr: url)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        
        if((indexPath.row == self.photos.count - 1) && self.isLoadingData == false)
        {
            self.isLoadingData = true
            self.currentPage = self.currentPage + 1
            self.loadPhotos()
            
        }
        
    }
    
}
