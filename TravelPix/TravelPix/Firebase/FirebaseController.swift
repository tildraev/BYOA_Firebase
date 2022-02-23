//
//  FirebaseController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import Foundation
import Firebase

class FirebaseController {
    let ref = Database.database().reference()
    
    func save(_ trip: Trip, userID: String) {
        ref.child(userID).child("trips").child(trip.uuid).setValue(trip.tripData)
    }
    
    func deleteTrip(_ trip: Trip, userID: String) {
        ref.child(userID).child("trips").child(trip.uuid).setValue(nil)
    }
}
