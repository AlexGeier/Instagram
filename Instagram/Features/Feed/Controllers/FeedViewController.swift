//
//  FeedViewController.swift
//  Instagram
//
//  Created by Alex Geier on 2/23/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit
import Parse
import MessageInputBar

class FeedViewController: UITableViewController, MessageInputBarDelegate {
    private let postCellId = "postCellId"
    private let commentCellId = "commentCellId"
    private let addCommentCellId = "addCommentCellId"
    
    let commentBar = MessageInputBar()
    
    var posts = [PFObject]()
    
    var selectedPost: PFObject!
    
    private lazy var takePhotoButton: UIBarButtonItem = {
        let button = UIBarButtonItem.init(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(onTakePhotoPressed))
        
        return button
    }()
    
    @objc private func onTakePhotoPressed() {
        let viewController = CameraViewController()
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }
    
    private lazy var signOutButton: UIBarButtonItem = {
        let button = UIBarButtonItem.init(title: "Sign Out", style: .plain, target: self, action: #selector(onSignOutPressed))
        
        return button
    }()
    
    @objc private func onSignOutPressed() {
        PFUser.logOutInBackground { error in
            if error != nil {
                // TODO: Alert user that there was an error logging out
                print(error)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    var showsCommentBar = false
    
    override func viewDidLoad() {
        navigationItem.title = "Instagram"
        navigationItem.rightBarButtonItem = takePhotoButton
        navigationItem.leftBarButtonItem = signOutButton
        
        tableView.register(PostCell.self, forCellReuseIdentifier: postCellId)
        tableView.register(CommentCell.self, forCellReuseIdentifier: commentCellId)
        tableView.register(AddCommentCell.self, forCellReuseIdentifier: addCommentCellId)
        
        tableView.keyboardDismissMode = .interactive
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let query = PFQuery(className: "Posts")
        query.includeKeys(["author", "comments", "comments.author"])
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
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        let comment = PFObject(className: "Comments")
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!
        
        selectedPost.add(comment, forKey: "comments")
        
        selectedPost.saveInBackground { (success, error) in
            if success {
                print("Created new comment")
            } else {
                print(error)
            }
        }
        
        tableView.reloadData()
        
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let post = posts[section]
        let comments = post["comments"] as? [PFObject] ?? []
        
        return comments.count + 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.section]
        let comments = post["comments"] as? [PFObject] ?? []
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: postCellId) as! PostCell
            let user = post["author"] as! PFUser
            cell.author = user.username
            cell.caption = post["caption"] as! String
            
            let imageFile = post["photo"] as! PFFileObject
            let urlString = imageFile.url!
            cell.imageURL = URL(string: urlString)
            
            return cell
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: commentCellId) as! CommentCell
            let comment = comments[indexPath.row - 1]
            let user = comment["author"] as! PFUser
            cell.username = user.username
            cell.comment = comment["text"] as? String
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: addCommentCellId) as! AddCommentCell
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.section]
        let comments = post["comments"] as? [PFObject] ?? []
        
        if indexPath.row == comments.count + 1 {
            showsCommentBar = true
            becomeFirstResponder()
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
        }
    }
}
