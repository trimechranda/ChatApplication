//
//  Message.swift
//  ChatApp
//
//  Created by TRIMECH on 21/03/2018.
//  Copyright © 2018 TRIMECH. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    var owner: MessageOwner
    var type: MessageType
    var content: Any
    var timestamp: Int
    var isRead: Bool
    var image: UIImage?
    private var toID: String?
    private var fromID: String?
    
    
    class func send(message: Message ,toID: String, completion: @escaping (Bool) -> Swift.Void)  {
       
        var IdRoom : String = ""
        var FriendNumCompt : Int = 0
        var MyNumCompt : Int = 0

        if let currentUserID = Auth.auth().currentUser?.uid {
            let group = DispatchGroup()

            group.enter()
            User.GetInfoUser(forUserID: toID, completion: {(user) in
                   FriendNumCompt = user.numCompte
                group.leave()

            })
            let time: DispatchTime = .now() + 0.001
            print(time)
             group.wait(timeout: time)
            
             group.enter()
            User.GetInfoUser(forUserID: currentUserID, completion: {(user) in

                    MyNumCompt = user.numCompte
                group.leave()
            })
            group.wait(timeout: time)
            if(MyNumCompt<FriendNumCompt){
                IdRoom = String( MyNumCompt) + String( FriendNumCompt)
            }
            else {
                IdRoom = String( FriendNumCompt) + String(MyNumCompt)
                }
            switch message.type {
            case .location:
                let values = ["type": "location", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
                Message.uploadMessage(withValues: values, IdRoom:IdRoom, toID: toID, completion: { (status) in
                    completion(status)
                })
            case .text:
                
                let values = ["type": "text", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
                Message.uploadMessage(withValues: values,IdRoom:IdRoom, toID: toID, completion: { (status) in
                    completion(status)
                })
            
            case .photo:
                let values = ["type": "photo", "content": message.content, "fromID": currentUserID, "toID": toID, "timestamp": message.timestamp, "isRead": false]
                Message.uploadMessage(withValues: values, IdRoom:IdRoom,toID: toID, completion: { (status) in
                    completion(status)
                })
            case .video:
                print("this is a video")

            }
        }
    }
    
    class func uploadMessage(withValues: [String: Any],IdRoom:String ,toID: String, completion: @escaping (Bool) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            
            //  let encrypted = AES256CBC.encryptString(message, password: password)
            Database.database().reference().child("conversations").child(currentUserID).child("conversations").child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() {
                   
                    Database.database().reference().child("chats").child(IdRoom).setValue(withValues, withCompletionBlock: { (error, reference) in
                        Database.database().reference().child("conversations").child(toID).setValue(withValues)
                        Database.database().reference().child("conversations").child(currentUserID).setValue(withValues)

                    })
                }
                else {
          Database.database().reference().child("chats").child(IdRoom).childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
            Database.database().reference().child("conversations").child(toID).child(IdRoom).setValue(withValues)
        Database.database().reference().child("conversations").child(currentUserID).child(IdRoom).setValue(withValues)
                        
                        completion(true)
                    })
                }
            })
        }
    }
 /*   class func markMessagesRead(toID: String)  {
        
        let IdRoom = "1O"
        if let currentUserID = Auth.auth().currentUser?.uid {

 Database.database().reference().child("conversations").child(toID).child(IdRoom).updateChildValues(["isRead":true])
 Database.database().reference().child("conversations").child(currentUserID).child(IdRoom).updateChildValues(["isRead":true])

        }
    } */
   
    class func downloadAllMessages(IdRoom: String,kPagination : Int ,completion: @escaping (Message) -> Swift.Void) {
        if let currentUserID = Auth.auth().currentUser?.uid {
         
           // var kPagination: Int?
            let kPagination = (kPagination) + 1
            Database.database().reference().child("chats").child(IdRoom).observe(.childAdded, with: { (snap) in
              if snap.exists() {
                            DispatchQueue.main.async {
                            let receivedMessage = snap.value as! NSDictionary
                           //let messageDict : NSDictionary = receivedMessage.object(forKey: key) as! NSDictionary
                            //let password = "azdrezcldkdk123dkdbnchpeqwxdplke"  // returns random 32 char string
                           // let decrypted = AES256CBC.decryptString((receivedMessage["content"] as? String)!, password: password)
                            let content = receivedMessage["content"] as? String
                            let fromID = receivedMessage["fromID"] as? String
                            let timestamp = receivedMessage["timestamp"] as! Int
                            let messageType = receivedMessage["type"] as? String
                            var type = MessageType.text  
                            if messageType == "photo" {
                              type = .photo
                            } else if messageType == "video" {
                                type = .video
                            }
                            else if messageType == "location" {
                                type = .location
                                }
                             var message : Message
                            if fromID == currentUserID {
                              message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: true)
                                completion(message)

                            } else {
                              message = Message.init(type: type, content: content, owner:.receiver , timestamp: timestamp, isRead: true)
                                completion(message)

                            }

                            }
                            }
                    })
            

        }
    }
    init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool) {
        self.type = type
        self.content = content
        self.owner = owner
        self.timestamp = timestamp
        self.isRead = isRead
    }
}
