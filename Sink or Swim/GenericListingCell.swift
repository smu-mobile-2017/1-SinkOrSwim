//
//  GenericListingCell.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/8/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

// [CITE] https://stackoverflow.com/a/24561630/3592716
// must declare as @objc to accept @IBOutlets as fulfilling
// property requirements
@objc protocol GenericListingCell: class {
	var titleLabel: UILabel! { get }
	var upperDetailLabel: UILabel! { get }
	var lowerDetailLabel: UILabel! { get }
}
