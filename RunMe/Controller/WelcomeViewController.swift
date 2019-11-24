//
//  WelcomeViewController.swift
//  RunMe
//
//  Created by Baris Cem Baykara on /274/18.
//  Copyright © 2018 Baris Cem Baykara. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UIPageViewControllerDelegate, LoginButtonHandlerDelegate {

    let gradientBackground = CAGradientLayer()
    
    //Meh!
    var gradientColorSets = [[CGColor]]()
    
    private func createLayer() {
        gradientBackground.frame = view.layer.bounds
        gradientColorSets.append([UIColor.gradientColor.sunnyDay.cgColor, UIColor.gradientColor.samon.cgColor])
        gradientColorSets.append([UIColor.gradientColor.skyBlue.cgColor, UIColor.gradientColor.blueLagoon.cgColor])
        gradientBackground.colors = gradientColorSets[0]
        self.view.layer.addSublayer(gradientBackground)
    }
    
    var collectionCells = [LocationViewCell.reuseId, LoginViewCell.reuseId]
    var collectionView: UICollectionView!
    let layout = UICollectionViewFlowLayout()
    let pageDots = UIPageControl()
    
    
    //TODO: Subclass this collectionView
    func createCollectionView() {
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.autoSetDimension(.height, toSize: view.frame.height)
        collectionView.register(LocationViewCell.self, forCellWithReuseIdentifier: LocationViewCell.reuseId)
        collectionView.register(LoginViewCell.self, forCellWithReuseIdentifier: LoginViewCell.reuseId)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        
        pageDots.numberOfPages = collectionCells.count
        
        self.view.addSubview(pageDots)
        self.view.addSubview(collectionView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createLayer()
        createCollectionView()
    }

    // MARK: UICollectionView delegate methods
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = collectionView.contentOffset
        visibleRect.size = collectionView.bounds.size
        
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath: IndexPath? = collectionView.indexPathForItem(at: visiblePoint)
        
        guard let page = visibleIndexPath?.item else { return }
        gradientBackground.colors = gradientColorSets[page]
        pageDots.currentPage = page
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionCells[indexPath.item]
        var pageForCell = collectionView.dequeueReusableCell(withReuseIdentifier: cell, for: indexPath) as! ConfigurableCell
        if (pageForCell is LoginViewCell){
        pageForCell.delegate = self
        }
        return pageForCell as! UICollectionViewCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    // MARK: Constraints for subview
    var didSetupConstraints = false
    override func updateViewConstraints() {
        if (!didSetupConstraints) {
            collectionView.autoPinEdgesToSuperviewEdges()
            pageDots.autoPinEdgesToSuperviewEdges(with: self.view.safeAreaInsets, excludingEdge: .top)
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    
    var socialButtonType: LoginButton!
    func didPressLogin() {
        let loginButtonHandler = LoginButtonHandler(controller: self)
        loginButtonHandler.login(with: socialButtonType!)
    }
}
