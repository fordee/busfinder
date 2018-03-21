//
//  ComplicationController.swift
//  BusFinder Watch App Extension
//
//  Created by John Forde on 11/1/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {

	// MARK: Register
	func getLocalizableSampleTemplate(for complication:	CLKComplication, withHandler handler:	@escaping (CLKComplicationTemplate?) -> Swift.Void) {
		if complication.family == .utilitarianLarge {
			let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
			largeFlat.textProvider = CLKSimpleTextProvider(text: "[052] 19:52")
			handler(largeFlat)
		} else if complication.family == .modularLarge {
			let largeFlat = CLKComplicationTemplateModularLargeStandardBody()
			largeFlat.headerTextProvider = CLKSimpleTextProvider(text: "Bus Finder")
			largeFlat.headerTextProvider.tintColor = UIColor(red: 250/255, green: 17/255, blue: 79/255, alpha: 1)
			largeFlat.body1TextProvider = CLKSimpleTextProvider(text: "Farmers")
			largeFlat.body2TextProvider = CLKSimpleTextProvider(text: "[052] 19:52")

			handler(largeFlat)
		}
	}
	
	// MARK: Provide Data
	func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Swift.Void) {
		let firstService = MetLinkApi.loadFirstService()

		if complication.family == .utilitarianLarge {
			let largeFlat = CLKComplicationTemplateUtilitarianLargeFlat()
			largeFlat.textProvider = CLKSimpleTextProvider(text: "[\(firstService.ServiceID)] \(getTimeFromDateString(from: firstService.ExpectedDeparture)) \(firstService.DepartureStatus ?? firstService.AimedArrival ?? "No Data")")
			handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: largeFlat))
		} else if complication.family == .modularLarge {
			let largeFlat = CLKComplicationTemplateModularLargeStandardBody()
			largeFlat.headerTextProvider = CLKSimpleTextProvider(text: "Bus Finder")
			largeFlat.headerTextProvider.tintColor = UIColor(red: 250/255, green: 17/255, blue: 79/255, alpha: 1)
			largeFlat.body1TextProvider = CLKSimpleTextProvider(text: "[\(firstService.ServiceID)] \(getTimeFromDateString(from: firstService.ExpectedDeparture))")
			largeFlat.body2TextProvider = CLKSimpleTextProvider(text: "\(firstService.DepartureStatus ?? "No Data")" )

			handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: largeFlat))
		}
	}

	func reloadData() {
		let server = CLKComplicationServer.sharedInstance()
		guard let complications = server.activeComplications, complications.count > 0 else { return }
		for complication in complications  {
			server.reloadTimeline(for: complication)
		}
	}

	// MARK: Time Travel
	func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Swift.Void) {
		handler([])
	}

}
