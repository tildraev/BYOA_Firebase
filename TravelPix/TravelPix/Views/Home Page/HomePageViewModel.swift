//
//  HomePageViewModel.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import Foundation
import UIKit
import Firebase
import AVFoundation

protocol HomePageViewModelDelegate: AnyObject {
    func updateTableView()
}

class HomePageViewModel {
    var tripDiary: [Trip]?
    var trip: Trip?
    var pictures: [UIImage] = []
    var userID: String?
    weak var delegate: HomePageViewModelDelegate?
    
    init(userID: String) {
        self.userID = userID
        self.getTrips()
    }
    
    func createTrip(name: String, description: String, date: Double, pictures: [String]) -> Trip {
        let newTrip = Trip(name: name, description: description, date: date, pictures: pictures)
        tripDiary?.append(newTrip)
        FirebaseController().save(newTrip, userID: userID!) { result in
            switch result {
                
            case .success(_):
                self.delegate?.updateTableView()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return newTrip
    }
    
    func updateTrip(trip: Trip, name: String?, description: String?, date: Double?, pictures: [String]?) {
        if let name = name { trip.name = name }
        if let description = description { trip.description = description }
        if let date = date { trip.date = date }
        if let pictures = pictures { trip.pictures = pictures }
        if let userID = userID { FirebaseController().save(trip, userID: userID) { result in
            switch result {
                
            case .success(_):
                print("true")
            case .failure(let error):
                print(error)
            }
        } }
    }
    
    func deleteTrip(trip: Trip, userID: String) {
        guard let firstIndex = tripDiary?.firstIndex(where: { $0 == trip }) else { return }
        tripDiary?.remove(at: firstIndex)
        FirebaseController().deleteTrip(trip, userID: userID)
    }
    
    func deletePicsAssociatedWithTrip(trip: Trip, userID: String) {
        
        for picture in trip.pictures {
            FirebaseController().deletePicture(userID: userID, tripName: trip.name, imagePath: picture)
        }
    }
    
    func getTrips() {
        guard let userID = userID else { return }
        FirebaseController().getTrips(userID: userID) { result in
            switch result {
            case .success(let result):
                self.tripDiary = result
                self.delegate?.updateTableView()
            case .failure(let error):
                print(error.description)
            }
        }
    }
    
    func uploadPicture(imagePath: URL, tripName: String) {
        guard let userID = userID else { return }
        FirebaseController().uploadImage(userID: userID, imagePath: imagePath, tripName: tripName, completion: { result in
            switch result {
                
            case .success(_):
                self.delegate?.updateTableView()
            case .failure(_):
                print("failure")
            }
        })
    }
}
