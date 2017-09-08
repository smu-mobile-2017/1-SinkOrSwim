//
//  SelfCell.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/8/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class SelfCell: UITableViewCell, GenericListingCell {

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