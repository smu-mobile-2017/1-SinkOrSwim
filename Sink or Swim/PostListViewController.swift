//
//  PostListViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/5/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit
import PromiseKit

// The listings supported by the app are Hot and New.
// Hot sorts the frontpage by a proprietary popularity algorithm
// (on reddit's servers) and New, which is just the latest posts.
enum ListingType {
	case hot, new
}

// The VC responsible for the Home tab, which lists the Front Page of reddit.
class PostListViewController: UITableViewController {
	
	// state for which row was last selected.
	var selectedRow: Int? = nil
	
	// all posts provided by the API.
	var posts: [RedditLink] = []
	
	// the Ad cell. Storing it here prevents accidental
	// reloading when it is scrolled off screen.
	var advertisement: AdvertisementCell? = nil
	
	// the API to load posts displayed here.
	lazy var api: RedditAPI = RedditAPI()
	
	// This function gets posts from the API class,
	// stores them in the posts property, and triggers
	// a reload of the table.
	func loadPosts(_ type: ListingType) {
		firstly { () -> Promise<[RedditLink]> in
			switch type {
			case .hot:
				return try RedditAPI.hotPosts(inSubreddit: nil, limit: 15)
			case .new:
				return try RedditAPI.newPosts(inSubreddit: nil, limit: 15)
			}
		}.then { result -> Void in
			self.posts = result
			self.tableView.reloadData()
		}.catch { error in
			self.handleLoadPostsError(error)
		}
	}
	
	// A stub for hopefully better, more user-relevant error handling
	// in the future.
	func handleLoadPostsError(_ error: Error) {
		switch error {
		case let apiError as RedditAPIError:
			print("[handleLoadPostsError] RedditAPIError: \(apiError)")
		default:
			print("[handleLoadPostsError] Unknown error: \(error)")
		}
	}
	
	// Ensure the table automatically calculates cell height (post titles
	// cause cells to be different heights), then load the posts.
    override func viewDidLoad() {
        super.viewDidLoad()
		DispatchQueue.main.async {
			self.tableView.rowHeight = UITableViewAutomaticDimension
			self.tableView.estimatedRowHeight = 140
		}
		
		// We load hot posts by default.
		loadPosts(.hot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	// when the Hot/New binary segment is changed at the top of the screen,
	// this action triggers a reload of posts, either in Hot or New ordering.
	// Hot and New are seperate API endpoints.
	@IBAction func didChangeSegmentedControlValue(_ sender: UISegmentedControl) {
		let title = sender.titleForSegment(at: sender.selectedSegmentIndex)
		if title == "Hot" {
			loadPosts(.hot)
		} else if title == "New" {
			loadPosts(.new)
		} else {
			print("Unknown Segmented Control Selection")
		}
	}

    // MARK: - Table view data source
	
	// Two sections: one contains just the advertisement cell (single),
	// and the next is all of the reddit posts.
    override func numberOfSections(in tableView: UITableView) -> Int {
		// 0 - advertisement
		// 1 - posts
        return 2
    }
	
	// Just one advert, variable # of posts.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 1
		} else {
			return posts.count
		}
    }
	
	// Either generate an ad, a LinkCell (for a link post), or a SelfCell (for a self post).
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		// The 0th section is for the ad, so load an ad.
		if indexPath.section == 0 {
			return generateAdvertisement(for: indexPath)
		}
		
		let row = indexPath.row
		let post = self.posts[row]
		
		// create either self or link cell
		let cell: UITableViewCell = {
			
			// Self Posts
			if post.isSelf {
				return tableView.dequeueReusableCell(withIdentifier: "selfCell", for: indexPath)
			}
			
			// Link Posts
			let c = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath)
			
			// Link cell additionally has an imageView. handle this.
			let lc = c as! LinkCell
			lc.cellImageView.image = nil
			// Load the thumbnail or put a placeholder for link posts.
			if let url = post.thumbnailURL {
				loadThumbnail(forCell: c, withURL: url)
			} else {
				lc.cellImageView.backgroundColor = .clear
				lc.cellImageView.image = #imageLiteral(resourceName: "link-default-thumbnail")
			}
			
			return lc
		}()
		
		// treat self and link cells the same, and set the labels they have
		// in common.
		let genericCell = cell as! GenericListingCell
		genericCell.titleLabel.text = post.title
		genericCell.upperDetailLabel.text = "r/\(post.subreddit) · \(post.author)"
		genericCell.lowerDetailLabel.text = "⬆️ \(post.score) ⬇️"
		
        return cell
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard indexPath.section == 1 else { return }
		
		self.selectedRow = indexPath.row
		let post = posts[selectedRow!]
		var segue = ""
		
		// Load a textView page if it's a self post,
		// a web browser page if it's a link post.
		if post.isSelf {
			segue = "redditLinkToSelfPost"
		} else {
			segue = "redditLinkToBrowser"
		}
		
		self.performSegue(withIdentifier: segue, sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		let post = posts[selectedRow!]
		segue.destination.title = post.title
		
		// Link Post (Web Browser): provide the URL to display.
		if let webBrowser = segue.destination as? PostWebBrowserViewController {
			let req = URLRequest(url: post.url)
			webBrowser.request = req
		}
		// Self Post (Text View): provide the text to display.
		else if let selfPostView = segue.destination as? PostSelfViewController {
			selfPostView.postTitle = post.title
			selfPostView.postBody = post.selfText
		}
	}
	
	// Contacts the mock ad server and sets the content of the ad cell
	// asynchronously when the ad server "responds"
	func generateAdvertisement(for indexPath: IndexPath) -> UITableViewCell {
		// If we've already loaded an ad, don't throw it out when it scrolls
		// offscreen.
		if let ad = self.advertisement {
			return ad
		}
		let cell = tableView.dequeueReusableCell(withIdentifier: "advertisementCell", for: indexPath)
		let ad = cell as! AdvertisementCell
		ad.updateLoadedState(message: nil) // hide text, show spinner in ad
		
		// Chain the promise that provides the Ad text.
		RedditAPI.getAdvertisementMessage().then { msg -> Void in
			ad.updateLoadedState(message: msg) // hide spinner, show text in ad
		}.then{
			// reload the ad cell to readjust the cell height for dynamically
			// sized text.
			self.tableView.reloadRows(at: [indexPath], with: .none)
		}.catch { error in
			print("[generateAdvertisement] Error: \(error)")
		}
		// store the ad cell to prevent it being needlessly regenerated.
		self.advertisement = ad
		return cell
	}
	
	func loadThumbnail(forCell cell: UITableViewCell, withURL url: URL) {
		// Don't load images with URL "image", just load the placeholder.
		// This is a reddit API quirk.
		if url.absoluteString == "image" {
			DispatchQueue.main.async {
				let lc = cell as! LinkCell
				lc.cellImageView.backgroundColor = .clear
				lc.cellImageView.image = #imageLiteral(resourceName: "image-default-thumbnail")
			}
			return
		}
		
		// Otherwise load the real thumb asynchronously.
		RedditAPI.loadImage(url).then(on: .main) { image -> Void in
			let lc = cell as! LinkCell
			lc.cellImageView.image = image
		}.catch { error in
			print(error)
			print("Offending URL: \(url.absoluteString)")
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
