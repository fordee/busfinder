//
//  InterfaceController.swift
//  BusFinder Watch App Extension
//
//  Created by John Forde on 9/1/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

	var departureDetails: DepartureDetails?
	let metLinkAPI = MetLinkApi()
	var busStop = "5014"

	@IBOutlet var resultsGroup: WKInterfaceGroup!
	@IBOutlet var loadingGroup: WKInterfaceGroup!
	@IBOutlet var loadingGroupLabel: WKInterfaceLabel!
	
	@IBOutlet var busTimesTable: WKInterfaceTable!
	@IBOutlet var busStopPicker: WKInterfacePicker!

	@IBAction func onBusStopSelection(_ value: Int) {
		switch value {
		case 0:
			busStop = "5014"
		case 1:
			busStop = "5012"
		case 2:
			busStop = "5010"
		case 3:
			busStop = "5008"
		default:
			return
		}
	}

	@IBAction func onRefreshButton() {
		refreshBusStops(busStop: busStop)
	}

	// Manages the state of the interface
	enum InterfaceState: Int {
		case loading
		case results
		case nodata
	}

	// Configure the interface based on the state of the search process
	var interfaceStatus: InterfaceState = InterfaceState.loading {
		didSet {
			loadingGroup.setHidden(true)
			resultsGroup.setHidden(true)

			switch interfaceStatus {
			case .loading:
				loadingGroupLabel.setText("Loading data...")
				loadingGroup.setHidden(false)
			case .results:
				resultsGroup.setHidden(false)
			case .nodata:
				loadingGroupLabel.setText("No buses found...")
				loadingGroup.setHidden(false)
			}
		}
	}

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		interfaceStatus = .loading

		let busStops = ["Lambton", "Farmers", "Top Shop", "Willis St"]
		var busStopItems: [WKPickerItem] = []
		for busStop in busStops {
			// 2
			let item = WKPickerItem()
			item.title = busStop
			busStopItems.append(item)
		}
		// 3
		busStopPicker.setItems(busStopItems)

		refreshBusStops(busStop: busStop)
	}

	func refreshBusStops(busStop: String) {
		interfaceStatus = .loading
		metLinkAPI.getMetLinkAPIStopDepartures(stopCode: busStop) {
			departureDetails in
			//self.interfaceStatus = .results
			self.departureDetails = departureDetails
			//self.busTimesTableView.reloadData()
			self.refreshTable()
		}
	}

	private func refreshTable() {
		guard let services = departureDetails?.Services else {
			return
		}
		if services.count == 0 {
			interfaceStatus = .nodata
		} else {
			interfaceStatus = .results
			MetLinkApi.saveFirstService(departureDetails?.Services ?? [])
			busTimesTable.setNumberOfRows(services.count, withRowType: "BusTimes")
			for (index, service) in services.enumerated() {
				let controller = busTimesTable.rowController(at: index) as! BusTimesRowController
				let departureTime = service.ExpectedDeparture ?? service.AimedArrival
				controller.busTimeLabel.setText("[\(service.ServiceID)] " + getTimeFromDateString(from: departureTime))
				controller.busTimeStatusLabel.setText(service.DepartureStatus)
				controller.rowGroup.setBackgroundColor(UIColor(red: 120/255, green: 122/255, blue: 255/255, alpha: 1))
			}
		}
	}

	func color(for index: Int) -> UIColor {
		let itemCount = busTimesTable.numberOfRows - 1
		let val = (CGFloat(index) / CGFloat(itemCount)) * 0.5
		return UIColor(red: 1.0, green: val, blue: 65.0/255.0, alpha: 1.0)
	}

}
