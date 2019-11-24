//
//  LocationView.swift
//  RunMe
//
//  Created by Baris Cem Baykara on /274/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit
import CoreLocation

class LocationViewCell: UICollectionViewCell, ConfigurableCell {
    
    var locationManager = CLLocationManager()
    
    let containerView : UIView = {
        let view = UIView()
       return view
    }()
    
    let header : UILabel = {
        let label = UILabel()
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 36, weight: .semibold)]
        let title = NSAttributedString(string: "We need your\nlocation", attributes: attributes)
        label.attributedText = title
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.numberOfLines = 2
        label.autoSetDimension(.height, toSize: 86)
        return label
    }()
    
    let body: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "So we can show you where you are."
        label.textColor = UIColor.white
        label.autoSetDimension(.height, toSize: 26)
        return label
    }()
    
    let image : UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "location-icon")
        image.autoSetDimension(.height, toSize: 166)
        return image
    }()
    
    let locationButton : UIButton = {
       let button = UIButton()
        let attributes = [NSAttributedStringKey.underlineStyle : 1, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16), NSAttributedStringKey.foregroundColor: UIColor.white] as [NSAttributedStringKey : Any]
        let title = NSAttributedString(string: "Turn on location", attributes: attributes)
        button.setAttributedTitle(title, for: .normal)
        button.autoSetDimension(.height, toSize: 24)
        return button
    }()
    
    @objc func locationButtonAction(sender: Any!) {
            locationManager.requestWhenInUseAuthorization()
        print("Button tapped")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        locationButton.addTarget(self, action: #selector(locationButtonAction), for: .touchUpInside)
        
        containerView.addSubview(image)
        self.addSubview(header)
        self.addSubview(body)
        self.addSubview(locationButton)
        self.addSubview(containerView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Constraints for subview
    var didSetupConstraints = false
    override func updateConstraints() {
        
        if (!didSetupConstraints) {
            
            header.autoPinEdge(toSuperviewEdge: .top, withInset: 60.0)
            header.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
            header.autoPinEdge(toSuperviewEdge: .right, withInset: 0.0)

            body.autoPinEdge(.top, to: .bottom, of: header, withOffset: 4.0)
            body.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
            
            locationButton.autoPinEdge(.top, to: .bottom, of: body, withOffset: 24.0)
            locationButton.autoPinEdge(toSuperviewEdge: .left, withInset: 16.0)
            
            containerView.autoPinEdge(.top, to: .bottom, of: locationButton)
            containerView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets.zero, excludingEdge: .top)
            
            image.autoCenterInSuperview()
            
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
