//
//  CameraViewController.swift
//  Instagram
//
//  Created by Alex Geier on 2/23/20.
//  Copyright © 2020 Alex Geier. All rights reserved.
//

import UIKit
import Parse
import SDWebImage

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private lazy var previewView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "image_placeholder")
        
        imageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(onPreviewPressed))
        tap.numberOfTouchesRequired = 1
        imageView.addGestureRecognizer(tap)
        
        return imageView
    }()
    
    @objc private func onPreviewPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        UIGraphicsBeginImageContext(.init(width: 300, height: 300))
        image.draw(in: .init(x: 0, y: 0, width: 300, height: 300))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        previewView.image = newImage
        
        dismiss(animated: true, completion: nil)
    }
    
    private let captionTextField: UITextField = {
        let textField = TextField()
        textField.placeholder = "Caption:"
        
        return textField
    }()
    
    private let submitButton: UIButton = {
        let button = Button(backgroundColor: .systemBlue)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(onSubmitPressed), for: .touchUpInside)
        
        return button
    }()
    
    @objc private func onSubmitPressed() {
        let post = PFObject(className: "Posts")
        
        post["caption"] = captionTextField.text!
        post["author"] = PFUser.current()!
        
        let imageData = previewView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        post["photo"] = file
        
        post.saveInBackground { (success, error) in
            if (success) {
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error)
            }
        }
        
    }
    
    override func viewDidLoad() {
        setupLayout()
        
        view.backgroundColor = .systemBackground
    }
    
    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            previewView,
            captionTextField,
            submitButton,
            UIView()
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        previewView.aspectRatio(1)
        
        view.addSubview(stackView)
        stackView.edgesToSuperview(insets: .init(top: 16, left: 16, bottom: 16, right: 16), usingSafeArea: true)
    }
}
