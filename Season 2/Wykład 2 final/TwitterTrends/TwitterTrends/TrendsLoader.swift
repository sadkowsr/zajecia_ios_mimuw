//
//  TrendsLoader.swift
//  TwitterTrends
//
//  Created by Kajetan Dąbrowski on 29/02/16.
//  Copyright © 2016 DaftMobile. All rights reserved.
//

import Foundation

struct Trend
{
	let title: String
	let url: NSURL
}

protocol TrendsLoader
{
	func loadTrends() -> Void
	var trends: [Trend] { get }
}


class TrendsLoaderLocal: TrendsLoader
{
	private(set) var trends: [Trend] = []
	private let fileName: String
	
	init(fileName: String)
	{
		self.fileName = fileName
	}
	
	private static func convertRecordToTrend(record: NSDictionary) -> Trend {
		let name: String = record.objectForKey("name") as! String
		let url: NSURL = NSURL(string: record.objectForKey("url") as! String)!
		return Trend(title: name, url: url)
	}
	
	private static func jsonToTrendsArray(json: NSDictionary) -> [Trend] {
		let trendsArray: NSArray = json.objectForKey("trends") as! NSArray
		var allConvertedTrends: [Trend] = []
		for trend in trendsArray {
			let trendDictionary = trend as! NSDictionary
			let convertedTrend: Trend = self.convertRecordToTrend(trendDictionary)
			allConvertedTrends.append(convertedTrend)
		}
		return allConvertedTrends
	}
	
	func loadTrends() -> Void {
		let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: "json")!
		let fileData: NSData = NSData(contentsOfURL: url)!
		let json = try! NSJSONSerialization.JSONObjectWithData(fileData, options: [])
		
		self.trends = TrendsLoaderLocal.jsonToTrendsArray(json as! NSDictionary)
	}
}
