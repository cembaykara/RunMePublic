//
//  SocialButton.swift
//  RunMe
//
//  Created by Baris Cem Baykara on /294/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit

enum LoginButton {
    case facebook
    case google
}

class SocialButton: UIButton{
    
    var socialButtonType: LoginButton!
    let buttonHeight: CGFloat = 30.0
    let iconSize = CGSize(width: 17.0, height: 17.0)
    
    func buttonSelector(with: LoginButton){
        switch with {
        case .facebook:
            createButton(with: .facebook)
        case .google:
            createButton(with: .google)
        }
    }
    
    init(with network: LoginButton){
        super.init(frame: CGRect.zero)
        buttonSelector(with: network)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createButton(with network: LoginButton){

        let icon = UIImageView()
        icon.autoSetDimensions(to: iconSize)

        self.addSubview(icon)
        icon.autoPinEdge(toSuperviewEdge: .left, withInset: 16)
        icon.autoPinEdge(toSuperviewEdge: .top, withInset: 7)
        
        let attributes: [NSAttributedStringKey: Any] = [
            .font : UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor : UIColor.white,
            ]
        
        let attributesThin: [NSAttributedStringKey: Any] = [
            .font : UIFont.systemFont(ofSize: 18, weight: .light),
            .foregroundColor : UIColor.white,
            ]
       
        let attributesGoogle: [NSAttributedStringKey: Any] = [
            .font : UIFont.systemFont(ofSize: 18, weight: .semibold),
            .foregroundColor : UIColor.darkGray,
            ]
        
        var title = NSMutableAttributedString()
        
        if (network == .facebook) {
            icon.image = #imageLiteral(resourceName: "facebook-icon")
            let facebookString = NSMutableAttributedString(string: "Login with Facebook", attributes: attributes)
            facebookString.addAttributes(attributesThin, range: NSRange(location: 6, length: 4))
            title = facebookString
            self.backgroundColor = UIColor.socialColor.facebook
        }else if (network == .google) {
            icon.image = #imageLiteral(resourceName: "google-icon")
            let googleString = NSMutableAttributedString(string: "Sign In", attributes: attributesGoogle)
            title = googleString
            self.backgroundColor = UIColor.white
        }
        
        self.socialButtonType = network
        self.setAttributedTitle(title, for: .normal)
        self.layer.cornerRadius = 15
        
        self.autoSetDimension(.height, toSize: buttonHeight)
        
        createShadow()
    }
    
    func  createShadow() {
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.5
    }
}
