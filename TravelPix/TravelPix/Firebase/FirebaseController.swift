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
    let storageRef = Storage.storage().reference()
    
    func save(_ trip: Trip, userID: String) {
        ref.child(userID).child("trips").child(trip.uuid).setValue(trip.tripData)
    }
    
    func deleteTrip(_ trip: Trip, userID: String) {
        ref.child(userID).child("trips").child(trip.uuid).setValue(nil)
    }
    
    func getTrips(userID: String, completion: @escaping (Result<[Trip], FirebaseError>)-> Void) {
        ref.child(userID).child("trips").getData { error, snapshot in
            if let error = error {
                completion(.failure(.failure(error)))
                return
            }
            
            guard let data = snapshot.value as? [String : [String : Any]] else {
                completion(.failure(.noData))
                return
            }
            
            let dataArray = Array(data.values)
            let trips = dataArray.compactMap({Trip(dictionary: $0)})
            let sortedTrips = trips.sorted(by: {$0.date > $1.date})
            
            completion(.success(sortedTrips))
        }
    }
    
    func uploadPicture(userID: String) {
        let imageRef = storageRef.child(userID)
        
    }
}


enum FirebaseError: LocalizedError {
    case failure(Error)
    case noData
    case errorDecoding
    
    var description: String {
        switch self {
            
        case .failure(let error):
            return "Failure while attempting to get data -> \(error)"
        case .noData:
            return "No data was available"
        case .errorDecoding:
            return "Error in decoding"
        }
    }
}
