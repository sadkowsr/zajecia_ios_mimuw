//
//  Counter.swift
//  LabelCounter
//
//  Created by Kajetan Dąbrowski on 24.10.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import Foundation

let CounterDidChangeCountNotification: String = "com.daftmobile.LabelCounter.CounterDidChange"
class Counter
{
	//MARK: Private
	
	private var storedValue: Int {
		didSet {
			if self.storedValue != oldValue {
				NSNotificationCenter.defaultCenter().postNotificationName(CounterDidChangeCountNotification, object: self)
			}
		}
	}
	
	//MARK: Initializers
	
	init(initialValue: Int) {
		self.storedValue = initialValue
	}
	
	//MARK: Public API
	
	var currentValue: Int {
		get {
			return self.storedValue
		}
	}
	
	func increment() {
		self.storedValue++
	}
	
	func decrement() {
		self.storedValue--
	}
	
	func applyRandomChangeAfterRandomTime() {
		let delay: NSTimeInterval = NSTimeInterval(RandomTools.randomDouble(0.4, max: 3.0))
		let randomValue: Int = RandomTools.randomInt(-100, max: 100)
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * pow(10,9))), dispatch_get_main_queue()) {[weak self] () -> Void in
			self?.storedValue = randomValue
		}
	}
}
