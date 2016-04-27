//
//  Trend.swift
//  TwitterTrends
//
//  Created by Kajetan Dąbrowski on 27/04/16.
//  Copyright © 2016 DaftMobile. All rights reserved.
//

import Foundation
import CoreData

class Trend: NSManagedObject
{
	
}


//MARK: Parsowanie
extension Trend
{
	private static let JSON_KEY_NAME: String = "name"
	private static let JSON_KEY_QUERY: String = "query"
	private static let JSON_KEY_TWEETVOLUME: String = "tweet_volume"
	private static let JSON_KEY_URL: String = "url"
	
	private static let FULLJSON_KEY_TRENDS: String = "trends"
	
	//	Stwórz trend jeśli nie ma już takiego
	//	Jeśli jest – pobierz, uaktualnij i zwróć
	class func createOrUpdateTrendWithJSONData(jsonData: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> Trend {
		
//		Kluczem w bazie danych jest NAME – potrzebujemy go z JSONa
		let name: String = jsonData.objectForKey(JSON_KEY_NAME) as! String
		
//		Tworzymy zapytanie
		let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Trend")
		fetchRequest.predicate = NSPredicate(format: "name == %@", name) //zwróć tylko taki z identyczną nazwą
		fetchRequest.fetchLimit = 1 //potrzebujemy tylko jednego
		
		var trendToReturn: Trend? = nil
		
//		Spróbuj pobrać istniejący rekord z bazy
		trendToReturn = try! managedObjectContext.executeFetchRequest(fetchRequest).first as? Trend
		
		if trendToReturn == nil {
//			Nie było takiego rekordu w bazie, musimy stworzyć nowy
//			print("INSERTING NEW TREND FOR NAME \(name)")
			trendToReturn = NSEntityDescription.insertNewObjectForEntityForName("Trend", inManagedObjectContext: managedObjectContext) as? Trend
			trendToReturn?.name = name
		} else {
//			Nic nie musimy robić
//			print("FOUND TREND WITH NAME \(name)")
		}
		
		//Wypełnij dane (lub uaktualnij)
		trendToReturn!.query = jsonData.objectForKey(JSON_KEY_QUERY) as? String
		trendToReturn!.url = jsonData.objectForKey(JSON_KEY_URL) as? String
		trendToReturn!.tweetVolume = jsonData.objectForKey(JSON_KEY_TWEETVOLUME) as? NSNumber
		
		return trendToReturn!
	}
	
	
	class func createOrUpdateTrendsForLoadedFullJSON(fullJSON: NSDictionary, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [Trend] {
		
//		Sposób nr 1: łatwiejszy
//		To co zwrócimy
		var trendsToReturn: [Trend] = []
//		Wyciągamy ARRAY'a trendów
		let jsonsArray: NSArray = fullJSON.objectForKey(FULLJSON_KEY_TRENDS) as! NSArray
//		Enumerujemy array'a i dla każdego wewnętrznego JSONa który jest NSDictionary, parsujemy funkcją wyżej
		for singleTrendJson in jsonsArray {
			let createdOrUpdatedTrend = Trend.createOrUpdateTrendWithJSONData(singleTrendJson as! NSDictionary, inManagedObjectContext: managedObjectContext)
//			Dodajemy do tablicy
			trendsToReturn.append(createdOrUpdatedTrend)
		}
		return trendsToReturn
		
//		Sposób nr 2: ładniejszy, w jednej linijce
		/*
		return (fullJSON.objectForKey(FULLJSON_KEY_TRENDS) as! NSArray).map({ Trend.createOrUpdateTrendWithJSONData($0 as! NSDictionary, inManagedObjectContext: managedObjectContext)})
		*/
	}

}