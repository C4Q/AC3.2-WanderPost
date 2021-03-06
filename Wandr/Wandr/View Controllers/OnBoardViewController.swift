//
//  OnBoardViewController.swift
//  Wandr
//
//  Created by Ana Ma on 3/2/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import AVKit

class OnBoardViewController: UIViewController {
    
    fileprivate var imagePickerController: UIImagePickerController!
    fileprivate var profileImageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "wanderpost"
        self.view.backgroundColor = StyleManager.shared.primaryLight
        
        // Do any additional setup after loading the view.
        self.profileImageView.accessibilityIdentifier = "profileImageView"
        self.userNameTextField.accessibilityIdentifier = "userNameTextField"
        self.registerButton.accessibilityIdentifier = "registerButton"
        self.logoImageView.accessibilityIdentifier = "logoImageView"
        self.introLabel.accessibilityIdentifier = "introLabel"
        self.registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
        setupViewHierarchy()
        configureConstraints()
    }
    
    // MARK: - Actions
    func imageViewTapped() {
        //Able to add profile picture
        self.showImagePickerForSourceType(sourceType: .photoLibrary)
    }
    
    func registerButtonPressed() {
        self.registerButton.isEnabled = false
        if let userName = self.userNameTextField.text,
            let imageURL = profileImageURL {
            CloudManager.shared.createUsername(userName: userName, profileImageFilePathURL: imageURL) { (error) in
                //ADD ERROR HANDLING
                dump(error)
                if error != nil {
                    // set up app tabbar and such
                } else {
                    DispatchQueue.main.async {
                        self.present(LoadingViewController(), animated: false, completion: nil)
                    }
                }
                
            }
        } else {
            //Present ALERT
        }
    }
    
    // MARK: - PhotoPicker Methods
    private func showImagePickerForSourceType(sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.modalPresentationStyle = .currentContext
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        imagePickerController.modalPresentationStyle = (sourceType == .camera) ? .fullScreen : .popover
        self.imagePickerController = imagePickerController
        self.present(imagePickerController, animated: true, completion: nil)
    }

    // MARK: - Layout
    private func setupViewHierarchy() {
        self.view.addSubview(profileImageView)
        self.view.addSubview(userNameTextField)
        self.view.addSubview(registerButton)
        self.view.addSubview(logoImageView)
        self.view.addSubview(introLabel)
        self.view.addSubview(usernameDirectionLabel)
    }
    
    private func configureConstraints() {
        profileImageView.snp.makeConstraints { (view) in
            view.top.equalTo(self.topLayoutGuide.snp.bottom).offset(16)
            view.centerX.equalToSuperview()
            view.height.equalTo(150)
            view.width.equalTo(150)
        }
        
        userNameTextField.snp.makeConstraints { (textField) in
            textField.top.equalTo(self.profileImageView.snp.bottom).offset(8)
            textField.height.equalTo(30)
            textField.leading.equalToSuperview().offset(16)
            textField.trailing.equalToSuperview().inset(16)
        }
        
        usernameDirectionLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.userNameTextField.snp.bottom).offset(8)
            label.leading.equalToSuperview().offset(16)
            label.trailing.equalToSuperview().inset(16)
        }
        
        registerButton.snp.makeConstraints { (button) in
            button.top.equalTo(self.usernameDirectionLabel.snp.bottom).offset(8)
            button.centerX.equalToSuperview()
        }
        
        logoImageView.snp.makeConstraints { (view) in
            view.top.equalTo(self.registerButton.snp.bottom).offset(8)
            view.centerX.equalToSuperview()
            view.height.equalTo(200)
            view.width.equalTo(200)
        }
        
        introLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.logoImageView.snp.bottom).offset(8)
            label.leading.equalToSuperview().offset(16)
            label.trailing.equalToSuperview().inset(16)
        }
    }
    
    func setUpAppNavigation() {
        let profileViewController = UINavigationController(rootViewController: ProfileViewController())
        let mapViewController = UINavigationController(rootViewController: MapViewController())
        let arViewController = ARViewController()
        
        let profileIcon = UITabBarItem(title: "profile", image: nil, selectedImage: nil)
        let mapIcon = UITabBarItem(title: "map", image: nil, selectedImage: nil)
        let arIcon = UITabBarItem(title: "AR", image: nil, selectedImage: nil)
        
//        //1
//        arViewController.dataSource = mapViewController.viewControllers.first! as! MapViewController
//        //2
//        arViewController.maxVisibleAnnotations = 30
//        arViewController.headingSmoothingFactor = 0.05
//        //3
//        arViewController.setAnnotations([])
        
        
        profileViewController.tabBarItem = profileIcon
        mapViewController.tabBarItem = mapIcon
        //onBoardViewController.tabBarItem = onBoardIcon
        arViewController.tabBarItem = arIcon
        
        let tabController = UITabBarController()
        tabController.viewControllers = [profileViewController, mapViewController, arViewController]
        tabController.tabBar.tintColor = StyleManager.shared.accent
        tabController.selectedIndex = 1
    }
    
    //MARK: - Views
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "default-placeholder")
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = StyleManager.shared.accent.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.frame.size = CGSize(width: 150.0, height: 150.0)
        let tapImageGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.addGestureRecognizer(tapImageGesture)
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height / 2
        return imageView
    }()
    
    lazy var userNameTextField: WanderTextField = {
        let textField = WanderTextField()
        textField.border(placeHolder: "username")
        textField.delegate = self
        return textField
    }()
    
    lazy var registerButton: WanderButton = {
        let button = WanderButton(title: "register")
        return button
    }()
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "logo_primary")
        imageView.frame.size = CGSize(width: 200.0, height: 200.0)
        imageView.isUserInteractionEnabled = false
        return imageView
    }()
    
    lazy var introLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Wanderpost uses your Apple iCloud \n account to store your posts. \n Please add a username and profile picture."
        label.textColor = StyleManager.shared.primary
        label.textAlignment = .center
        return label
    }()
    
    lazy var usernameDirectionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Usernames will be all lowercased without spaces"
        label.font = StyleManager.shared.comfortaaFont12
        label.textColor = StyleManager.shared.primary
        return label
    }()
}

// MARK: - UIImagePickerControllerDelegate Method
extension OnBoardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let imageURL = info[UIImagePickerControllerReferenceURL] as? URL {
            self.profileImageView.image = image
            
            //As weird as it sounds, you need an filePath URL to make a CKAsset, not an asset URL, this is making a temp filePathURL and then storing it in the temp file which gets automatically cleaned when needed.
            do {
                let data = UIImagePNGRepresentation(image.fixRotatedImage())!
                let fileType = ".\(imageURL.pathExtension)"
                let fileName = ProcessInfo.processInfo.globallyUniqueString + fileType
                let imageURL = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
                try data.write(to: imageURL, options: .atomicWrite)
                self.profileImageURL = imageURL
                
            } catch {
                print(error.localizedDescription)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITextFieldDelegate Method
extension OnBoardViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let validText = textField.text {
            textField.text = (validText as NSString).replacingCharacters(in: range, with: string.lowercased())
            if string == " " {
                textField.text = (validText as NSString).replacingCharacters(in: range, with: "")
            }
            return false
        }
        return true
    }
}
