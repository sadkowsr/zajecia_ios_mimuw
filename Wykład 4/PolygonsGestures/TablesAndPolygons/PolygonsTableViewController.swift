//
//  PolygonsTableViewController.swift
//  TablesAndPolygons
//
//  Created by Kajetan Dąbrowski on 23.11.2015.
//  Copyright © 2015 DaftMobile. All rights reserved.
//

import UIKit

class PolygonsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
	@IBOutlet var tableView: UITableView!
	
	private lazy var polygons: [RegularPolygon] = {
		let maxNumberOfSides = 50
		let minNumberOfSides = RegularPolygon.minNumberOfSides
		var myPolygons: [RegularPolygon] = []
		for numberOfSides in minNumberOfSides...maxNumberOfSides {
			myPolygons.append(RegularPolygon(numberOfSides: numberOfSides))
		}
		return myPolygons
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//For previewing on iPhone 6S and 6SPlus
		if UIApplication.sharedApplication().keyWindow?.traitCollection.forceTouchCapability == UIForceTouchCapability.Available
		{
			registerForPreviewingWithDelegate(self, sourceView: view)
		}
	}
	
	
	//MARK: TableView Data Source
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.polygons.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let reuseIdentifier: String = "polygon cell"
		let cell: PolygonTableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier) as! PolygonTableViewCell
		let model: RegularPolygon = self.polygonForRowAtIndexPath(indexPath)
		
		//Configure cell
		cell.polygonTitleLabel.text = "Polygon with \(model.numberOfSides) sides"
		cell.polygonView.numberOfSides = model.numberOfSides
		cell.polygonView.fillColor = cell.polygonView.tintColor.colorWithAlphaComponent(0.1)
		cell.polygonView.strokeColor = cell.polygonView.tintColor
		cell.polygonView.lineWidth = 1.0
		
		return cell
	}
	
	
	//MARK: PolygonView Data Source
	
	private func polygonForRowAtIndexPath(indexPath: NSIndexPath) -> RegularPolygon {
		return self.polygons[indexPath.row]
	}
	
	private func polygonForPolygonView(polygonView: PolygonView) -> RegularPolygon? {
		var cell: UIView? = polygonView
		while !(cell is UITableViewCell) {
			cell = cell?.superview
		}
		if let cell = cell as? UITableViewCell, indexPath = self.tableView.indexPathForCell(cell) {
			return self.polygonForRowAtIndexPath(indexPath)
		}
		return nil
	}
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showDetail" {
			if let destination = segue.destinationViewController as? PolygonPreviewViewController {
				let selectedCell = sender as! UITableViewCell
				let selectedIndexPath = self.tableView.indexPathForCell(selectedCell)!
				destination.polygon = self.polygonForRowAtIndexPath(selectedIndexPath)
				destination.shouldAllowEditing = false
				self.tableView.deselectRowAtIndexPath(selectedIndexPath, animated: true)
			}
		}
	}
}


// Some fun with previewing
extension PolygonsTableViewController: UIViewControllerPreviewingDelegate
{
	func previewingContext(previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		
		guard let indexPath = self.tableView.indexPathForRowAtPoint(self.tableView.convertPoint(location, fromView: previewingContext.sourceView)), cell = self.tableView.cellForRowAtIndexPath(indexPath) else { return nil }
		
		guard let previewViewController = storyboard?.instantiateViewControllerWithIdentifier("PolygonPreviewViewController") as? PolygonPreviewViewController else { return nil }
		
		let polygon = self.polygonForRowAtIndexPath(indexPath)
		previewViewController.polygon = polygon
		previewViewController.shouldAllowEditing = false
		previewingContext.sourceRect = previewingContext.sourceView.convertRect(cell.frame, fromView: self.tableView)
		
		return previewViewController
	}
	
	func previewingContext(previewingContext: UIViewControllerPreviewing, commitViewController viewControllerToCommit: UIViewController) {
		showViewController(viewControllerToCommit, sender: self)
	}
}