//
//  ScrollViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

// A simple VC which has outlet bindings to the
// ScrollView and a UIView wrapping a UIImageView
// (in the storyboard)
class ScrollViewController: UIViewController {
	
	@IBOutlet weak var imageContainerView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// Required for desired zooming behavior.
extension ScrollViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageContainerView
	}
	
}
