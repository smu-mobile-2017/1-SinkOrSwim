//
//  RedditAPI.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/5/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import Foundation
import PromiseKit
import Just

enum RedditAPIError: Error {
	case offline
	case dataCastToJSONFailed
	case unexpectedResponseStructure
	case deserializationFailed
	case imageLoadFailed
	case httpLibraryError
}

class RedditAPI {
	
	typealias JSONDictionary = [String: Any]
	static let rootURL: URL = URL(string: "https://reddit.com")!
	var imageCache: NSCache<NSURL,UIImage> = NSCache()
	
	private static func baseRequest(to url: URL, withParameters parameters: [String: Any]) -> Promise<JSONDictionary> {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		return Promise<Data> { fulfill, reject in
			Just.get(url, params: parameters) { response in
				if response.ok, let data = response.content {
					fulfill(data)
				} else {
					reject(RedditAPIError.httpLibraryError)
				}
			}
		}.then { data -> JSONDictionary in
			guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
			let jsonDict = json as? JSONDictionary else {
				throw RedditAPIError.dataCastToJSONFailed
			}
			return jsonDict
		}.always {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func hotPosts(inSubreddit subreddit: String?, limit: UInt)
	throws -> Promise<[RedditLink]> {
		return try getPosts(underFile: "hot.json", inSubreddit: subreddit, limit: limit)
	}
	
	static func newPosts(inSubreddit subreddit: String?, limit: UInt)
	throws -> Promise<[RedditLink]> {
		return try getPosts(underFile: "new.json", inSubreddit: subreddit, limit: limit)
	}
	
	static func getPosts(underFile file: String, inSubreddit subreddit: String?, limit: UInt)
		throws -> Promise<[RedditLink]> {
			let q = DispatchQueue.global()
			
			var url: URL = rootURL
			if let s = subreddit {
				url = url.appendingPathComponent("r/\(s)")
			}
			url = url.appendingPathComponent(file)
			
			return baseRequest(to: url, withParameters: ["limit": limit])
				.then(on: q) { json in
					try convertJSONToLinks(json)
			}
	}
	
	static func convertJSONToLinks(_ json: [String: Any])
	throws -> [RedditLink] {
		var result = [RedditLink]()
		// json = { "data": { "children": [{},{},{}] } }
		guard let listingData = json["data"] as? JSONDictionary,
		let listingChildren = listingData["children"] as? [JSONDictionary] else {
			throw RedditAPIError.unexpectedResponseStructure
		}
		// listingChildren = [{"kind":"t3","data":{}}]
		for child in listingChildren {
			guard let linkObject = child["data"] as? JSONDictionary else {
				throw RedditAPIError.unexpectedResponseStructure
			}
			guard let link = RedditLink(fromJSON: linkObject) else {
				throw RedditAPIError.deserializationFailed
			}
			result.append(link)
		}
		return result
	}
	
	static func loadImage(_ url: URL) -> Promise<UIImage> {
//		return Promise { fulfill, reject in
//			let urlString = NSString(string: url.absoluteString)
//			self.imageCache
//		}
//		return Alamofire.request(url.absoluteString)
//		.validate(contentType: ["image/*"])
//		.response(completionHandler: { response in
//			return UIImage(data: response)!
//		})
		
		return Promise { fulfill, reject in
			let task = URLSession.shared.dataTask(with: url) { data, response, error in
				if let image = UIImage(data: data!) {
					fulfill(image)
				} else {
					reject(RedditAPIError.imageLoadFailed)
				}
			}
			task.resume()
		}
	}
	
	static func getAdvertisementMessage() -> Promise<String> {
		// mock advertisement server
		return after(seconds: 1).then {
			return Promise { fulfill, reject in
				let ads = [
					"🍎 Alan's Apples are Always Amazing!",
					"🍌 Buy Bob's Bananas: Bargain Bonanza!",
					"🍒 Chen's Cherries Chime-in Cheer!"
				]
				let randomChoice = Int(arc4random_uniform(UInt32(ads.count)))
				fulfill(ads[randomChoice])
			}
		}
	}
	
}
