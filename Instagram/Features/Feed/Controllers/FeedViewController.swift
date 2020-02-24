//
//  FeedViewController.swift
//  Instagram
//
//  Created by Alex Geier on 2/23/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UITableViewController {
    private let cellId = "cellId"
    
    var posts = [PFObject]()
    
    private lazy var takePhotoButton: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: "+", style: .plain, target: self, action: #selector(onTakePhotoPressed))
        return button
    }()
    
    @objc private func onTakePhotoPressed() {
        let viewController = CameraViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        navigationItem.title = "Instagram"
        navigationItem.rightBarButtonItem = takePhotoButton

        tableView.register(PostCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            } else {
                print(error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PostCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.author = user.username
        cell.caption = post["caption"] as! String
        
        let imageFile = post["photo"] as! PFFileObject
        let urlString = imageFile.url!
        cell.imageURL = URL(string: urlString)
        
        return cell
    }
}
