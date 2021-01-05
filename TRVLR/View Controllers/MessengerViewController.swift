//
//  MessengerViewController.swift
//  TRVLR
//
//  Created by Petar Kleskovic (RIT Student) on 12/7/19.
//  Copyright © 2019 Klara Lucianovic & Petar Kleskovic (RIT Student). All rights reserved.
//
//  Done with the help of: https://stackoverflow.com/questions/53904105/collectionview-updates-and-duplicated-sequentially-in-my-chat-view-swift-4-2

import UIKit
import MessengerKit

class MessengerViewController: MSGMessengerViewController {
    
    var match: Match?
    var localUser: User?
    var otherUser: User?
    
    var messages = [[MSGMessage]]()
    var indexCounter: Int = 0
    
    // Users in the chat
    
    
    //Messages
    
    // Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let localUser = localUser else { return }
        guard let otherUser = otherUser else { return }
        
        getRealtimeChatUpdates(localUser: localUser, otherUser: otherUser)
        title = otherUser.username
        
        dataSource = self
    }
    
    override var style: MSGMessengerStyle {
        var style = MessengerKit.Styles.iMessage
        style.inputPlaceholder = "Message"
        style.alwaysDisplayTails = false
        style.outgoingBubbleColor = .black
        style.outgoingTextColor = .white
        style.incomingTextColor = .black
        style.backgroundColor = .white
        return style
    }
}

// MARK: - MSGDataSource

extension MessengerViewController: MSGDataSource {
    
    func numberOfSections() -> Int {
        return messages.count
    }
    
    func numberOfMessages(in section: Int) -> Int {
        return messages[section].count
    }
    
    func message(for indexPath: IndexPath) -> MSGMessage {
        return messages[indexPath.section][indexPath.item]
    }
    
    func footerTitle(for section: Int) -> String? {
        return "Just now"
    }
    
    func headerTitle(for section: Int) -> String? {
        return messages[section].first?.user.displayName
    }
    
    func getRealtimeChatUpdates(localUser: User, otherUser: User) {
        guard let unwrappedMatch = match else { return }
        DataManager.shared.ref.child("chats").child(unwrappedMatch.chatUID).observe(.childAdded) { (snapshot) in
            guard let rawData = snapshot.value else { return }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: rawData, options: .prettyPrinted)
                let decoder = JSONDecoder()
                let model = try decoder.decode(ChatMessage.self, from: data)
                
                    var _isSender = false
                    var _avatarUrl = ""
                    var _user: User
                    
                    if(model.userUID == localUser.uid){
                        _isSender = true
                        _avatarUrl = localUser.profileImageUrl
                        _user = localUser
                    } else {
                        _avatarUrl = otherUser.profileImageUrl
                        _user = otherUser
                    }
                    
                    let body: MSGMessageBody = (model.value.containsOnlyEmoji && model.value.count < 5) ? .emoji(model.value) : .text(model.value)
                    
                    let newMessage = MSGMessage(id: self.indexCounter, body: body, user: ChatUser(displayName: _user.username, avatarUrl: _avatarUrl, isSender: _isSender), sentAt: Date(timeIntervalSinceNow: 0))
                    self.indexCounter += 1       // I am sorry for programming 1 coding but i am tired and this is tiring
                    
                    self.insert(newMessage)
                    //self.collectionView.reloadData()
                
            } catch {
                print(error)
            }
        }
    }
    
    // Sends the message
    override func inputViewPrimaryActionTriggered(inputView: MSGInputView) {
        guard let match = match else { return }
        guard let local = localUser else { return }
        let message: Dictionary<String, Any> = [
            "type": "text",
            "value": inputView.message,
            "userUID": local.uid,
            "date": "\(Date.timeIntervalSinceReferenceDate)"
        ]
        DataManager.shared.ref.child("chats/\(match.chatUID)").childByAutoId().setValue(message)
    }
    
    override func insert(_ message: MSGMessage) {
        
        collectionView.performBatchUpdates({
            if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                self.messages[self.messages.count - 1].append(message)
                
                let sectionIndex = self.messages.count - 1
                let itemIndex = self.messages[sectionIndex].count - 1
                self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                
            } else {
                self.messages.append([message])
                let sectionIndex = self.messages.count - 1
                self.collectionView.insertSections([sectionIndex])
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: true)
            self.collectionView.layoutTypingLabelIfNeeded()
        })
        
    }
    
    override func insert(_ messages: [MSGMessage], callback: (() -> Void)? = nil) {
        
        collectionView.performBatchUpdates({
            for message in messages {
                if let lastSection = self.messages.last, let lastMessage = lastSection.last, lastMessage.user.displayName == message.user.displayName {
                    self.messages[self.messages.count - 1].append(message)
                    
                    let sectionIndex = self.messages.count - 1
                    let itemIndex = self.messages[sectionIndex].count - 1
                    self.collectionView.insertItems(at: [IndexPath(item: itemIndex, section: sectionIndex)])
                    
                } else {
                    self.messages.append([message])
                    let sectionIndex = self.messages.count - 1
                    self.collectionView.insertSections([sectionIndex])
                }
            }
        }, completion: { (_) in
            self.collectionView.scrollToBottom(animated: false)
            self.collectionView.layoutTypingLabelIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                callback?()
            }
        })
    }
}

