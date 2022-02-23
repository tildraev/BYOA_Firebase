//
//  HomePageViewController.swift
//  TravelPix
//
//  Created by Arian Mohajer on 2/22/22.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController {

    var viewModel: HomePageViewModel!
    @IBOutlet weak var tripTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tripTableView.delegate = self
        tripTableView.dataSource = self
    }
    

    @IBAction func signOutButtonTapped(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() else { return }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } catch {
            print(error)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewTripVC" {
            if let destination = segue.destination as? NewTripViewController {
                destination.viewModel = viewModel
            }
        }
    }
}

extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tripDiary?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)

        cell.textLabel?.text = viewModel.tripDiary?[indexPath.row].name

        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let trip = viewModel.tripDiary?[indexPath.row] else { return }
            viewModel.deleteTrip(trip: trip, userID: viewModel.userID!)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension HomePageViewController: HomePageViewModelDelegate {
    func updateTableView() {
        DispatchQueue.main.async {
            self.tripTableView.reloadData()
        }
    }
}
