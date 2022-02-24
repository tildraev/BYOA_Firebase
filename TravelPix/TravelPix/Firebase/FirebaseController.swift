//
//  FirebaseController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import UIKit

class FirebaseController {
    let ref = Database.database().reference()
    let db = Firestore.firestore()
    
    let storageRef = Storage.storage().reference()
    
    // MARK: - USING RTDB
//    func save(_ trip: Trip, userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//        ref.child(userID).child("trips").child(trip.uuid).setValue(trip.tripData)
//        completion(.success(true))
//    }
//    
//    func deleteTrip(_ trip: Trip, userID: String) {
//        ref.child(userID).child("trips").child(trip.uuid).setValue(nil)
//    }
//    
//    func getTrips(userID: String, completion: @escaping (Result<[Trip], FirebaseError>)-> Void) {
//        ref.child(userID).child("trips").getData { error, snapshot in
//            if let error = error {
//                completion(.failure(.failure(error)))
//                return
//            }
//
//            guard let data = snapshot.value as? [String : [String : Any]] else {
//                completion(.failure(.noData))
//                return
//            }
//
//            let dataArray = Array(data.values)
//            let trips = dataArray.compactMap({Trip(dictionary: $0)})
//            let sortedTrips = trips.sorted(by: {$0.date > $1.date})
//
//            completion(.success(sortedTrips))
//        }
//    }
    
    // MARK: - USING FIRESTORE
    func save(_ trip: Trip, userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        db.collection("users").document(userID).collection("trips").document(trip.uuid).setData(trip.tripData)
        completion(.success(true))
    }
    
    func deleteTrip(_ trip: Trip, userID: String) {
        db.collection("users").document(userID).collection("trips").document(trip.uuid).delete()
    }
    
    func getTrips(userID: String, completion: @escaping (Result<[Trip], FirebaseError>)-> Void) {
        db.collection("users").document(userID).collection("trips").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(.failure(error)))
                return
            }
            
            guard let data = snapshot else {
                completion(.failure(.noData))
                return
            }
            
            let documentsArray = data.documents
            let tripArray = documentsArray.compactMap({Trip(dictionary: $0.data())})
            let sortedTrips = tripArray.sorted(by: {$0.date > $1.date})
            
            completion(.success(sortedTrips))
        }
    }
    
    func getImage(userID: String, imagePath: URL, tripName: String, completion: @escaping (Result<UIImage, FirebaseError>) -> Void) {
        let imageRef = storageRef.child(userID).child(tripName).child(imagePath.lastPathComponent)
        imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(.failure(error)))
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            guard let decodedImage = UIImage(data: data) else {
                completion(.failure(.errorDecoding))
                return
            }
            
            completion(.success(decodedImage))
        }
    }
    
    func uploadImage(userID: String, imagePath: URL, tripName: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let imageRef = storageRef.child(userID).child(tripName).child(imagePath.lastPathComponent)
        //imageRef.putFile(from: imagePath)
        imageRef.putFile(from: imagePath, metadata: nil) { _, _ in
            completion(.success(true))
        }
    }
    
    func deletePicture(userID: String, tripName: String, imagePath: String) {
        let imageRef = storageRef.child(userID).child(tripName).child(imagePath)
        imageRef.delete { error in
            print(error)
        }
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
