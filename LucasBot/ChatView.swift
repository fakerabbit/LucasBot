//
//  ChatView.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 1/8/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class ChatView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView! = {
        let frame = self.frame
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0.8
        layout.minimumInteritemSpacing = 0.8
        layout.sectionInset = UIEdgeInsetsMake(4.0, 8.0, 8.0, 8.0)
        let cv: UICollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = self.backgroundColor
        cv.alwaysBounceVertical = true
        cv.dataSource = self
        cv.delegate = self
        cv.register(ChatCell.classForCoder(), forCellWithReuseIdentifier: "chatCell")
        return cv
    }()
    
    var messages: [Message]! {
        didSet {
            if messages == nil || messages.count == 0 {
                debugPrint("WARNING messages is null")
                return
            }
            self.collectionView.reloadData()
        }
    }
    
    /*
     * MARK:- Init
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(colorLiteralRed: 28/255, green: 35/255, blue: 41/255, alpha: 1.0)
        
        messages = []
        
        self.addSubview(collectionView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
     * MARK:- CollectionView Datasource & Delegate
     */
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let message = self.messages[indexPath.row]
        
        let cell:ChatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatCell
        cell.text = message.text
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message:Message? = messages[indexPath.row]
        var size = CGSize.zero
        if message != nil {
            if let text: String = message!.text {
                let label = UITextView(frame: CGRect.zero)
                label.font = Utils.chatFont()
                label.text = "> " + text
                label.sizeToFit()
                size = label.sizeThatFits(CGSize(width: self.frame.size.width - 20, height: CGFloat.greatestFiniteMagnitude))
            }
        }
        
        return size
    }
}
