//
//  Helpers.swift
//  BusFinder Watch App Extension
//
//  Created by John Forde on 10/1/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

func getTimeFromDateString(from: String?) -> String {
	if let from = from {
		let indexStartOfText = from.index(from.startIndex, offsetBy: 11)
		let indexEndOfText = from.index(from.startIndex, offsetBy: 15)
		let timeString = from[indexStartOfText ... indexEndOfText]
		return String(timeString)
	} else {
		return ""
	}
}


