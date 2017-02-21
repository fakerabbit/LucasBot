//
//  Gallery.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/20/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class Gallery: UIView {
    
    typealias GalleryOnButton = (MenuButton?) -> Void
    var onButton: GalleryOnButton = { button in }
    
    var itemW: CGFloat = 200
    var indent: CGFloat! {
        didSet {
            self.layoutIfNeeded()
        }
    }
    var content: Menu! {
        didSet {
            for i: GalleryItem in items {
                i.removeFromSuperview()
            }
            items.removeAll()
            if content != nil {
                for i in 0 ..< content.buttons!.count {
                    let item: MenuButton = content.buttons![i]
                    let galleryItem = GalleryItem(frame: CGRect.zero)
                    galleryItem.title = item.title
                    galleryItem.imgUrl = item.imgUrl
                    galleryItem.url = item.url
                    galleryItem.payload = item.payload
                    items.append(galleryItem)
                    scrollView.addSubview(galleryItem)
                    galleryItem.button.tag = i
                    galleryItem.button.addTarget(self, action: #selector(onItem(_:)), for: .touchUpInside)
                }
            }
            self.layoutSubviews()
        }
    }
    
    private let pad: CGFloat = 2
    private var items: [GalleryItem] = []
    private lazy var scrollView: UIScrollView! = {
        let scroll = UIScrollView(frame: CGRect.zero)
        scroll.backgroundColor = UIColor.clear
        scroll.alwaysBounceHorizontal = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    // MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.indent = 2
        self.addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        scrollView.frame = CGRect(x: 0, y: 0, width: w, height: h)
        var x: CGFloat = indent
        for i in 0 ..< items.count {
            let item: GalleryItem = items[i]
            item.frame = CGRect(x: x, y: 0, width: itemW, height: h)
            x += itemW + pad
        }
        scrollView.contentSize = CGSize(width: x, height: h)
    }
    
    // MARK:- Private
    
    func onItem(_ sender : UIButton) {
        let b:MenuButton = self.content.buttons![sender.tag]
        self.onButton(b)
    }
}
