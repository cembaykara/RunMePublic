//
//  NewHomeScreen.swift
//  RunMe
//
//  Created by Baris Cem Baykara on /15/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit
import Firebase

class HomeScreenViewController: UIViewController {

    let gradientBackground = CAGradientLayer()
    
    //Meh!
    var gradientColorSets = [[CGColor]]()
    
    private func createLayer() {
        gradientBackground.frame = view.layer.bounds
        gradientColorSets.append([UIColor.gradientColor.skyBlue.cgColor, UIColor.gradientColor.blueLagoon.cgColor])
        gradientBackground.colors = gradientColorSets[0]
        self.view.layer.addSublayer(gradientBackground)
    }
    
    let profileView: UIView = {
        let pView = UIView()
        pView.autoSetDimension(.height, toSize: 330.0)
        pView.backgroundColor = .white
        return pView
    }()
    
    let profilePictureContainer: UIView = {
        let container = UIView()
        container.autoSetDimensions(to: CGSize(width: 120.0, height: 120.0))
        container.layer.cornerRadius = 60
        return container
    }()
    
    let coverPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.autoSetDimension(.height, toSize: 190.0)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let profilePicture: UIImageView = {
        let imageView = UIImageView()
        imageView.autoSetDimensions(to: CGSize(width: 120.0, height: 120.0))
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameText: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    let runButton: UIButton = {
        let button = UIButton()
        button.setTitle("Let's Run", for: .normal)
        button.autoSetDimensions(to: CGSize(width: 120.0, height: 120.0))
        return button
    }()
    
    @objc func friendsListButton(sender: UIButton){
        self.present(FriendsList(), animated: true, completion: nil)
        print("Pressed")
    }
    
    func createView(){
        createShadow(object: profileView)
        createShadow(object: profilePictureContainer)
        createShadow(object: coverPhoto)
        self.view.addSubview(profileView)
        //TODO: Fetch from server
        let name = "Merlin"
        nameText.text = name
        profilePicture.image = #imageLiteral(resourceName: "Merlin")
        coverPhoto.image = #imageLiteral(resourceName: "coverPhoto")
        
        runButton.addTarget(self, action: #selector(friendsListButton), for: .touchUpInside)
        
        profilePictureContainer.addSubview(profilePicture)
        profileView.addSubview(coverPhoto)
        profileView.addSubview(profilePictureContainer)
        profileView.addSubview(nameText)
        self.view.addSubview(runButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLayer()
        createView()
    }
    
    //TODO: Connect GameView back to the new HomeScreen Here
    
    
    //TODO: Fetch and display previous games here
    
    
    // MARK: Constraints for subview
    var didSetupConstraints = false
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            profileView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
            
            coverPhoto.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .bottom)
            
            profilePictureContainer.autoPinEdge(toSuperviewEdge: .top, withInset:130)
            profilePictureContainer.autoPinEdge(toSuperviewEdge: .right, withInset: 127.5)
            profilePictureContainer.autoPinEdge(toSuperviewEdge: .left, withInset: 127.5)
            
            profilePicture.autoPinEdgesToSuperviewEdges()
            
            nameText.autoPinEdge(.top, to: .bottom, of: profilePicture, withOffset: 18)
            nameText.autoPinEdge(toSuperviewEdge: .left, withInset: 0)
            nameText.autoPinEdge(toSuperviewEdge: .right, withInset: 0)
            
            runButton.autoPinEdge(.top, to: .bottom, of: nameText, withOffset: 64)
            runButton.autoPinEdge(toSuperviewEdge: .left, withInset: 32)
            runButton.autoPinEdge(toSuperviewEdge: .right, withInset: 32)
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
  private func  createShadow(object: UIView) {
        object.layer.shadowOffset = CGSize(width: 0, height: 3)
        object.layer.shadowRadius = 5
        object.layer.shadowOpacity = 0.5
    }

    
}
