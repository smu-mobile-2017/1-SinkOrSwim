//
//  RedditLink.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/5/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

struct RedditLink: RedditThing {
	let domain: String
	let subreddit: String
	let selfTextHTML: String?
	let selfText: String
	let thing: RedditName
	let title: String
	let score: Int
	let isOver18: Bool
	let isSelf: Bool
	let thumbnailURL: URL?
	let url: URL
	let author: String
	
	init?(fromJSON o: [String: Any]) {
		guard
			let domain = o["domain"] as? String,
			let subreddit = o["subreddit"] as? String,
			let selfText = o["selftext"] as? String,
			let title = o["title"] as? String,
			let score = o["score"] as? Int,
			let author = o["author"] as? String,
			let _fullName = o["name"] as? String,
			let over18 = o["over_18"] as? Bool,
			let isSelf = o["is_self"] as? Bool,
			let _urlString = o["url"] as? String,
			let url = URL(string: _urlString)
		else { return nil }
		
		self.domain		= domain
		self.subreddit	= subreddit
		self.selfText	= selfText
		self.thing		= RedditName(fullName: _fullName)
		self.title		= title
		self.score		= score
		self.isOver18	= over18
		self.isSelf		= isSelf
		self.url		= url
		self.author		= author
		
		self.selfTextHTML = o["selftext_html"] as? String
		if let _thumbnailURLString = o["thumbnail"] as? String,
			_thumbnailURLString != "default",
			_thumbnailURLString != "self"
		{
			self.thumbnailURL = URL(string: _thumbnailURLString)
		} else {
			self.thumbnailURL = nil
		}
	}
}
