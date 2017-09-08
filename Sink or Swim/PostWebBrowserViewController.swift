//
//  PostWebBrowserViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

// A simple VC for a UIWebView. In the real world,
// this would be supplanted with an SKSafariView, but
// that would not fulfill the requirement that we pass
// data to detail views via segues, as SKSafariViews are
// created and passed a URL in one step.
class PostWebBrowserViewController: UIViewController {
	
	@IBOutlet weak var webView: UIWebView!
	
	var request: URLRequest?
	
	// When we tried loading the page in the segue, the program crashed,
	// because the view (and the webView therein) had not been loaded.
	// Instead, now, we set the request property during the segue, and
	// the VC passes it to the webView when everything's ready.
    override func viewDidLoad() {
        super.viewDidLoad()
		if let req = request {
			DispatchQueue.main.async { self.webView.loadRequest(req) }
		}
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
