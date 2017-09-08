//
//  RedditLink.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/5/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

// A big, but *not complicated* struct containing all the properties
// we need from reddit links. The actual objects returned from the API
// contain many, many more props. We use the ones we need.

struct RedditLink: RedditThing {
	
	// Post link domain
	let domain: String
	
	// Subreddit the post was posted to
	let subreddit: String
	
	// If the self text has HTML, it's here
	let selfTextHTML: String?
	
	// Always has a value. For link posts, it's empty ("")
	// For self posts (text posts), it contains the plaintext.
	let selfText: String
	
	// The reddit name that identifies this "thing" (generalized
	// content object in reddit jargon)
	let thing: RedditName
	
	// The post title
	let title: String
	
	// The votes (upvotes minus downvotes, not related to how posts
	// are actually sorted)
	let score: Int
	
	// Is the post NSFW?
	let isOver18: Bool
	
	// Is the post a Self post (text based) rather than a Link?
	let isSelf: Bool
	
	// If the post is an image or webpage, the thumbnail.
	// Special URL placeholders such as "self", "link", and "image"
	// are used when the frontend is meant to show a categorical
	// placeholder
	let thumbnailURL: URL?
	
	// The post URL. If it's a link post, it's the URL of the link.
	// If it's a self post, it's an internal link to the reddit page
	// displaying the text.
	let url: URL
	
	// The username of the author.
	let author: String
	
	// A failable initializer that attempts to convert a JSONDictionary
	// [String: Any] into a RedditLink. Fails on required properties,
	// just inserts nil on failed optional properties.
	init?(fromJSON o: [String: Any]) {
		// Type Safe: casts to the relevant types.
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
		
		// Optional properties that can fail without failing
		// the initializer.
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
