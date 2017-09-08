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

// A number of possible errors.
// Not all of these are currently used.
enum RedditAPIError: Error {
	case offline
	case dataCastToJSONFailed
	case unexpectedResponseStructure
	case deserializationFailed
	case imageLoadFailed
	case httpLibraryError
}

class RedditAPI {
	
	// All of the code to interface with reddit.
	
	typealias JSONDictionary = [String: Any]
	
	// The base URL of the API. This is used to append known
	// API paths to a base that may in the future change.
	static let rootURL: URL = URL(string: "https://reddit.com")!
	
	// The wrapper function for all JSON API requests.
	// Takes a URL, array of parameters, and returns a Promise
	// to a JSONDictionary that will be fulfilled asynchronously
	// if the request, and the subsequent JSON parsing, is successful.
	private static func baseRequest(to url: URL, withParameters parameters: [String: Any]) -> Promise<JSONDictionary> {
		// Spin the little network indicator in the top left
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		// We return a promise to avoid callback hell.
		return Promise<Data> { fulfill, reject in
			// Just is our HTTP library (used half of the time)
			Just.get(url, params: parameters) { response in
				if response.ok, let data = response.content {
					fulfill(data) // Fulfill the promise
				} else {
					reject(RedditAPIError.httpLibraryError) // Fail the promise
				}
			}
		}.then { data -> JSONDictionary in
			// Promises can be chained. This step of the chain parses the JSON.
			guard let json = try? JSONSerialization.jsonObject(with: data, options: []),
			let jsonDict = json as? JSONDictionary else {
				throw RedditAPIError.dataCastToJSONFailed
			}
			// This only succeeds if JSON can be parsed AND if the root element is a Dict.
			return jsonDict
		}.always {
			// Succeed or fail, always stop the spinning indicator at the end.
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	// Load the top Hot posts (one of many sorting methods proprietary to reddit)
	// By default from the "Front page," or optionally from a subreddit.
	// Can be limited to a number <100. The API always limits to 100.
	static func hotPosts(inSubreddit subreddit: String?, limit: UInt)
	throws -> Promise<[RedditLink]> {
		return try getPosts(underFile: "hot.json", inSubreddit: subreddit, limit: limit)
	}
	
	// Load the Newest posts either on the Front page or from a subreddit. See above.
	static func newPosts(inSubreddit subreddit: String?, limit: UInt)
	throws -> Promise<[RedditLink]> {
		return try getPosts(underFile: "new.json", inSubreddit: subreddit, limit: limit)
	}
	
	// Load a Listing (array of posts) from the given API path 
	// (generalization of hotPosts and newPosts)
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
	
	// Parsing a JSONDictionary object supposedly representing a Listing (array of posts)
	// into an array of RedditLink structs ("link" = reddit jargon for post)
	static func convertJSONToLinks(_ json: JSONDictionary)
	throws -> [RedditLink] {
		var result = [RedditLink]()
		
		// json = { "data": { "children": [{},{},{}] } }
		// Try to open the "data" key of the root dictionary,
		// Then the "children" key within the resulting dictionary
		guard let listingData = json["data"] as? JSONDictionary,
		let listingChildren = listingData["children"] as? [JSONDictionary] else {
			throw RedditAPIError.unexpectedResponseStructure
		}
		
		// listingChildren = [{"kind":"t3","data":{}}]
		// Given an array of dictionaries supposedly representing links (posts)
		// Try to parse each dictionary into a RedditLink.
		for child in listingChildren {
			guard let linkObject = child["data"] as? JSONDictionary else {
				throw RedditAPIError.unexpectedResponseStructure
			}
			// Pass the JSON link object onto RedditLink's 
			// JSON deserialization factory.
			guard let link = RedditLink(fromJSON: linkObject) else {
				throw RedditAPIError.deserializationFailed
			}
			result.append(link)
		}
		return result
	}
	
	// Asynchronously load an image through a Promise.
	static func loadImage(_ url: URL) -> Promise<UIImage> {
		// We don't use the Just HTTP library here because this code already
		// worked before we incorporated Just.
		return Promise { fulfill, reject in
			// Load the data, cast it to an image, then fulfill the promise.
			let task = URLSession.shared.dataTask(with: url) { data, response, error in
				if let data = data, let image = UIImage(data: data) {
					fulfill(image)
				} else {
					// Probably an HTTP error. Warrants further error handling.
					reject(RedditAPIError.imageLoadFailed)
				}
			}
			task.resume() // execute the above task.
		}
	}
	
	// The mock Ad server, returns a string promise that is fulfilled after
	// an artificial delay, to emulate a web request and represent best async
	// practices. See AdvertisementCell.
	static func getAdvertisementMessage() -> Promise<String> {
		// mock advertisement server
		return after(seconds: 1).then {
			return Promise { fulfill, reject in
				// The mock ad text
				let ads = [
					"🍎 Alan's Apples are Always Amazing!",
					"🍌 Buy Bob's Bananas: Bargain Bonanza!",
					"🍒 Chen's Cherries Chime-in Cheer!"
				]
				// Pick one randomly to fulfill the promise with.
				let randomChoice = Int(arc4random_uniform(UInt32(ads.count)))
				fulfill(ads[randomChoice])
			}
		}
	}
	
}
