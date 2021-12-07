//
//  ViewController.swift
//  ImagesGallaryGogreen
//
//  Created by Salman Azhar on 04/12/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var albums = [Album]()
    
    var isLoadingData = true
    var currentPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Albums"
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        self.loadAlbums()
        
        
    }
    
    func loadAlbums()
    {
        APIManager.shared.getAllAlbums(page: self.currentPage) { albumsList, success in
            if(success == true)
            {
                if let albms = albumsList
                {
                    if(albms.count > 0)
                    {
                        self.albums.append(contentsOf: albms)
                        
                        DispatchQueue.main.async
                        {
                            self.isLoadingData = false
                            self.tableView.reloadData()
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

extension ViewController : UITableViewDelegate , UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        
        cell.nameLabel.text = self.albums[indexPath.row].title ?? ""
        cell.userNameLabel.text = "User : \(self.albums[indexPath.row].user?.name ?? "")"
        
        if let photos = self.albums[indexPath.row].photos , photos.count > 0  , let thumbUrlStr = photos[0].thumbnailUrl , let url = URL(string: thumbUrlStr)
        {
            cell.thumbnailImageView.loadImage(at: url)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "showAlbumDetails", sender: self)
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 100
//    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if((indexPath.row == self.albums.count - 1) && self.isLoadingData == false)
        {
            self.isLoadingData = true
            self.currentPage = self.currentPage + 1
            self.loadAlbums()
            
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showAlbumDetails"
        {
            if let vc = segue.destination as? AlbumDetailsViewController
            {
                if let selectedIndex = self.tableView.indexPathForSelectedRow?.row
                {
                    vc.album = self.albums[selectedIndex]
                }
                
            }
        }
        
        
    }
    
}
