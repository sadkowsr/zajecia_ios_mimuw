//
//  ViewController.swift
//  LabelCounter
//
//  Created by Kajetan Dąbrowski on 24.10.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var countLabel: UILabel!
	let counter: Counter = Counter(initialValue: 0)
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("updateLabel"), name: CounterDidChangeCountNotification, object: nil)
		self.updateLabel()
	}
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: CounterDidChangeCountNotification, object: nil)
	}
	
	func updateLabel() {
		self.countLabel.text = "\(self.counter.currentValue)"
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	@IBAction func decrementButtonPressed(sender: AnyObject) {
		self.counter.decrement()
	}

	@IBAction func incrementButtonPressed(sender: AnyObject) {
		self.counter.increment()
	}
	
	@IBAction func randomizeButtonPressed(sender: AnyObject) {
		self.counter.applyRandomChangeAfterRandomTime()
	}
}

