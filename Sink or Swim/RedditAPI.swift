//
//  RedditAPI.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/5/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import Foundation
import PromiseKit
import Alamofire

enum RedditAPIError: Error {
	case offline
	case dataCastToJSONFailed
	case unexpectedResponseStructure
	case deserializationFailed
	case imageLoadFailed
}

class RedditAPI {
	typealias JSONDictionary = [String: Any]
	static let rootURL: URL = URL(string: "https://reddit.com")!
	
	private static func baseRequest(
		to url: URL,
		withMethod method: HTTPMethod,
		passingParameters parameters: Parameters
	) -> Promise<JSONDictionary> {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		
		return Alamofire.request(url, parameters: parameters).responseJsonDictionary()
		.always {
			UIApplication.shared.isNetworkActivityIndicatorVisible = false
		}
	}
	
	static func hotPosts(inSubreddit subreddit: String?, limit: UInt)
	throws -> Promise<[RedditLink]> {
		let q = DispatchQueue.global()
		
		var url: URL = rootURL
		if let s = subreddit {
			url = url.appendingPathComponent("r/\(s)")
		}
		url = url.appendingPathComponent("hot.json")
		
		let parameters: Parameters = ["limit": limit]
		
		return baseRequest(to: url, withMethod: .get, passingParameters: parameters)
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
		let q = DispatchQueue.global()
		return Alamofire.request(url).validate(contentType: ["image/*"])
		.responseData().then(on: q) { data in
			return UIImage(data: data)!
		}
	}
	
}
