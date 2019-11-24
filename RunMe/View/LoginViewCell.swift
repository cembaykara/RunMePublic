//
//  LoginView.swift
//  RunMe
//
//  Created by Baris Cem Baykara on /294/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit

protocol LoginButtonHandlerDelegate {
    func didPressLogin()
    var socialButtonType: LoginButton! {get set}
}

protocol ConfigurableCell {
    static var reuseId: String {get}
    var delegate: LoginButtonHandlerDelegate? {get set}
}

extension ConfigurableCell {
    var delegate: LoginButtonHandlerDelegate? {get {return nil} set{}}
    static var reuseId: String {
        return String(describing: self)
    }
}

class LoginViewCell: UICollectionViewCell, ConfigurableCell {
    
    var delegate: LoginButtonHandlerDelegate?
    
    let containerView : UIView = {
        let view = UIView()
        view.autoSetDimension(.height, toSize: 176)
        return view
    }()
    
    let header : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 36, weight: .semibold)
        label.text = "Login using"
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.autoSetDimension(.height, toSize: 41)
        return label
    }()
    
    let facebookButton = SocialButton(with: .facebook)
    let googleButton = SocialButton(with: .google)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createViews() {
        facebookButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(didPressButton), for: .touchUpInside)
        
        containerView.addSubview(facebookButton)
        containerView.addSubview(googleButton)
        
        self.addSubview(header)
        self.addSubview(containerView)
    }
    
    //MARK: SocialButton is handled in ViewController
    @objc func didPressButton(sender: SocialButton){
        delegate?.socialButtonType = sender.socialButtonType
        delegate?.didPressLogin()
    }
    
    // MARK: Constraints for subview
    var didSetupConstraints = false
    override func updateConstraints() {
        
        if (!didSetupConstraints) {
            
            header.autoPinEdge(toSuperviewEdge: .top, withInset: 60.0)
            header.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
            header.autoPinEdge(toSuperviewEdge: .right, withInset: 0.0)
            
            containerView.autoPinEdge(toSuperviewEdge: .left, withInset: 28)
            containerView.autoPinEdge(toSuperviewEdge: .right, withInset: 28)
            containerView.autoCenterInSuperview()
            
            facebookButton.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(28, 28, 0, 28), excludingEdge: .bottom)
            
            googleButton.autoPinEdgesToSuperviewEdges(with: UIEdgeInsetsMake(0, 28, 28, 28), excludingEdge: .top)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
