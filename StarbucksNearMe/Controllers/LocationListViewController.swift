//
//  LocationListViewController.swift
//  StarbucksNearMe
//
//  Created by Andrew Brandt on 7/26/21.
//

import UIKit
import CoreLocation

//Protocol intended to notify a parent view controller of any user interaction.
protocol LocationListViewDelegate {
    func listViewDidTapLocation(location: Location)
    func listViewDidRequestRefresh()
}

let LOCATION_CELL_IDENTIFIER = "LocationCell"

//View controller that presents a list of Starbucks locations.
class LocationListViewController: UITableViewController {
    
    var locations: [Location] = []
    
    var lastKnownCoordinate: CLLocationCoordinate2D? {
        didSet {
            if let coordinate = lastKnownCoordinate {
                self.lastKnownLocation = CLLocation(latitude: coordinate.latitude,
                                                    longitude: coordinate.longitude)
            } else {
                self.lastKnownLocation = nil
            }
        }
    }
    var lastKnownLocation: CLLocation?
    
    var delegate: LocationListViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
    }
    
    @objc func handleRefresh() {
        self.tableView.refreshControl?.endRefreshing()

        self.delegate?.listViewDidRequestRefresh()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.locations.isEmpty ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
    public func displayLocations(locations:[Location]) {
        self.locations = locations
        self.tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LOCATION_CELL_IDENTIFIER,
                                                 for: indexPath)

        let location = self.locations[indexPath.row]
        
        cell.textLabel?.text = location.approximateAddress
        
        
        if let knownLocation = self.lastKnownLocation {
            let distance = location.distance(from: knownLocation)
            let roundedDistance = Int(distance)
            cell.detailTextLabel?.text = "\(roundedDistance) meters away"
        } else {
            cell.detailTextLabel?.text = "Unknown distance away"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = self.locations[indexPath.row]
        
        self.delegate?.listViewDidTapLocation(location: location)
    }
}
