//
//  ViewController.swift
//  BusFinder
//
//  Created by John Forde on 15/12/17.
//  Copyright © 2017 4DWare. All rights reserved.
//

import UIKit

class MetLinkViewController: UIViewController {
	@IBOutlet weak var busStopSegmentControl: UISegmentedControl!

	@IBAction func onBusStopSegControl(_ sender: UISegmentedControl, forEvent event: UIEvent) {
		var busStop = ""
		switch busStopSegmentControl.selectedSegmentIndex {
		case 0:
			busStop = "5012"
		case 1:
			busStop = "5010"
		case 2:
			busStop = "5008"
		default:
			return
		}
		refreshBusStops(busStop: busStop)
	}

	@IBOutlet weak var busTimesTableView: UITableView!

	var departureDetails: DepartureDetails?
	let metLinkAPI = MetLinkApi()

	override func viewDidLoad() {
		super.viewDidLoad()
		refreshBusStops(busStop:  "5012")
	}

	func refreshBusStops(busStop: String) {
		metLinkAPI.getMetLinkAPIStopDepartures(stopCode: busStop) {
			departureDetails in
			self.departureDetails = departureDetails
			self.busTimesTableView.reloadData()
		}
	}

	func converStringToDate(from: String) -> Date {

		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
		let date = dateFormatter.date(from: from)!
		return date
	}
}

extension MetLinkViewController: UITableViewDataSource {
		func tableView(_ tableView: UITableView,	numberOfRowsInSection section: Int) -> Int {
			if let departureDetails = departureDetails {
				return departureDetails.Services.count
			} else {
				return 1
			}
		}

		func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
			let cell = busTimesTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
			if let departureDetails = departureDetails {
				//let expectedDeparture = Date() //apiResponse.Services[indexPath.row].ExpectedDeparture)
				let index = indexPath.row
				let serviceID = departureDetails.Services[indexPath.row].ServiceID

				let expextedDepartureTime = getTimeFromDateString(from: departureDetails.Services[index].ExpectedDeparture)

				cell.textLabel!.text = departureDetails.Stop.Name + " [" + serviceID + "] " + expextedDepartureTime
				cell.detailTextLabel?.text = departureDetails.Services[index].DepartureStatus
				return cell
			} else {
				return UITableViewCell()
			}



		}
}



