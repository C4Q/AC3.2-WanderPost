//
//  ProfileView.swift
//  Wandr
//
//  Created by Ana Ma on 3/1/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import TwicketSegmentedControl

protocol ProfileViewDelegate {
    func imageViewTapped()
}

class ProfileView: UIView {
    override func draw(_ rect: CGRect) {
        // Drawing code
        setupViewHierarchy()
        configureConstraints()
        CloudManager.shared.getUserProfilePic { (data, error) in
            if error != nil {
                //add error handling
                print(error?.localizedDescription)
            }
            if let validData = data {
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: validData)
                }
            }
        }
    }
    
    var delegate : ProfileViewDelegate?
    
    private func setupViewHierarchy() {
        self.addSubview(profileImageView)
        self.addSubview(userNameLabel)
        self.addSubview(postNumberLabel)
        self.addSubview(followersNumberLabel)
        self.addSubview(followingNumberLabel)
    }
    
    private func configureConstraints() {
        // Subviews of profileContainerView
        profileImageView.snp.makeConstraints { (view) in
            view.top.equalToSuperview().offset(16)
            view.centerX.equalToSuperview()
            view.height.equalTo(150)
            view.width.equalTo(150)
        }
        
        userNameLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.profileImageView.snp.bottom).offset(8)
            label.centerX.equalToSuperview()
            label.height.equalTo(30)
        }
        
        followersNumberLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.userNameLabel.snp.bottom).offset(8)
            label.centerX.equalToSuperview()
            label.height.equalTo(30)
        }
        
        postNumberLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.userNameLabel.snp.bottom).offset(8)
            label.trailing.equalTo(self.followersNumberLabel.snp.leading).offset(-16.0)
            label.height.equalTo(30)
        }
        
        
        followingNumberLabel.snp.makeConstraints { (label) in
            label.top.equalTo(self.userNameLabel.snp.bottom).offset(8)
            label.leading.equalTo(self.followersNumberLabel.snp.trailing).offset(16.0)
            label.height.equalTo(30)
        }
    }
    
    // Mark:- Action 
    func imageViewTapped() {
        self.delegate?.imageViewTapped()
        //print("ImageViewTapped")
    }
    
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
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = StyleManager.shared.comfortaaFont18
        return label
    }()
    
    lazy var postNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "#Posts"
        label.font = StyleManager.shared.comfortaaFont14
        return label
    }()
    
    lazy var followersNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "#Followers"
        label.font = StyleManager.shared.comfortaaFont14
        return label
    }()
    
    lazy var followingNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "#Following"
        label.font = StyleManager.shared.comfortaaFont14
        return label
    }()
}

class SegmentedControlHeaderFooterView: UITableViewHeaderFooterView {
    static let identifier = "segmentedControlHeaderFooterViewIdentifier"
    
    let segmentTitles = PrivacyLevelManager.shared.privacyLevelStringArray
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        setupViewHierarchy()
        configureConstraints()
        //let frame = CGRect(x: 5, y: 5, width: self.frame.width - 10, height: 40)
        //self.segmentedControl = TwicketSegmentedControl(frame: frame)
        self.segmentedControl.backgroundColor = UIColor.clear
        self.segmentedControl.setSegmentItems(segmentTitles)
    }
    
    private func setupViewHierarchy() {
        self.addSubview(segmentedControl)
    }
    
    private func configureConstraints() {
        segmentedControl.snp.makeConstraints { (control) in
            control.top.equalToSuperview()
            control.leading.equalToSuperview().offset(16)
            control.trailing.equalToSuperview().inset(16)
            control.bottom.equalToSuperview()
            control.height.equalTo(40.0)
        }
    }
    
    lazy var segmentedControl: TwicketSegmentedControl = {
        let control = TwicketSegmentedControl()
        return control
    }()

}
