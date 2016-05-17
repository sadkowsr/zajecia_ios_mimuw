//
//  RemoteTrendsLoader.swift
//  TwitterTrends
//
//  Created by Kajetan Dąbrowski on 10/05/16.
//  Copyright © 2016 DaftMobile. All rights reserved.
//

import Foundation

class RemoteTrendsLoader: TrendsLoader
{
	//Session służące do komunikacji z internetem
	private let urlSession: NSURLSession
	
	//URL z którego będziemy pobierali dane (czyli https://.....)
	private let urlToLoad: NSURL
	
	init(urlString: String) {
		self.urlToLoad = NSURL(string: urlString)!
		
		//Ephemeral Session Configuration - bez użycia cache'y
		let sessionConfiguration: NSURLSessionConfiguration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
		self.urlSession = NSURLSession(configuration: sessionConfiguration)
	}
	
	func loadTrendsCompletion(completion: ((loadedTrends: NSDictionary?) -> Void)) {
		
		//Tworzymy DATA TASK – przy pomocy url session – zadanie które session wykona
		//argument – completion block - to co się stanie po wykonaniu zapytania
		let dataTask: NSURLSessionDataTask = self.urlSession.dataTaskWithURL(self.urlToLoad) { (data: NSData?, response: NSURLResponse?, error: NSError?) in
			let completionClosureInMainQueue: ((NSDictionary?) -> Void) = { (trends: NSDictionary?) -> Void in
				dispatch_async(dispatch_get_main_queue(), { 
					completion(loadedTrends: trends)
				})
			}
			
			//Zapewniamy, że response jest typu NSHTTPURLResponse oraz że statusCode jest 200 (nie ma błędów)
			guard let response = response as? NSHTTPURLResponse where response.statusCode == 200 else {
				//Jeśli jeden z warunków nie jest spełniony, wywołujemy completion(nil) – żeby wywołujący wiedzial że coś się nie powiodło
				completionClosureInMainQueue(nil)
				return
			}
			
			//j.w.
			guard let data = data else {
				completionClosureInMainQueue(nil)
				return
			}
			//blok DO – do łapania wyjątków
			do {
				//parsowanie JSON'a przy pomocy NSJSONSerialization
				if let json: NSDictionary = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
					//Jeśli się udało i jeśli dostaliśmy NSDictionary – informujemy wywołującego uruchamiając przekazany nam completion block
					completionClosureInMainQueue(json)
					return
				} else {
					//Jeśli się nie udało – w danych nie było NSDictionary - informujemy o błędzie
					completionClosureInMainQueue(nil)
					return
				}
			} catch {
				//Niepoprawny JSON w data
				completionClosureInMainQueue(nil)
			}
		}
		
		//Faktyczne uruchomienie zadania
		dataTask.resume()
	}
}

