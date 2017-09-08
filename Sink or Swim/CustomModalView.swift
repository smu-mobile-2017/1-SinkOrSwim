//
//  CustomModalView.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

// The only delegate method is an event handler that allows
// the delegate (presumably a VC) to close itself when the
// confirm button is tapped.
protocol CustomModalViewDelegate: class {
	func didTouchModalConfirmButton(sender: CustomModalView)
}

class CustomModalView: UIView {

	@IBOutlet weak var modalMessage: UILabel!
	
	// delegates should be weak to avoid cyclic dependency.
	weak var delegate: CustomModalViewDelegate?
	
	// The action trigger for when the confirm button is pressed.
	// Internal logic and actions are handled, then the event
	// "bubbles up" to the delegate through the 
	// didTouchModalConfirmButton(sender:) method.
	@IBAction func didTouchConfirmButton(_ sender: UIButton) {
		// If there's no delegate, nothing can close the modal...
		guard let delegate = delegate else {
			print("Warning: CustomModalView has no delegate on didTouchConfirmButton")
			return
		}
		
		// Internal logic to be handled before passing onto the delegate
		// can go here.
		
		// tell the delegate the button was pressed.
		delegate.didTouchModalConfirmButton(sender: self)
	}
}
