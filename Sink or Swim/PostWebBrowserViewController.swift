//
//  PostWebBrowserViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/7/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class PostWebBrowserViewController: UIViewController {
	
	@IBOutlet weak var webView: UIWebView!
	
	var request: URLRequest?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		if let req = request {
			DispatchQueue.main.async { webView.loadRequest(req) }
		}
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
