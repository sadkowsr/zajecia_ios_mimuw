//
//  TrendsLoader.swift
//  TwitterTrends
//
//  Created by Kajetan Dąbrowski on 29/02/16.
//  Copyright © 2016 DaftMobile. All rights reserved.
//

import Foundation


protocol TrendsLoader
{
	//Funkcja ładująca array trendów (skądś – na przykład z dysku). Po zakończeniu operacji, która może, ale nie musi być asynchroniczna, wywołuje completion block
	func loadTrendsCompletion(completion: ((loadedTrends: NSDictionary?) -> Void)) -> Void
}


class TrendsLoaderLocal: TrendsLoader
{
	private let fileName: String
	
	init(fileName: String) {
		self.fileName = fileName
	}
	
	func loadTrendsCompletion(completion: ((loadedTrends: NSDictionary?) -> Void)) {
		//ścieżka do pliku
		let url = NSBundle.mainBundle().URLForResource(self.fileName, withExtension: "json")!
		
		//wczytywanie pliku
		let fileData: NSData = NSData(contentsOfURL: url)!
		
		//Konwersja pliku (NSData) do JSONa – robiona przy pomocy bibliotecznej funkcji
		if let json: NSDictionary? = try? NSJSONSerialization.JSONObjectWithData(fileData, options: []) as? NSDictionary where json != nil  {
			//Udało się załadować i wczytano NSDictionary
			completion(loadedTrends: json)
		} else {
			//Coś się nie udało, wywołujemy completion block od nila
			completion(loadedTrends: nil)
		}
		
	}
}
