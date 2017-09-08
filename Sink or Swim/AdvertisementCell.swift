//
//  AdvertisementCell.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class AdvertisementCell: UITableViewCell {
	
	@IBOutlet weak var advertisementMessage: UILabel!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		updateLoadedState(message: nil)
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func updateLoadedState(message: String?) {
		DispatchQueue.main.async {
			if let message = message {
				self.advertisementMessage.text = message
				self.activityIndicator.stopAnimating()
			} else {
				self.advertisementMessage.text = ""
				self.activityIndicator.startAnimating()
			}
		}
	}
	
}
