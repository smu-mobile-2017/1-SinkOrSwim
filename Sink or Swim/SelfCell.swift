//
//  SelfCell.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/8/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class SelfCell: UITableViewCell, GenericListingCell {

	// A self post *has* a URL, but it just links to the
	// reddit page containing the text. It has a `self`
	// property with that text. Instead, pressing on this
	// cell, we just display a PostSelfViewController with
	// the text.
	//
	// The self cell is laid out as follows:
	//
	// [upperDetailLabel] "SELF"
	// [titleLabel]
	// [lowerDetailLabel]
	//
	
	@IBOutlet weak var upperDetailLabel: UILabel!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var lowerDetailLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
