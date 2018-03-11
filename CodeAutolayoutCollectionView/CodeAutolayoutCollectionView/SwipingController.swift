//
//  SwipingController.swift
//  CodeAutolayoutCollectionView
//
//  Created by lhvan on 3/11/18.
//  Copyright © 2018 lhvan. All rights reserved.
//

import UIKit
struct Page {
    let imageName: String
    let headerText: String
    let bodyText: String
}

class SwipingController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let pages:[Page] = [
        Page(imageName: "bear_first", headerText: "Join use today in our fun and games!", bodyText: "Are you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our stores soon."),
        Page(imageName: "heart_second", headerText: "Subscribe and get coupons on our daily events", bodyText: "Get notified of the savings immediately when we announce them on our website. Make sure to also give us any feedback you have."),
        Page(imageName: "leaf_third", headerText: "VIP members special services", bodyText: "")
    ]
    
    private let previousButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.addTarget(self, action: #selector(handlePrev), for: .touchUpInside)
        button.setTitleColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), for: .normal)
        return button
    }()
    private let nextButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.addTarget(self, action: #selector(handleNext), for: .touchUpInside)
        button.setTitleColor(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1), for: .normal)
        return button
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.numberOfPages = pages.count
        pc.pageIndicatorTintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 0.7015999572)
        pc.currentPageIndicatorTintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)

        return pc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.isPagingEnabled = true
        collectionView?.register(PageCell.self, forCellWithReuseIdentifier: "cellId")
        
        setupBottomControls()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (_) in
            self.collectionViewLayout.invalidateLayout()
            if self.pageControl.currentPage == 0 {
                self.collectionView?.contentOffset = .zero
            }else{
                let indexPath = IndexPath(item: self.pageControl.currentPage, section: 0)
                self.collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }) { (_) in
            
        }
    }
    
    @objc func handleNext(){
        let nextIndex = min(self.pageControl.currentPage + 1, pages.count - 1)
        self.pageControl.currentPage = nextIndex
        let indexPath = IndexPath(item: nextIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    @objc func handlePrev(){
        let prevIndex = max(self.pageControl.currentPage - 1, 0)
        self.pageControl.currentPage = prevIndex
        let indexPath = IndexPath(item: prevIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func setupBottomControls(){
        let stackView = UIStackView(arrangedSubviews: [previousButton, pageControl, nextButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        self.pageControl.currentPage = Int(x/view.frame.width)
    }
}







