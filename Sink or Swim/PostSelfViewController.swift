//
//  PostSelfViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/8/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

class PostSelfViewController: UIViewController {

	@IBOutlet weak var selfTextView: UITextView!
	var postTitle: String = ""
	var postBody: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		generatePostContent()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// [CITE] https://stackoverflow.com/a/3586943/3592716
	// information re: attributed strings
	func generatePostContent() {
		let text = "\(postTitle)\n\n\(postBody)"
		let fontSize = UIFont.systemFontSize
		let boldStyleAttributes: [String: Any] = [
			NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize),
			NSForegroundColorAttributeName: UIColor.black
		]
		let normalStyleAttributes: [String: Any] = [
			NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)
		]
		let attributeString = NSMutableAttributedString(string: text, attributes: normalStyleAttributes)
		let end: Int = postTitle.characters.count
		let boldRange = NSRange(Range(0...end))
		attributeString.setAttributes(boldStyleAttributes, range: boldRange)
		
		DispatchQueue.main.async {
			self.selfTextView.attributedText = attributeString
			self.selfTextView.scrollRectToVisible(.zero, animated: false)
		}
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
