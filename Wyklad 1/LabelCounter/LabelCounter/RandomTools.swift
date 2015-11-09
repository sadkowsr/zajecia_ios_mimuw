//
//  RandomTools.swift
//  LabelCounter
//
//  Created by Kajetan Dąbrowski on 24.10.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import Foundation

class RandomTools {
	class func randomBool() -> Bool {
		return (self.randomInt(0, max: 1) == 0) ? false : true
	}
	
	class func randomBool(probability probability: Double) -> Bool {
		if probability <= 0.0 { return false }
		if probability >= 1.0 { return true }
		return RandomTools.randomDouble(0.0, max: 1.0) <= probability
	}
	
	class func randomInt(min: Int, max: Int) -> Int {
		assert(max >= min, "Max should be greater than min")
		if max == min {
			return min
		}
		let result: Int = Int(arc4random_uniform(UInt32(max - min + 1)))
		return result + min
	}
	
	class func randomDouble(min: Double, max: Double) -> Double {
		if min > max {
			return 0.0
		}
		let result = drand48() * (max - min)
		return result + min
	}
}

extension Array
{
	func randomElement() -> Element {
		return self[RandomTools.randomInt(0, max: self.count-1)]
	}
}
