//
//  ChatRoom2.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/28.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import JSQMessagesViewController

class ChatRoom2: JSQMessagesViewController{

    @objc dynamic var noneReadedMes:Int = 0
    let userDefaults = UserDefaults.standard
    
    var listener: ListenerRegistration!
    var listener2: ListenerRegistration!
    var listener3: ListenerRegistration!
    var jsqMessages: [JSQMessage] = []
    var roomId: String?
    var OpponentId: String?
    var Users:String?
    var topImage: UIImage = UIImage()
    var opName:String?
    
override func viewDidLoad() {
    super.viewDidLoad()
        //設定
        senderId = userDefaults.string(forKey: "uid")
        senderDisplayName = userDefaults.string(forKey: "name")
        // 新しいメッセージを受信するたびに下にスクロールする
        automaticallyScrollsToMostRecentMessage = true
        inputToolbar!.contentView!.leftBarButtonItem = nil
        //オブザーバー
        self.addObserver(self, forKeyPath: "noneReadedMes", options: [.old,.new], context: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        //下のバーを消す
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
            
        //送信を反映
        self.finishReceivingMessage(animated: true)
        //既読処理
        readedFunction()
        //マッチング券処理
        useMatchingTicket()
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        self.listener3.remove()
        let buttonView = self.navigationController?.view.viewWithTag(1)
        buttonView?.removeFromSuperview()
    }
        
    @IBAction func button(_ sender: Any) {
        let BlackView = self.storyboard?.instantiateViewController(identifier: "BlackView") as! BlackView
        BlackView.roomId = self.roomId!
        BlackView.roomMode = 1
        present(BlackView,animated: true,completion: nil)
    }
        
    //既読処理
    func readedFunction(){
        if listener3 == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.MatchingPath).document(roomId!).collection(Const.MessagePath).whereField("readed", isEqualTo: false).whereField("senderId", isEqualTo: OpponentId!)
            listener3 = Ref.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                let nonReadMesNum:Int? = querySnapshot?.count
                let nonReadMesData:[MessageData] = querySnapshot!.documents.map { document in
                print("DEBUG_PRINT: document取得 \(document.documentID)")
                let mesData = MessageData(document: document)
                return mesData
                }
                //readedをtrueに
                if nonReadMesNum != 0 && nonReadMesNum != nil{
                    self.noneReadedMes = nonReadMesNum!
                    for i in 0...nonReadMesNum! - 1 {
                        let ref = Firestore.firestore().collection(Const.MatchingPath).document(self.roomId!).collection(Const.MessagePath).document(nonReadMesData[i].id!)
                        let batch = Firestore.firestore().batch()
                        batch.updateData(["readed":true], forDocument: ref)
                        batch.commit()
                    }
                    self.noneReadedMes = 0
                }else{
                        
                }
            }
        }
    }
    

    func useMatchingTicket() {
        //"firstEnter1""firstEnter2""useMatchingTicket1""useMatchingTicket2"
        let ref = Firestore.firestore().collection(Const.MatchingPath).document(roomId!)
        ref.getDocument(){ (data,error) in
            if let error = error {
                print(error)
                return
            }
            let gender:Int? = self.userDefaults.integer(forKey: "gender")
            let fe1:Bool? = data?.get("firstEnter1") as? Bool
            let fe2:Bool? = data?.get("firstEnter2") as? Bool
            let use1:Bool? = data?.get("useMatchingTicket1") as? Bool
            let use2:Bool? = data?.get("useMatchingTicket2") as? Bool
            if gender == 1 {
                if fe1 == false {
                    ref.setData(["firstEnter1":true],merge: true)
                }
                if fe2 == true && use1 == false {
                    //チケット処理
                    let num = self.userDefaults.integer(forKey: UserDefaultsData.matchingNum)
                    let registNum = num - 1
                    //モーダル済み処理
                    self.userDefaults.set(registNum, forKey: UserDefaultsData.matchingNum)
                    ref.setData(["useMatchingTicket1":true],merge: true)
                    //モーダル
                    let MatchSplashView = self.storyboard?.instantiateViewController(identifier: "MatchSplashView") as! MatchSplashView
                    self.present(MatchSplashView,animated: true,completion: nil)
                }
            }else{
                if fe2 == false {
                    ref.setData(["firstEnter2":true],merge: true)
                }
                if fe1 == true && use2 == false {
                    //チケット処理
                    let num = self.userDefaults.integer(forKey: UserDefaultsData.matchingNum)
                    let registNum = num - 1
                    //モーダル済み処理
                    self.userDefaults.set(registNum, forKey: UserDefaultsData.matchingNum)
                    ref.setData(["useMatchingTicket2":true],merge: true)
                    //モーダル
                    let MatchSplashView = self.storyboard?.instantiateViewController(identifier: "MatchSplashView") as! MatchSplashView
                    self.present(MatchSplashView,animated: true,completion: nil)
                }
            }
        }
    }
        //rabbarのバッチの数字を下げる
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            //let preNum:Int = change![.oldKey] as! Int
            let newNum:Int? = change![.newKey] as? Int
            //let reduceNum:Int = newNum - preNum
            if newNum != nil{
                if newNum! < 0 {
                    return
                }else{
                    talk_before.count -= newNum!
                    NotificationCenter.default.post(name: .NewMessage, object: nil)
                }
            }else{
                return
            }
        }
        
        //データのセット
        func setData(_ data: ChatRoomData){
            //初期化
            jsqMessages = []
            
            //Id設定
            self.roomId = data.roomId
            if userDefaults.integer(forKey: "gender") == 1 {
                self.OpponentId = data.female
                Users = Const.FemalePath
            } else if userDefaults.integer(forKey: "gender") == 2 {
                self.OpponentId = data.male
                Users = Const.MalePath
            }
            
            //メッセージ取得
            if listener == nil{
            // listener未登録なら、登録してスナップショットを受信する
                let Ref = Firestore.firestore().collection(Const.MatchingPath).document(roomId!).collection(Const.MessagePath).order(by: "sendTime",descending: true).limit(to: 25)
                listener = Ref.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                // 取得したdocumentをもとにPostDataを作成し、postArrayの配列にする。
                self.jsqMessages = querySnapshot!.documents.map { document in
                    print("DEBUG_PRINT_Message: document取得 \(document.documentID)")
                    let mesData = MessageData(document: document)
                    let message = JSQMessage(senderId: mesData.senderId, displayName: mesData.displayName, text: mesData.text)
                    return message!
                }
                    self.jsqMessages = self.jsqMessages.reversed()
                    self.finishReceivingMessage()
                }
            }
            
            // listener未登録なら、登録してスナップショットを受信する
            
                let Ref = Firestore.firestore().collection(Users!).document(OpponentId!)
                Ref.getDocument() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                //名前
                    if let name:String = querySnapshot?.get("name") as? String {
                        self.navigationItem.title = name
                    }
                    //画像を設定
                    if let photoId = querySnapshot?.get("photoId") as? String {
                        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(photoId)
                            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                            if let error = error {
                                print(error)
                            } else {
                                let image = UIImage(data: data!)
                                let topImage:UIImage = image!.imageWithCornerRadius(cornerRadius: image!.size.height / 2)
                                self.topImage = topImage
                                self.collectionView.reloadData()
                            }
                        }
                    }else{
                        if UserDefaults.standard.integer(forKey: "gender") == 2 {
                            self.topImage = UIImage(named: "male")!
                        }else{
                            self.topImage = UIImage(named: "female")!
                        }
                    }
                }
        }
        
        //戻るボタン
        @IBAction func modoru(_ sender: Any) {
            self.tabBarController?.tabBar.isHidden = false
            self.navigationController?.popViewController(animated: true)
        }
        
        //アイテムごとに参照するメッセージデータを返す
        override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
            return jsqMessages[indexPath.row]
        }

        //アイテムごとのMessageBubble(背景)を返す
        override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
            if userDefaults.integer(forKey: "gender") == 1 {
               if jsqMessages[indexPath.row].senderId == senderId {
                    return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: ColorData.turquoise)
               } else {
                return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: ColorData.salmon)
                }
            }else{
                if jsqMessages[indexPath.row].senderId == senderId {
                     return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: ColorData.salmon)
                } else {
                 return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: ColorData.turquoise)
                 }
            }
        }

        // cell for item
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                
            let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
            
            // ユーザーアイコンに対してジェスチャーをつける
            let avatarImageTap = UITapGestureRecognizer(target: self, action: #selector(tappedAvatar))
            cell.avatarImageView?.isUserInteractionEnabled = true
            cell.avatarImageView?.addGestureRecognizer(avatarImageTap)
                
            if jsqMessages[indexPath.row].senderId == senderId {
                    cell.textView?.textColor = UIColor.white
            } else {
                cell.textView?.textColor = UIColor.white
            }
            return cell
            
        }
            
        // section
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return jsqMessages.count
        }

        // image data for item
        override func collectionView(_ collectionView: JSQMessagesCollectionView!,avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        
            //senderId == 自分　だった場合表示しない
            let senderId = jsqMessages[indexPath.row].senderId
            if senderId == userDefaults.string(forKey: "uid") {
                return nil
            }else {
                return JSQMessagesAvatarImage.avatar(with: self.topImage)
            }
        }
            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
            }
        
        //Sendボタンが押された時に呼ばれる
        override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
            
            //本人確認を促す画面
            if userDefaults.integer(forKey: "identification") != 2 {
                let vc = self.storyboard?.instantiateViewController(identifier: "NGView") as! NGView
                vc.modalTransitionStyle = .crossDissolve
                present(vc,animated: true,completion: nil)
            }else{
            
            if text == "" {
                return
            }
            //キーボードを閉じる
            self.view.endEditing(true)
            //送信を反映
            self.finishReceivingMessage(animated: true)
            //------------firebaseに保存------------
            //メッセージ
            let Ref = Firestore.firestore().collection(Const.MatchingPath).document(roomId!).collection(Const.MessagePath).document()
            let Dic = ["senderId": senderId as Any
                ,"displayName": senderDisplayName as Any
                ,"text": text as Any
                ,"sendTime": date as Any
                ,"readed": false
                ,"token": userDefaults.string(forKey: "token") as Any] as [String:Any]
            Ref.setData(Dic)
            //textFieldをクリアする
            self.inputToolbar.contentView.textView.text = ""
            self.finishSendingMessage()
            }
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
            
    @objc func tappedAvatar() {
        let Profile = self.storyboard?.instantiateViewController(identifier: "Profile") as! Profile
        Profile.setData(OpponentId!)
        Profile.goodButton.isHidden = true
        present(Profile,animated: true,completion: nil)
    }
}

extension ChatRoom2:dismissDelegate{
    func selfdismissFunction(_ type: Bool) {
        if type == true{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
