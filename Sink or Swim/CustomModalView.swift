//
//  CustomModalView.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class CustomModalView: UIView {

	@IBOutlet weak var modalMessage: UILabel!

	@IBAction func didTouchConfirmButton(_ sender: UIButton) {
		print("CONFIRM")
	}
}
