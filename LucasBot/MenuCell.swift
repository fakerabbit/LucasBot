//
//  Menu.swift
//  LucasBot
//
//  Created by Mirko Justiniano on 2/19/17.
//  Copyright © 2017 LB. All rights reserved.
//

import Foundation
import UIKit

class MenuCell: UIView, UITextViewDelegate {
    
    typealias MenuCellOnButton = (MenuButton?) -> Void
    var onButton: MenuCellOnButton = { button in }
    
    var title: String! {
        didSet {
            textView.text = title
            textView.sizeToFit()
            self.layoutSubviews()
        }
    }
    
    var buttons: [MenuButton]! {
        didSet {
            for view in btnViews {
                view.removeFromSuperview()
            }
            btnViews.removeAll()
            if buttons != nil {
                for i in 0 ..< buttons.count {
                    let b: MenuButton = buttons[i]
                    let btn = UIButton(type: .custom)
                    btn.setTitle(b.title, for: .normal)
                    btn.setTitleColor(Utils.chatUserColor(), for: .normal)
                    btn.titleLabel?.font = Utils.boldFont()
                    btn.addTarget(self, action: #selector(onButton(_:)), for: .touchUpInside)
                    btn.backgroundColor = Utils.userBubbleColor()
                    btn.layer.cornerRadius = 6.0;
                    btn.layer.masksToBounds = false;
                    btn.clipsToBounds = true
                    btn.tag = i
                    btnViews.append(btn)
                    self.addSubview(btn)
                }
            }
        }
    }
    
    private let itemH: CGFloat = CGFloat((Utils.menuItemHeight as NSString).floatValue)
    private var btnViews: [UIButton] = []
    
    private lazy var textView: ChatTextView! = {
        let view = ChatTextView(frame: CGRect.zero)
        view.backgroundColor = Utils.botBubbleColor()
        view.textColor = Utils.chatBotColor()
        view.textAlignment = .left
        view.delegate = self
        return view
    }()
    
    // MARK:- Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        
        self.addSubview(textView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let w = self.frame.size.width
        
        let newSize = textView.sizeThatFits(CGSize(width: w, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: newSize.width, height: newSize.height)
        textView.frame = newFrame
        textView.frame.origin = CGPoint(x: 0, y: 0)
        
        //textView.frame = CGRect(x: 0, y: 0, width: textView.frame.size.width, height: itemH)
        var y = textView.frame.maxY + Utils.interBubbleSpace
        for view in btnViews {
            view.frame = CGRect(x: 0, y: y, width: w, height: itemH)
            y += itemH + Utils.interBubbleSpace
        }
    }
    
    // MARK:- Handlers
    
    func onButton(_ sender : UIButton) {
        let b:MenuButton = self.buttons[sender.tag]
        self.onButton(b)
    }
    
    // MARK:- UITextViewDelegate methods
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = textView.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        textView.frame = newFrame
    }
}
