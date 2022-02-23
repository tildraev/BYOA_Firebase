//
//  Trip.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import Foundation
import UIKit

class Trip {
    enum Key {
        static let name = "name"
        static let description = "description"
        static let date = "date"
        static let uuid = "uuid"
        static let pictures = "pictures"
    }
    
    var name: String
    var description: String
    var date: Double
    var uuid: String
    var pictures: [UIImage]
    
    var tripData: [String:Any] {
        [Key.name           : self.name,
         Key.description    : self.description,
         Key.date           : self.date,
         Key.uuid           : self.uuid,
         Key.pictures       : self.pictures]
    }
    
    init(name: String, description: String, date: Double, uuid: String = UUID().uuidString, pictures: [UIImage] = []) {
        self.name = name
        self.description = description
        self.date = date
        self.uuid = uuid
        self.pictures = pictures
    }
    
    init?(dictionary: [String:Any]) {
        guard let name = dictionary["name"] as? String,
              let description = dictionary["description"] as? String,
              let date = dictionary["date"] as? Double,
              let uuid = dictionary["uuid"] as? String else { return nil }
              //let pictures = dictionary["pictures"] as? [UIImage]
        
        self.name = name
        self.description = description
        self.date = date
        self.uuid = uuid
        self.pictures = []
    }
    
    
}

extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
