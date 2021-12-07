//
//  APIManager.swift
//  ImagesGallaryGogreen
//
//  Created by Salman Azhar on 05/12/2021.
//

import Foundation

class APIManager
{
    static let shared = APIManager()
    
    
    //https://jsonplaceholder.typicode.com/albums?_page=1&_limit=10
    
    func getAllAlbums(page : Int , completion : @escaping ([Album]? , Bool) -> () )
    {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/albums?_page=\(page)&_limit=10&_expand=user&_embed=photos")
        {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if(error == nil)
                {
                    let albums = try? JSONDecoder().decode([Album].self, from: data ?? Data())
                    
                    completion(albums, true)
                }
                else
                {
                    completion(nil, false)
                }
                
            }.resume()
            
        }
        
        
    }
    
    func getAlbumsForUser(userID : Int , completion : @escaping ([Album]? , Bool) -> () )
    {
        if let url = URL(string: "https://jsonplaceholder.typicode.com/albums?userId=\(userID)&_expand=user")
        {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if(error == nil)
                {
                    let albums = try? JSONDecoder().decode([Album].self, from: data ?? Data())
                    
                    completion(albums, true)
                }
                else
                {
                    completion(nil, false)
                }
                
            }.resume()
            
        }
    }
    
    func getAllPhotosForAlbum(albumID : Int , page : Int , completion : @escaping ([Photo]? , Bool) -> () )
    {
        
        if let url = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=\(albumID)&_page=\(page)&_limit=10")
        {
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                if(error == nil)
                {
                    let photos = try? JSONDecoder().decode([Photo].self, from: data ?? Data())
                    
                    completion(photos, true)
                }
                else
                {
                    completion(nil, false)
                }
                
            }.resume()
            
        }
        
    }
}
