//
//  WinnerView.swift
//  RunMe
//
//  Created by Baris Cem Baykara on 3/16/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit
import PureLayout

class WinnerScreen: UIView {

    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let image: UIImageView = {
        let view = UIImageView()
        view.sizeToFit()
        view.layer.cornerRadius = 200
        view.layer.masksToBounds = true
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        blurView.autoSetDimensions(to: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        image.autoSetDimensions(to: CGSize(width: 100, height: 100))
        
        self.backgroundColor = .clear
        self.insertSubview(blurView, at: 0)
        self.addSubview(image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var didSetupConstraints = false
    override func updateConstraints() {
        
        if (!didSetupConstraints) {
            
            blurView.autoPinEdgesToSuperviewEdges()
            image.autoCenterInSuperview()
            didSetupConstraints = true
        }
        
        super.updateConstraints()
    }
}
