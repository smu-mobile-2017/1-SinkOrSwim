//
//  ScrollViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {

	// [CITE] https://www.raywenderlich.com/159481/uiscrollview-tutorial-getting-started
	
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var imageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	fileprivate func updateMinZoomScale(forSize size: CGSize) {
		let widthScale = size.width / imageView.bounds.width
		let heightScale = size.height / imageView.bounds.height
		let minScale = min(widthScale, heightScale)
		
		scrollView.minimumZoomScale = minScale
		scrollView.zoomScale = minScale
	}
	

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ScrollViewController: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}
	
}
