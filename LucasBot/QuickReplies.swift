//
//  QuickReplies.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/20/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class QuickReplies: UIView {
    
    typealias QuickRepliesOnButton = (MenuButton?) -> Void
    var onButton: QuickRepliesOnButton = { button in }
    
    var indent: CGFloat = 5
    var content: Menu! {
        didSet {
            for i: UIView in replies {
                i.removeFromSuperview()
            }
            replies.removeAll()
            
            if content != nil {
                
                textView.text = content.title
                textView.sizeToFit()
                
                for i in 0 ..< content.buttons!.count {
                    let item: MenuButton = content.buttons![i]
                    let reply = Reply(frame: CGRect.zero)
                    reply.textView.text = item.title
                    replies.append(reply)
                    scrollView.addSubview(reply)
                    reply.button.tag = i
                    reply.button.addTarget(self, action: #selector(onReply(_:)), for: .touchUpInside)
                }
            }
            self.layoutSubviews()
        }
    }
    
    private let pad: CGFloat = 5
    private var replies: [Reply] = []
    private lazy var scrollView: UIScrollView! = {
        let scroll = UIScrollView(frame: CGRect.zero)
        scroll.backgroundColor = UIColor.clear
        scroll.alwaysBounceHorizontal = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    private lazy var textView: ChatTextView! = {
        let view = ChatTextView(frame: CGRect.zero)
        view.backgroundColor = Utils.botBubbleColor()
        view.textColor = Utils.chatBotColor()
        view.textAlignment = .left
        return view
    }()
    
    // MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    
        self.addSubview(scrollView)
        self.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        let h = self.frame.size.height
        
        let fixedWidth = w/1.5
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: newSize.width, height: newSize.height)
        textView.frame = newFrame
        textView.frame.origin = CGPoint(x: indent, y: 0)
        
        scrollView.frame = CGRect(x: 0, y: textView.frame.maxY + Utils.interBubbleSpace, width: w, height: h - newSize.height)
        var x: CGFloat = pad
        for i in 0 ..< replies.count {
            
            let item: Reply = replies[i]
            let fixedHeight = h - newSize.height
            let newSize = item.textView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: fixedHeight))
            var newFrame = item.frame
            newFrame.size = CGSize(width: newSize.width, height: newSize.height)
            item.frame = newFrame
            item.frame.origin = CGPoint(x: x, y: 0)
            x += newSize.width + pad
        }
        scrollView.contentSize = CGSize(width: x, height: h - newSize.height)
    }
    
    // MARK:- Private
    
    func onReply(_ sender : Reply) {
        let b:MenuButton = self.content.buttons![sender.tag]
        self.onButton(b)
    }
}
