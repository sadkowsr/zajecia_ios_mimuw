//
//  ViewController.swift
//  TwitterTrends
//
//  Created by Kajetan Dąbrowski on 29/02/16.
//  Copyright © 2016 DaftMobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	private let trendsLoader: TrendsLoader = TrendsLoaderLocal(fileName: "trends")

	override func viewDidLoad() {
		super.viewDidLoad()
		self.trendsLoader.loadTrends()
	}
}


extension ViewController: UITableViewDataSource
{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.trendsLoader.trends.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		//get model
		let trend: Trend = self.trendsLoader.trends[indexPath.row]
		//get cell
		let cell: TrendCell = tableView.dequeueReusableCellWithIdentifier("TREND_CELL") as! TrendCell
		//configure cell
		cell.trendNameLabel.text = trend.title
		cell.trendURLLabel.text = trend.url.absoluteString
		//return cell
		return cell
	}
}

extension ViewController: UITableViewDelegate
{
	func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		tableView.deselectRowAtIndexPath(indexPath, animated: true)
		let selectedTrend: Trend = self.trendsLoader.trends[indexPath.row]
		let urlToOpen: NSURL = selectedTrend.url
		
		if UIApplication.sharedApplication().canOpenURL(urlToOpen) {
			let alertController: UIAlertController = UIAlertController(title: "Trend", message: "Do you want to open trend \"\(selectedTrend.title)\"?", preferredStyle: UIAlertControllerStyle.Alert)
			alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
			alertController.addAction(UIAlertAction(title: "Open", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) -> Void in
				UIApplication.sharedApplication().openURL(urlToOpen)
			}))
			self.presentViewController(alertController, animated: true, completion: nil)
		}
	}
}
