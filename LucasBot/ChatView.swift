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
    
    typealias ChatViewOnButton = (MenuButton?) -> Void
    var onButton: ChatViewOnButton = { button in }
    
    lazy var collectionView: UICollectionView! = {
        let frame = self.frame
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Utils.interBubbleSpace
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
    
    var newMessage: Message! {
        didSet {
            self.collectionView.performBatchUpdates({
                let row:Int = self.messages.count
                self.messages.append(self.newMessage)
                self.collectionView.insertItems(at: [IndexPath(row: row, section: 0)])
            }, completion: { finished in
                var row:Int = self.messages.count - 1
                if row < 0 {
                    row = 0
                }
                self.collectionView.scrollToItem(at: IndexPath(row: row, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
            })
        }
    }
    
    var newBotMessage: Message! {
        didSet {
            var completeRow:Int = 0
            self.collectionView.performBatchUpdates({
                let row:Int = self.messages.count - 1
                if (row >= 0) {
                    let _ = self.messages.popLast()
                    self.messages.append(self.newBotMessage)
                    self.collectionView.reloadItems(at: [IndexPath(row: row, section: 0)])
                    completeRow = row
                }
                else {
                    self.messages.append(self.newBotMessage)
                    self.collectionView.insertItems(at: [IndexPath(row: row, section: 0)])
                    completeRow = row - 1
                }
            }, completion: { finished in
                if completeRow < 0 {
                    completeRow = 0
                }
                self.collectionView.scrollToItem(at: IndexPath(row: completeRow, section: 0), at: UICollectionViewScrollPosition.bottom, animated: true)
            })
        }
    }
    
    lazy var chatInput: ChatInput! = {
        let input: ChatInput = ChatInput(frame: CGRect.zero)
        return input
    }()
    
    lazy var greenDot: UIView! = {
        let view = UIView(frame: CGRect.zero)
        view.backgroundColor = Utils.greenColor()
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 10.0;
        view.layer.masksToBounds = false;
        return view
    }()
    
    lazy var typing: TypingView! = {
       let view = TypingView(frame: CGRect.zero)
        return view
    }()
    
    /*
     * MARK:- Init
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Utils.backgroundColor()
        
        messages = []
        
        self.addSubview(collectionView)
        self.addSubview(chatInput)
        chatInput.containerView = collectionView
        
        let h: CGFloat = frame.size.height
        let w: CGFloat = frame.size.width
        chatInput.frame = CGRect(x: 0, y: h - chatInput.frame.size.height, width: chatInput.frame.size.width, height: chatInput.frame.size.height)
        collectionView.frame = CGRect(x: 0, y: 0, width: w, height: chatInput.frame.minY)
        
        self.addSubview(greenDot)
        let dotW: CGFloat = w * 2
        let dotH: CGFloat = h * 2
        greenDot.frame = CGRect(x: w - dotW, y: h - dotH, width: dotW, height: dotH)
        
        self.addSubview(typing)
        typing.frame.origin = CGPoint(x: 0, y: h)
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
        var previous:Message?
        let index = indexPath.row - 1
        if index >= 0 {
            previous = self.messages[indexPath.row - 1]
        }
        
        let cell:ChatCell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath) as! ChatCell
        cell.isUser = message.type == "user" ? true : false
        cell.hideAvatar = self.hideAvatar(currentMsg: message, previousMsg: previous)
        cell.text = message.text
        cell.imgUrl = message.imgUrl
        cell.gifUrl = message.giphy
        cell.typing = message.typing
        if let width: String = message.width {
            let w = NumberFormatter().number(from: width)!.floatValue
            cell.gifWidth = CGFloat(w)
        }
        else {
            cell.gifWidth = 0
            //debugPrint("text for gifWidth 0:")
            //debugPrint(message.text)
        }
        cell.menu = message.menu
        cell.gallery = message.gallery
        cell.quickReply = message.quickReply
        
        cell.menuView.onButton = { button in
            self.onButton(button)
        }
        cell.galleryView.onButton = { button in
            self.onButton(button)
        }
        cell.repliesView.onButton = { button in
            self.onButton(button)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var message:Message? = messages[indexPath.row]
        let pad: CGFloat = 20
        var size = CGSize(width: collectionView.frame.size.width - pad, height: 10)
        if message != nil {
            if let _: String = message!.imgUrl {
                size = CGSize(width: collectionView.frame.size.width - pad, height: 250)
                message?.width = "167"
                messages[indexPath.row] = message!
            }
            else if let quickReply: Menu = message!.quickReply {
                let label = ChatTextView(frame: CGRect.zero)
                label.font = Utils.chatFont()
                label.text = quickReply.title
                label.sizeToFit()
                size = label.sizeThatFits(CGSize(width: collectionView.frame.size.width/1.5, height: CGFloat.greatestFiniteMagnitude))
                size.width = collectionView.frame.size.width - pad
                let h = NumberFormatter().number(from: message!.height!)!.floatValue
                //var height: CGFloat = CGFloat(h) * CGFloat((quickReply.buttons?.count)!)
                let height = size.height + Utils.interBubbleSpace + CGFloat(h) + 20
                size.height = height
            }
            else if let height: String = message!.height {
                let h = NumberFormatter().number(from: height)!.floatValue
                size = CGSize(width: collectionView.frame.size.width - pad, height: CGFloat(h))
            }
            else if let text: String = message!.text {
                let label = ChatTextView(frame: CGRect.zero)
                label.font = Utils.chatFont()
                label.text = text
                label.sizeToFit()
                size = label.sizeThatFits(CGSize(width: collectionView.frame.size.width/1.5, height: CGFloat.greatestFiniteMagnitude))
                message?.width = size.width.description
                messages[indexPath.row] = message!
                size.width = collectionView.frame.size.width - pad
                //debugPrint("size for Text:")
                //debugPrint(size)
            }
        }
        
        return size
    }
    
    // MARK:- Private methods
    
    private func hideAvatar(currentMsg: Message, previousMsg: Message?) -> Bool {
        var hide = false
        
        if previousMsg != nil {
            hide = currentMsg.type == previousMsg!.type || currentMsg.type == "user"
        }
        
        return hide
    }
    
    // MARK:- Animations
    
    func animateView() {
        
        UIView.animate(withDuration: 1.5, animations: {
            
            let w = self.frame.size.width
            let h = self.frame.size.height
            self.greenDot.frame = CGRect(x: w - 20, y: h - 20, width: 5, height: 5)
        }, completion: { finished in
            self.greenDot.removeFromSuperview()
            self.chatInput.animateSendBtn()
        })
    }
    
    func animateTyping(anim: Bool) {
        if anim  == true {
            self.chatInput.animateTyping(anim: anim)
            /*UIView.animate(withDuration: 1.0, animations: {
                self.typing.frame.origin = CGPoint(x: 0, y: self.frame.size.height - self.typing.frame.size.height)
            }, completion: nil)*/
        }
        else {
           /* UIView.animate(withDuration: 1.0, animations: {
                self.typing.frame.origin = CGPoint(x: 0, y: self.frame.size.height + self.typing.frame.size.height)
            }, completion: nil)*/
            self.chatInput.animateTyping(anim: anim)
        }
    }
}
