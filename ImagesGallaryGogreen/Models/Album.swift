//
//  Album.swift
//  ImagesGallaryGogreen
//
//  Created by Salman Azhar on 05/12/2021.
//

import Foundation

struct Album : Codable {
    let userId : Int?
    let id : Int?
    let title : String?
    let user : User?
    let photos : [Photo]?

    enum CodingKeys: String, CodingKey {

        case userId = "userId"
        case id = "id"
        case title = "title"
        case user = "user"
        case photos = "photos"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        user = try values.decodeIfPresent(User.self, forKey: .user)
        photos = try values.decodeIfPresent([Photo].self, forKey: .photos)
    }

}
