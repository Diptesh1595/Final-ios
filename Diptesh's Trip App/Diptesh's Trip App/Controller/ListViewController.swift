

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tripSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var trips: [TripModel] = []
    var searchedTrips: [TripModel] = []
    
    var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "All Trips"
        self.navigationController?.navigationBar.tintColor = .black
        tripSearchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        trips = CoreData.shared.fetchAllTrips()
    }
    
    func showAlert(title: String, message: String, index: Int) {
        let alert = UIAlertController(title: "Delete Trip", message: "Are you sure you want to delete this trip?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.deleteAction(at: index)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(delete)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func deleteAction(at index: Int) {
        DispatchQueue.main.async { [self] in
            
            CoreData.shared.deleteTrip(with: trips[index].id)
            
            if isSearching {
                let trip = searchedTrips.remove(at: index)
                trips.removeAll { $0.id == trip.id }
            } else {
                trips.remove(at: index)
            }
            
            tableView.reloadData()
        }
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchedTrips.count : trips.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TripTableViewCell
        
        let trip = isSearching ? searchedTrips[indexPath.row] : trips[indexPath.row]
        cell.selectionStyle = .none
        cell.tripNameLabel.text = trip.title
        cell.desinationLabel.text = "Destination: " + trip.destination
        cell.originLabel.text = "From: " + trip.originLocation
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.trip = isSearching ? searchedTrips[indexPath.row] : trips[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            showAlert(title: "Delete", message: "Are you sure, you want to delete this trip?", index: indexPath.row)
        }
    }
}

extension ListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedTrips = trips.filter { $0.title.prefix(searchText.count).lowercased() == searchText.lowercased() }
        isSearching = true
        tableView.reloadData()
    }
}
