//
//  UserDetailsViewController.swift
//  ImagesGallaryGogreen
//
//  Created by Salman Azhar on 05/12/2021.
//

import UIKit
import MapKit

class UserDetailsViewController: UIViewController , MKMapViewDelegate , CLLocationManagerDelegate {

    
    @IBOutlet weak var userDetailsView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var telephoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var userDetails : User!
    var albums = [Album]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapView.isUserInteractionEnabled = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        
        
        self.setupUserDetailsView()
        self.getUserAlbums()
        self.showMap()
        
        
        
    }
    
    func setupUserDetailsView()
    {
        self.userDetailsView.layer.borderWidth = 1
        self.userDetailsView.layer.borderColor = UIColor.magenta.cgColor
        self.userDetailsView.layer.masksToBounds = true
        self.userDetailsView.layer.cornerRadius = 8
        
        self.nameLabel.text = self.userDetails.name ?? ""
        self.telephoneLabel.text = self.userDetails.phone ?? ""
        self.emailLabel.text = self.userDetails.email ?? ""
        self.websiteLabel.text = self.userDetails.website ?? ""
        self.addressLabel.text = "\(self.userDetails.address?.suite ?? "") \n\(self.userDetails.address?.street ?? "" ) \n\(self.userDetails.address?.city ?? "") \n\(self.userDetails.address?.zipcode ?? "")"
    }
    
    func getUserAlbums()
    {
        if let userID = self.userDetails.id
        {
            APIManager.shared.getAlbumsForUser(userID: userID) { albumsList, success in
                
                if success == true
                {
                    if let albms = albumsList
                    {
                        self.albums = albms
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    func showMap()
    {
        
        if let lat = Double(self.userDetails.address?.geo?.lat ?? "") , let lng = Double(self.userDetails.address?.geo?.lng ?? "")
        {
            let annotation = MKPointAnnotation()
            annotation.title = self.userDetails.name ?? ""
            var coordinate = CLLocationCoordinate2D()
            
            coordinate.latitude = lat
            coordinate.longitude = lng
            annotation.coordinate = coordinate
            
            var region = MKCoordinateRegion()
            var span = MKCoordinateSpan()
            
            span.latitudeDelta = 100;     // 0.0 is min value u van provide for zooming
            span.longitudeDelta = 100
            region.span=span;
            region.center = coordinate;     // to locate to the center
            self.mapView.addAnnotation(annotation)
            self.mapView.setRegion(region, animated: true)
            self.mapView.regionThatFits(region)
            
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserDetailsViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        
        cell.nameLabel.text = self.albums[indexPath.row].title ?? ""
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.albums.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "albumDetailsViewController") as? AlbumDetailsViewController
        {
            
            if let selectedIndex = self.tableView.indexPathForSelectedRow?.row
            {
                vc.album = self.albums[selectedIndex]
                vc.isFromUserDetails = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            
        }
        
    }
    
}

