//
//  PostListViewController.swift
//  Sink or Swim
//
//  Created by Paul Herz on 9/5/17.
//  Copyright © 2017 Paul Herz. All rights reserved.
//

import UIKit
import PromiseKit

enum ListingType {
	case hot, new
}

class PostListViewController: UITableViewController {
	
	var posts: [RedditLink] = []
	
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
	
	func handleLoadPostsError(_ error: Error) {
		switch error {
		case let apiError as RedditAPIError:
			print("[handleLoadPostsError] RedditAPIError: \(apiError)")
		default:
			print("[handleLoadPostsError] Unknown error: \(error)")
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		tableView.rowHeight = UITableViewAutomaticDimension
		tableView.estimatedRowHeight = 140
		loadPosts(.hot)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "linkCell", for: indexPath)
		let lc = cell as! LinkCell
		let row = indexPath.row
		let post = self.posts[row]
		
		lc.titleLabel.text = post.title
		lc.upperDetailLabel.text = "r/\(post.subreddit) · \(post.author)"
		lc.lowerDetailLabel.text = "⬆️ \(post.score) ⬇️"
		
		// reset image due to reuse
		lc.cellImageView.image = nil
		
		if let url = post.thumbnailURL {
			loadThumbnail(forCell: cell, withURL: url)
		} else {
			lc.cellImageView.backgroundColor = .clear
			if post.isSelf {
				lc.cellImageView.image = #imageLiteral(resourceName: "self-default-thumbnail")
			} else {
				lc.cellImageView.image = #imageLiteral(resourceName: "link-default-thumbnail")
			}
		}
        return cell
    }
	
	func loadThumbnail(forCell cell: UITableViewCell, withURL url: URL) {
		let q = DispatchQueue.main
		print(url)
		RedditAPI.loadImage(url).then(on: q) { image -> Void in
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
