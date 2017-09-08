//
//  CustomModalViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

// The view controller for the custom modal (graduate requirement)
// that also acts as its delegate for the sole delegation function:
// the modal closing handler.
class CustomModalViewController: UIViewController, CustomModalViewDelegate {
	
	// a convenience property to cast the view
	// (that we know is a CustomModalView) to the
	// subclass to access its delegate property.
	var customModalView: CustomModalView {
		return view as! CustomModalView
	}
	
	// All we need to do is declare the VC as the delegate.
    override func viewDidLoad() {
        super.viewDidLoad()
		customModalView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// The sole function to be implemented as part of the
	// requirements of CustomModalViewDelegate.
	//
	// The CustomModalView cannot close the VC, so it tells
	// its delegate (the VC) to do so with 
	// UIViewController.dismiss(animated:completion:).
	func didTouchModalConfirmButton(sender: CustomModalView) {
		print("Delegating closing the VC for the Modal")
		dismiss(animated: true, completion: nil)
	}
}
