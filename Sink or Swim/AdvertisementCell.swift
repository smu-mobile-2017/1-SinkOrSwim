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
			print("Update state \(message ?? "nil")")
			if let message = message {
				print("messageful state")
				self.advertisementMessage.text = message
				self.activityIndicator.stopAnimating()
			} else {
				print("messageless state")
				self.advertisementMessage.text = ""
				self.activityIndicator.startAnimating()
			}
		}
	}
	
}
