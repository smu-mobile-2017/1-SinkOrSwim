//
//  CustomModalView.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

protocol CustomModalViewDelegate: class {
	func didTouchModalConfirmButton(sender: CustomModalView)
}

class CustomModalView: UIView {

	@IBOutlet weak var modalMessage: UILabel!
	weak var delegate: CustomModalViewDelegate?

	@IBAction func didTouchConfirmButton(_ sender: UIButton) {
		guard let delegate = delegate else {
			print("Warning: CustomModalView has no delegate on didTouchConfirmButton")
			return
		}
		delegate.didTouchModalConfirmButton(sender: self)
	}
}
