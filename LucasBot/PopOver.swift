//
//  PopOverView.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/20/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class PopOver: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    typealias PopOverOnCell = (MenuButton?) -> Void
    var onCell: PopOverOnCell = { button in }
    
    var parentRect: CGRect = CGRect.zero
    
    lazy var loading: UIActivityIndicatorView! = {
        let load = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        load.hidesWhenStopped = true
        load.startAnimating()
        return load
    }()
    
    private let backgroundImg: UIImageView! = {
       let view = UIImageView(image: UIImage(named: Utils.kPopBg))
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var collectionView: UICollectionView! = {
        let frame = self.frame
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        let cv: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.alwaysBounceVertical = true
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(PopCell.classForCoder(), forCellWithReuseIdentifier: "PopCell")
        return cv
    }()
    
    var menuItems: [MenuButton?] = []
    
    // MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        ///self.layer.cornerRadius = 6.0;
        //self.layer.masksToBounds = false;
        //self.clipsToBounds = true
        self.addSubview(backgroundImg)
        self.addSubview(collectionView)
        self.addSubview(loading)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        backgroundImg.frame = CGRect(x: 0, y: 0, width: w, height: h)
        collectionView.frame = CGRect(x: 0, y: 10, width: w - 10, height: h - 30)
        loading.frame = CGRect(x: w/2 - loading.frame.size.width/2, y: h/2 - loading.frame.size.height/2, width: loading.frame.size.width, height: loading.frame.size.height)
    }
    
    // MARK:- Data Provider
    
    func fetchMenu() {
        
        NetworkMgr.sharedInstance.fetchMenu() { [weak self] buttons in
            self?.menuItems = buttons
            DispatchQueue.main.async {
                self?.growAnimation()
            }
        }
    }
    
    /*
     * MARK:- CollectionView Datasource & Delegate
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let button = self.menuItems[indexPath.row]
        
        let cell:PopCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopCell", for: indexPath) as! PopCell
        cell.title = button?.title
        cell.imgUrl = button?.imgUrl
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width - 20, height: CGFloat((Utils.menuItemHeight as NSString).floatValue))
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let button = self.menuItems[indexPath.row]
        self.onCell(button)
    }
    
    // MARK:- Animations
    
    func growAnimation() {
        self.isHidden = true
        let h:CGFloat = UIScreen.main.bounds.size.height/3 + 10
        self.frame = CGRect(x: self.frame.origin.x, y: self.parentRect.minY - (h - 10), width: UIScreen.main.bounds.size.width - 20, height: h)
        UIView.animate(withDuration: 2, animations: {
            self.isHidden = false
        }, completion: { [weak self] finished in
            self?.loading.stopAnimating()
            self?.layoutIfNeeded()
            self?.collectionView.reloadData()
        })
    }
}
