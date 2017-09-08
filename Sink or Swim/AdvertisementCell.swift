//
//  AdvertisementCell.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class AdvertisementCell: UITableViewCell {
	
	// The advertisement cell displays ad text that is
	// asynchronously loaded from the ad server.
	// Here it is mocked in the API class.
	// The cell displays a spinner until text is provided
	// when the promise resolves, and then hides the spinner
	// and shows the ad text. The cell dynamically readjusts
	// its height.
	
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
