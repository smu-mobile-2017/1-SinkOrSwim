//
//  RedditThing.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/5/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import Foundation

// All content on Reddit, including link posts, image posts, and self (text) posts
// (represented as RedditLink) are generalized by Reddit's backend to "things".
// Things are defined by their unique ID, which we represent in the RedditName struct.
protocol RedditThing {
	var thing: RedditName { get }
}
