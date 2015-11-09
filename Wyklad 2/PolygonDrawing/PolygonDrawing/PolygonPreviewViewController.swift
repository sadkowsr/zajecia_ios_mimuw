//
//  PolygonPreviewViewController.swift
//  PolygonDrawing
//
//  Created by Kajetan Dąbrowski on 08.11.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import UIKit


class PolygonPreviewViewController: UIViewController
{
	//View
	@IBOutlet var polygonView: PolygonView!
	@IBOutlet var polygonDescriptionLabel: UILabel!
	
	//Model
	private let polygon: RegularPolygon = RegularPolygon(numberOfSides: 4)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//Start listening for notifications from our model (so we can update our view)
		//func polygonDidChange() will be called every our polygon posts that notification.
		NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("polygonDidChange"), name: PolygonDidChangeNotification, object: self.polygon)
		self.setupPolygonView()
		self.refreshPolygon()
	}
	
	deinit {
		//Remove ourselves from notification that we subscribed to
		NSNotificationCenter.defaultCenter().removeObserver(self, name: PolygonDidChangeNotification, object: self.polygon)
	}
	
	func polygonDidChange() {
		self.refreshPolygon()
	}
	
	@IBAction func minusButtonPressed(sender: AnyObject) {
		self.polygon.numberOfSides--
		//Notice that we don't force-refresh here: our MODEL will post a notification
	}
	
	@IBAction func plusButtonPressed(sender: AnyObject) {
		self.polygon.numberOfSides++
		//Notice that we don't force-refresh here: our MODEL will post a notification
	}
	
	private func setupPolygonView() -> Void {
		//Set the Data Source on our view
		self.polygonView.dataSource = self
		
		//Setup some color and line widths
		self.polygonView.fillColor = UIColor.redColor().colorWithAlphaComponent(0.3)
		self.polygonView.strokeColor = UIColor.redColor()
		self.polygonView.lineWidth = 4.0
	}

	private func refreshPolygon() {
		//Update label!
		self.polygonDescriptionLabel.text = self.polygon.description
		
		//We're telling our view to redraw itself
		self.polygonView.setNeedsDisplay()
	}
}

//It's nice to put protocol implementations in extensions: code clarity
extension PolygonPreviewViewController: PolygonViewDataSource
{
	func numberOfVerticesInPolygonView(polygonView: PolygonView) -> Int {
		return self.polygon.numberOfSides
	}
	
	func polygonView(polygonView: PolygonView, unarCoordinatedsForVertexAtIndex vertexIndex: Int) -> CGPoint {
		let coordinatesInUnar: (x: Double, y: Double) = self.polygon.unarVertexLocationForVertexAtIndex(vertexIndex)
		return CGPointMake(CGFloat(coordinatesInUnar.x), CGFloat(coordinatesInUnar.y))
	}
}