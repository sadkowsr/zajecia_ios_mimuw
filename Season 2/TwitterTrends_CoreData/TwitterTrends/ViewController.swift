//
//  ViewController.swift
//  TwitterTrends
//
//  Created by Kajetan Dąbrowski on 29/02/16.
//  Copyright © 2016 DaftMobile. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController {

	private let trendsLoader: TrendsLoader = RemoteTrendsLoader(urlString: "https://dl.dropboxusercontent.com/u/61183547/trends_new.json")
	private let coreDataManager: CoreDataManager = CoreDataManager()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Złap Core Data Manadżera do lokalnej zmiennej (zarządzanie pamięcią)
		let coreDataManager: CoreDataManager = self.coreDataManager
		
		//Load trends
		self.trendsLoader.loadTrendsCompletion {[weak coreDataManager] (loadedTrends: NSDictionary?) in
			
			//completion block. Wykonuje się z trendsLoadera w momencie, kiedy zakończy wczytywanie
			
//			print(trends)
			
//			Jeśli trendy faktycznie są, i jeśli core data manager nie jest nilem
			if let loadedTrends = loadedTrends, coreDataManager = coreDataManager {
//				Parsujemy
				let parsedTrends: [Trend] = Trend.createOrUpdateTrendsForLoadedFullJSON(loadedTrends, inManagedObjectContext: coreDataManager.managedObjectContext)
//				Wyciągamy NAZWY (tylko na potrzeby debugu)
				let parsedTrendsNames: [String] = parsedTrends.map{$0.name!}
				print(parsedTrendsNames)
				
//				Opcjonalnie możemy teraz zapisać:
				coreDataManager.saveContext()
			}
		}
	}
}


extension ViewController: UITableViewDataSource
{
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		//TODO
		return 0
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		//TODO
		let cell: TrendCell = tableView.dequeueReusableCellWithIdentifier("TREND_CELL") as! TrendCell
		return cell
	}
}