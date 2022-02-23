//
//  Trip.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import Foundation
import UIKit

//class TripDiary {
//    enum Key {
//        static let trips = "trips"
//    }
//    
//    var trips: [Trip]
//    
//    var tripDiaryData: [String:Any] {
//        [Key.trips : self.trips]
//    }
//    
//    init(trips: [Trip]) {
//        self.trips = trips
//    }
//}
//

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
    
    
}

extension Trip: Equatable {
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
