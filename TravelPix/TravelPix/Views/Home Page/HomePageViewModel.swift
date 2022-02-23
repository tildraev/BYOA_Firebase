//
//  HomePageViewModel.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import Foundation
import UIKit
import Firebase

class HomePageViewModel {
    var tripDiary: [Trip]?
    var userID: String?
    
    init(userID: String) {
        self.userID = userID
        getTrips()
    }
    
    func createTrip(name: String, description: String, date: Double, pictures: [UIImage]) {
        let newTrip = Trip(name: name, description: description, date: date, pictures: pictures)
        tripDiary?.append(newTrip)
        FirebaseController().save(newTrip, userID: userID!)
    }
    
    func updateTrip(trip: Trip, name: String?, description: String?, date: Double?, pictures: [UIImage]?) {
        if let name = name {
            trip.name = name
        }
        
        if let description = description {
            trip.description = description
        }
        
        if let date = date {
            trip.date = date
        }
        
        if let pictures = pictures {
            trip.pictures = pictures
        }
        
        if let userID = userID {
            FirebaseController().save(trip, userID: userID)
        }
    }
    
    func deleteTrip(trip: Trip, userID: String) {
//        guard let firstIndex = tripDiary?.trips.firstIndex(where: { $0 == trip }) else { return }
//        tripDiary?.trips.remove(at: firstIndex)
        
        FirebaseController().deleteTrip(trip, userID: userID)
    }
    
    func getTrips() {
        //Insert code to GET trip data from firebase
        //self.tripDiary =
    }
}
