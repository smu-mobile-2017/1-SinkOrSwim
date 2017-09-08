//
//  RedditName.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/5/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import Foundation

// The unique ID required by all Reddit "thing" entities. Consists of a
// type ("kind") identifier, and an ID. The "fullname" is the type and ID,
// joined by an underscore.
struct RedditName {
	var kind: String
	var id: String
	
	var fullName: String {
		get {
			return "\(kind)_\(id)"
		}
		set {
			let parts = newValue.components(separatedBy: "_")
			id = parts[1]
			kind = parts[0]
		}
	}
	
	init(fullName: String) {
		self.kind = ""
		self.id = ""
		self.fullName = fullName
	}
	
	init(kind: String, id: String) {
		self.kind = kind
		self.id = id
	}
}
