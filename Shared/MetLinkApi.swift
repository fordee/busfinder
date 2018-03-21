//
//  MetLinkApi.swift
//  BusFinder
//
//  Created by John Forde on 15/12/17.
//  Copyright © 2017 4DWare. All rights reserved.
//

import Foundation


public struct BusTrainService: Decodable {
	let ServiceID: String
	let AimedArrival: String?
	let DepartureStatus: String?
	let ExpectedDeparture: String?
}

struct BusTrainStop: Decodable {
	let Name: String
}

public struct DepartureDetails: Decodable {
	//let ServiceID: String
	let LastModified: String
	let Stop: BusTrainStop
	var Services: [BusTrainService]
	//let AimedArrival: String
	//let DepartureStatus: String
	//let ExpectedDeparture: String
	init() {
		LastModified = ""
		Stop = BusTrainStop.init(Name: "")
		Services = []
	}
}


final public class MetLinkApi: NSObject {
	private var departureDetails = DepartureDetails()
	private var errorMessage = ""
	private let decoder = JSONDecoder()

	public func getMetLinkAPIStopDepartures(stopCode: String, completion: @escaping (DepartureDetails)->()) /* -> ApiResponse */ {
		let session = URLSession.shared
		let urlString = "https://www.metlink.org.nz/api/v1/StopDepartures/" + stopCode
		print("urlString: \(urlString)")

		let url = URL(string: urlString)
		let dataTask = session.dataTask(with: url!) { data, response, error in
			// Check errors
			if let error = error {
				self.errorMessage += "DataTask Error: " + error.localizedDescription + "\n"
			} else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
				self.updateSearchResults(data)

				// Process Data
				self.filterBy(serviceIDs: ["052", "056", "057", "058"])
				print("apiResponse: \(self.departureDetails)")
			}

			DispatchQueue.main.async {
				// Update UI
				completion(self.departureDetails)
			}
		}
		dataTask.resume()
	}

	private func filterBy(serviceIDs: [String]) {
		departureDetails.Services = departureDetails.Services.filter() {
			for serviceID in serviceIDs {
				if $0.ServiceID == serviceID {
					return true
				}
			}
			return false
		}
	}

	private func updateSearchResults(_ data: Data) {
		//services.removeAll()
		do {
			departureDetails = try decoder.decode(DepartureDetails.self, from: data)
		} catch let decodeError as NSError {
			errorMessage += "Decoder Error: " + decodeError.localizedDescription + "\n"
			print("Error: " + errorMessage)
		}
	}
}

// MARK: Persistance
extension MetLinkApi {

	static func loadFirstService() -> BusTrainService {
		let defaults = UserDefaults.standard
		let serviceID = defaults.string(forKey: "ServiceID") ?? ""
		let aimedArrival = defaults.string(forKey: "AimedArrival")
		let departureStatus = defaults.string(forKey: "DepartureStatus")
		let expectedDeparture = defaults.string(forKey: "ExpectedDeparture")

		let firstService = BusTrainService(ServiceID: serviceID, AimedArrival: aimedArrival, DepartureStatus: departureStatus, ExpectedDeparture: expectedDeparture)

		return firstService
	}

	static func saveFirstService(_ services: [BusTrainService]) {
		let defaults = UserDefaults.standard
		guard let firstSevice = services.first else {return}

		defaults.set(firstSevice.ServiceID, forKey: "ServiceID")
		defaults.set(firstSevice.AimedArrival, forKey: "AimedArrival")
		defaults.set(firstSevice.DepartureStatus, forKey: "DepartureStatus")
		defaults.set(firstSevice.ExpectedDeparture, forKey: "ExpectedDeparture")
	}
}


