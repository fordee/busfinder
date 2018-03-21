//
//  MetLinkService.swift
//  BusFinder
//
//  Created by John Forde on 9/1/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

class MetLinkService: WebService {
	private let baseURL = URL(string: "https://www.metlink.org.nz")!

	init () {
		super.init(rootURL: baseURL)
	}

	/**
	Gets `DeparturesDetails` from the metlink.org.nz `StopDepartures` Web Service.

	**Note:** The GET request will have a URL pattern like the following:

	```
	/api/v1/StopDepartures/stopCode
	```
	- parameter stopCode: The MetLink defined bus or train Stop Code
	- parameter completion: A completion block that returns the Departure data array or an error
	*/
//	func getStopDepartures(stopCode: String, completion: @escaping (_ departures: DeparturesDetails?, _ error: Error?) -> Void) {
//
//		// GET api/v1/StopDepartures/stopCode
//		let path = "/api/v1/StopDepartures/\(stopCode)"
//		let encodedPath = path.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
//		executeRequest(encodedPath!) { (response: DeparturesDetails?, error: Error?) in
//
//			// Make sure you get a dictionary back
//			guard let response = response else {
//				completion(nil, error)
//				return
//			}
//
//			// Convert the parsed dictionary to a real object
//			completion(response, error)
//		}
//	}
}




