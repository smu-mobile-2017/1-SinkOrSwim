//
//  PostSelfViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/8/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit

// The simple VC containing a textView into which
// self post (reddit jargon for text post) content
// is loaded.
class PostSelfViewController: UIViewController {

	@IBOutlet weak var selfTextView: UITextView!
	lazy var postTitle: String = ""
	lazy var postBody: String = ""
	
    override func viewDidLoad() {
        super.viewDidLoad()
		generatePostContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// Given the properties for title and body (set during segue by the
	// table view controller), generate an attributed string where
	// the title is bold and the body text isn't, and feed it into the
	// UITextView. Yes, it really does take this much code to bold a line
	// of text.
	//
	// [CITE] https://stackoverflow.com/a/3586943/3592716
	// information re: attributed strings
	func generatePostContent() {
		let text = "\(postTitle)\n\n\(postBody)"
		let fontSize = UIFont.systemFontSize
		
		// the two styles used: regular and bold.
		let boldStyleAttributes: [String: Any] = [
			NSFontAttributeName: UIFont.boldSystemFont(ofSize: fontSize),
			NSForegroundColorAttributeName: UIColor.black
		]
		let normalStyleAttributes: [String: Any] = [
			NSFontAttributeName: UIFont.systemFont(ofSize: fontSize)
		]
		
		// the attributed string which will be partially bolded.
		let attributeString = NSMutableAttributedString(string: text, attributes: normalStyleAttributes)
		
		// Bold the character range occupied by the title.
		let end: Int = postTitle.characters.count
		let boldRange = NSRange(Range(0...end))
		attributeString.setAttributes(boldStyleAttributes, range: boldRange)
		
		// Set the attributedText (not `text`) and scroll to the top
		// (when UITextView content changes, sometimes it scrolls to the middle)
		DispatchQueue.main.async {
			self.selfTextView.attributedText = attributeString
			self.selfTextView.scrollRectToVisible(.zero, animated: false)
		}
	}

}
