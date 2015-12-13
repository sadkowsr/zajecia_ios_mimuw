//
//  RegularPolygon.swift
//  TablesAndPolygons
//
//  Created by Kajetan Dąbrowski on 08.11.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import Foundation

let PolygonDidChangeNotification: String = "com.daftmobile.RegularPolygon.numberOfSidesDidChange"

class RegularPolygon
{
	var numberOfSides: Int {
		didSet {
			//Validate the value
			self.numberOfSides = RegularPolygon.validatedNumberOfSidesForNumberOfSides(self.numberOfSides)
			if oldValue != self.numberOfSides {
				//Inform everyone that model has changed (perhaps something needs to be redrawn)
				NSNotificationCenter.defaultCenter().postNotificationName(PolygonDidChangeNotification, object: self, userInfo: nil)
			}
		}
	}
	
	//Initializer
	init(numberOfSides: Int) {
		self.numberOfSides = RegularPolygon.validatedNumberOfSidesForNumberOfSides(numberOfSides)
	}
	
	func unarVertexLocationForVertexAtIndex(index: Int) -> (x: Double, y: Double) {
		//
		let center: (x: Double, y: Double) = (0.5, 0.5)
		let circleRadius: Double = 0.5
		
		// x and y computed from radial coordinates
		// https://en.wikipedia.org/wiki/Polar_coordinate_system
		let x: Double = circleRadius * cos(2.0 * M_PI * Double(index) / Double(self.numberOfSides))
		let y: Double = circleRadius * sin(2.0 * M_PI * Double(index) / Double(self.numberOfSides))
		
		return (center.x + x, center.y + y)
	}
	
	//MARK: Value validation
	static let minNumberOfSides: Int = 3
	private static func validatedNumberOfSidesForNumberOfSides(numberOfSides: Int) -> Int {
		return max(RegularPolygon.minNumberOfSides, numberOfSides)
	}
}

extension RegularPolygon: CustomStringConvertible
{
	var description: String {
		get {
			return "Polygon with \(self.numberOfSides) sides"
		}
	}
}