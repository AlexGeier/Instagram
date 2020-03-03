//
//  SignInViewController.swift
//  Instagram
//
//  Created by Alex Geier on 2/17/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit
import TinyConstraints
import Parse

class SignInViewController: UIViewController {
    private let logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "instagram_logo")
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        
        return label
    }()
    
    private let usernameField: UITextField = {
        let textField = TextField()
        textField.placeholder = "Username:"
        
        return textField
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        
        return label
    }()
    
    private let passwordField: UITextField = {
        let textField = TextField()
        textField.placeholder = "Password:"
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = Button(backgroundColor: .systemBlue)
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(onSignInPressed), for: .touchUpInside)
        
        return button
    }()
    
    private let signUpButton: UIButton = {
        let button = Button(backgroundColor: .systemBlue)
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(onSignUpPressed), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupLayout()
    }
    
    @objc private func onSignInPressed() {
        guard let username = usernameField.text else { return }
        guard let password = passwordField.text else { return }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            self.usernameField.text = ""
            self.passwordField.text = ""
            
            if let user = user {
                let viewController = UINavigationController(rootViewController: FeedViewController())
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            } else {
                // TODO: Alert that there was an error signing in
                print(error)
            }
        }
    }
    
    @objc private func onSignUpPressed() {
        let user = PFUser()
        user.username = usernameField.text
        user.password = passwordField.text
        
        user.signUpInBackground { (success, error) in
            self.usernameField.text = ""
            self.passwordField.text = ""
            
            if (success) {
                let viewController = UINavigationController(rootViewController: FeedViewController())
                viewController.modalPresentationStyle = .fullScreen
                self.present(viewController, animated: true, completion: nil)
            } else {
                // TODO: Alert that there was an error signing up
                print(error)
            }
        }
    }
    
    private func setupLayout() {
        let innerVerticalStackView = UIStackView(arrangedSubviews: [
            usernameLabel,
            usernameField,
            passwordLabel,
            passwordField
        ])
        innerVerticalStackView.axis = .vertical
        innerVerticalStackView.spacing = 8
        
        let innerHorizontalStackView = UIStackView(arrangedSubviews: [
            signInButton,
            signUpButton
        ])
        innerHorizontalStackView.distribution = .fillEqually
        innerHorizontalStackView.spacing = 32
        
        let mainVerticalStackView = UIStackView(arrangedSubviews: [
            logoView,
            innerVerticalStackView,
            innerHorizontalStackView,
            UIView()
        ])
        mainVerticalStackView.axis = .vertical
        mainVerticalStackView.spacing = 16
        mainVerticalStackView.setCustomSpacing(64, after: logoView)
        
        view.addSubview(mainVerticalStackView)
        mainVerticalStackView.edgesToSuperview(insets: .init(top: 32, left: 32, bottom: 32, right: 32), usingSafeArea: true)
    }
}
