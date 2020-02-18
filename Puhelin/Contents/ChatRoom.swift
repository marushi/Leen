//
//  ChatRoom.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/18.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import JSQMessagesViewController

class ChatRoom: JSQMessagesViewController {
    
    let userDefaults = UserDefaults.standard
    var listener: ListenerRegistration!
    var messages: [MessageData] = []
    var jsqMessages: [JSQMessage] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定
        senderId = userDefaults.string(forKey: "uid")
        senderDisplayName = userDefaults.string(forKey: "name")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //上のバーを表示、下のバーを消す
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.ChatPath)
            listener = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
            // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
            self.messages = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let userData = MessageData(document: document)
                return userData
            }
            // TableViewの表示を更新する
            self.collectionView.reloadData()
            
            }
        }
    }
    
     //アイテムごとに参照するメッセージデータを返す
        override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
            
            //firebaseのデータをJSQMessage型に入れて表示
            let senderId = self.messages[indexPath.row].senderId
            let displayName = self.messages[indexPath.row].displayName
            let text = messages[indexPath.row].text
            jsqMessages[indexPath.row] = JSQMessage(senderId: senderId, displayName: displayName, text: text)
            return jsqMessages[indexPath.row]
        }


         //アイテムごとのMessageBubble(背景)を返す
        override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
            if messages[indexPath.row].senderId == senderId {
                return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(
                    with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
            } else {
                return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(
                    with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
            }
        }


         // cell for item
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
            
            if messages[indexPath.row].senderId == senderId {
                cell.textView?.textColor = UIColor.white
            } else {
                cell.textView?.textColor = UIColor.darkGray
            }
            return cell
        }
        
        
        // section
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return messages.count
        }


         // image data for item
        override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
            
            //senderId == 自分　だった場合表示しない
            let senderId = messages[indexPath.row].senderId
            
            if senderId == "Dummy" {
                return nil
            }
            return JSQMessagesAvatarImage.avatar(with: UIImage(named: "Button_1"))
        }


         //時刻表示のための高さ調整
        override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAt indexPath: IndexPath!) -> NSAttributedString! {
            
            let message = jsqMessages[indexPath.item]
            if indexPath.item == 0 {
                return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
            }
            if indexPath.item - 1 > 0 {
                let previousMessage = jsqMessages[indexPath.item - 1]
                if message.date.timeIntervalSince(previousMessage.date) / 60 > 1 {
                    return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
                }
            }
            return nil
        }


         // 送信時刻を出すために高さを調整する
        override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAt indexPath: IndexPath!) -> CGFloat {
            
            if indexPath.item == 0 {
                return kJSQMessagesCollectionViewCellLabelHeightDefault
            }
            if indexPath.item - 1 > 0 {
                let previousMessage = jsqMessages[indexPath.item - 1]
                let message = jsqMessages[indexPath.item]
                if message.date .timeIntervalSince(previousMessage.date) / 60 > 1 {
                    return kJSQMessagesCollectionViewCellLabelHeightDefault
                }
            }
            return 0.0
        }

        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    //Sendボタンが押された時に呼ばれる
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        //キーボードを閉じる
        self.view.endEditing(true)
        
        //メッセージを追加
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
        self.jsqMessages.append(message!)
        
        //送信を反映
        self.finishReceivingMessage(animated: true)
        
        //textFieldをクリアする
        self.inputToolbar.contentView.textView.text = ""
        
        //テスト返信を呼ぶ
        testRecvMessage()
    }

     //テスト用「マグロならあるよ！」を返す
    func testRecvMessage() {
        
        let message = JSQMessage(senderId: "sushi", displayName: "B", text: "マグロならあるよ！")
        self.jsqMessages.append(message!)
        self.finishReceivingMessage(animated: true)
    }
 
}


