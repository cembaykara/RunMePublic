//
//  testView.swift
//  uidesign
//
//  Created by Baris Cem Baykara on 2/20/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit
import PureLayout

class Card: UICollectionViewCell {

    let height = (UIScreen.main.bounds.height) / 7.5
    
    let header : UILabel = {
        let label = UILabel()
        label.textAlignment = NSTextAlignment.left
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.customGray.darkGray
        return label
    }()
    
    let distance : UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true;
        label.numberOfLines = 0;
        label.textColor = UIColor.customGray.lightGray
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.sizeToFit()
        return view
    }()
    
    let icon: UIImageView = {
       let view = UIImageView()
        view.contentMode = UIViewContentMode.scaleAspectFit
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autoSetDimension(.height, toSize: height)
        header.autoSetDimension(.height, toSize: height / 6)
        distance.autoSetDimension(.height, toSize: height / 6)
        
        drawView()
        
        self.addSubview(containerView)
        containerView.addSubview(header)
        containerView.addSubview(distance)
        containerView.addSubview(icon)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var didSetupConstraints = false
    
    // MARK: Constraints for subview
    override func updateConstraints() {
        
        if (!didSetupConstraints) {

            header.autoPinEdge(toSuperviewEdge: .top, withInset: 0.0)
            header.autoPinEdge(toSuperviewEdge: .left, withInset: 0.0)
            header.autoPinEdge(.right, to: .left, of: icon)
            header.autoMatch(.width, to: .width, of: icon, withMultiplier: 4)

            containerView.autoCenterInSuperview()
            containerView.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
            containerView.autoPinEdge(toSuperviewEdge: .right, withInset: 16.0)
            
            distance.autoPinEdge(.top, to: .bottom, of: header, withOffset: 5.0)
            distance.autoPinEdge(toSuperviewEdge: .left, withInset: 0.0)
            distance.autoPinEdge(toSuperviewEdge: .bottom, withInset: 0.0)
            distance.autoPinEdge(.right, to: .left, of: icon)
            distance.autoMatch(.width, to: .width, of: header)
            
            icon.autoMatch(.width, to: .width, of: header, withMultiplier: 0.25)
            icon.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .left)
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    // FIXME: Fix this function sometmie
    private func drawView() {
        self.backgroundColor = UIColor.customBackground.backgroundWhite
        layer.shadowOffset = CGSize(width: 0, height: -3)
        layer.shadowRadius = 5
        layer.cornerRadius = 6
        layer.shadowOpacity = 0.2
    }
    
    
    
}
