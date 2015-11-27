//
//  PolygonPreviewViewController.swift
//  TablesAndPolygons
//
//  Created by Kajetan Dąbrowski on 08.11.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import UIKit


class PolygonPreviewViewController: UIViewController
{
	//View
	@IBOutlet var minusButton: UIButton!
	@IBOutlet var plusButton: UIButton!
	@IBOutlet var polygonView: PolygonView!
	@IBOutlet var polygonDescriptionLabel: UILabel!
	var shouldAllowEditing: Bool = true {
		didSet {
			self.updateButtonVisibility()
		}
	}
	
	//Model
	var polygon: RegularPolygon = RegularPolygon(numberOfSides: 4) {
		didSet {
			self.refreshPolygon()
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//Start listening for notifications from our model (so we can update our view)
		//func polygonDidChange() will be called every our polygon posts that notification.
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("polygonDidChange"), name: PolygonDidChangeNotification, object: self.polygon)
		self.setupPolygonView()
		self.refreshPolygon()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		self.refreshPolygon()
		self.updateButtonVisibility()
	}
	
	deinit {
		//Remove ourselves from notification that we subscribed to
		NSNotificationCenter.defaultCenter().removeObserver(self, name: PolygonDidChangeNotification, object: self.polygon)
	}
	
	func polygonDidChange() {
		self.refreshPolygon()
	}
	
	@IBAction func minusButtonPressed(sender: AnyObject) {
		if !self.shouldAllowEditing { return }
		self.polygon.numberOfSides--
		//Notice that we don't force-refresh here: our MODEL will post a notification
	}
	
	@IBAction func plusButtonPressed(sender: AnyObject) {
		if !self.shouldAllowEditing { return }
		self.polygon.numberOfSides++
		//Notice that we don't force-refresh here: our MODEL will post a notification
	}
	
	private func setupPolygonView() -> Void {
		//Setup some color and line widths
		self.polygonView.fillColor = self.polygonView.tintColor.colorWithAlphaComponent(0.25)
		self.polygonView.strokeColor = self.polygonView.tintColor
		self.polygonView.lineWidth = 2.0
	}

	private func refreshPolygon() {
		//Update label!
		self.polygonDescriptionLabel?.text = self.polygon.description
		self.navigationItem.title = self.polygon.description
		self.polygonView?.numberOfSides = self.polygon.numberOfSides
	}
	
	private func updateButtonVisibility() {
		self.minusButton?.hidden = !self.shouldAllowEditing
		self.plusButton?.hidden = !self.shouldAllowEditing
	}
}