//
//  ChatRoom.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/18.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import JSQMessagesViewController


//ピッカービューをtoolbarに設定
extension ChatRoom{
    override var inputAccessoryView: UIView? {
        let toolbar = UIToolbar()
        toolbar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44)

        let space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        space.width = 12
        let cancelItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButton(_:)))
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButton(_:)))

        let toolbarItems = [space, cancelItem, flexSpaceItem, doneButtonItem, space]

        toolbar.setItems(toolbarItems, animated: true)

        return toolbar
    }
    
    
}

//選択できるメッセージ設定
extension ChatRoom: UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerMode == 22 {
            return 3
        }else{
        return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerMode {
        case 0:
            return selectMessages.count
        case 1:
            return greetMessages.count
        case 2:
            return scheduleMessages.count
        case 5:
            return missMessages.count
        case 22:
            switch component {
            case 0:
                return okayMes_1.count
            case 1:
                return okayMes_2.count
            case 2:
                return okayMes_3.count
            default:
                return 0
            }
        default:
            return selectMessages.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerMode {
        case 0:
            return selectMessages[row]
        case 1:
            return greetMessages[row]
        case 2:
            return scheduleMessages[row]
        case 5:
            return missMessages[row]
        case 22:
            switch component {
            case 0:
                return String(okayMes_1[row]) + "日"
            case 1:
                return String(okayMes_2[row]) + "時"
            case 2:
                return String(okayMes_3[row]) + "分"
            
            default:
                return "error"
            }
        default:
            return selectMessages[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerMode == 0 {
            switch row {
            case 0:
                return
            case 1:
                selectMode = 1
            case 2:
                selectMode = 2
            case 3:
                selectMode = 3
            case 4:
                selectMode = 4
            case 5:
                selectMode = 5
            default:
                return
            }
        }else{
            switch pickerMode {
            case 1:
                if row == 0 {
                pickerText = ""
                }else{
                pickerText = greetMessages[row]
                }
            case 2:
                scheduleadjustMode = row
            case 5:
                if row == 0 {
                pickerText = ""
                }else{
                pickerText = missMessages[row]
                }
            case 22:
                switch component {
                case 0:
                    okayText_1 = String(okayMes_1[row]) + "日"
                case 1:
                    okayText_2 = String(okayMes_2[row]) + "時"
                case 2:
                    okayText_3 = String(okayMes_3[row]) + "分"
                default:
                    return
                }
            default:
                return
            }
            
        }
    }
    
    @objc func cancelBarButton(_ sender: UIBarButtonItem) {
        if pickerMode == 0 && picker.selectedRow(inComponent: 0) == 0 {
            self.view.endEditing(true)
        }
        selectMode = 0
        pickerMode = 0
        self.keyboardController.textView.text = ""
        picker.selectRow(0, inComponent: 0, animated: true)
        picker.reloadAllComponents()
        self.inputToolbar.contentView.rightBarButtonItem.isEnabled = false
        
    }
    
    @objc func doneBarButton(_ sender: UIBarButtonItem) {
        if pickerMode == 0 {
            pickerMode = selectMode
            picker.selectRow(0, inComponent: 0, animated: false)
            picker.reloadAllComponents()
        }else if pickerMode == 2 {
            switch scheduleadjustMode {
            case 0:
                return
            case 1:
                return
            case 2:
                pickerMode = 22
                self.keyboardController.textView.text = "ご提案ありがとうございます。では" + okayText_1 + okayText_2 + okayText_3
                picker.reloadAllComponents()
            default:
                return
            }
        }else if pickerMode == 22 {
            self.keyboardController.textView.text = "ご提案ありがとうございます。では、 " + okayText_1 + okayText_2 + okayText_3 + "  にお電話しましょう！"
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }
        else{
            self.keyboardController.textView.text = pickerText
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }
    }
}

class ChatRoom: JSQMessagesViewController {
    
    var pickerMode = 0
    var selectMode = 0
    var scheduleadjustMode = 0
    let picker = UIPickerView()
    let selectMessages = ["未選択","挨拶","日程調整","日程変更","キャンセル","送信ミス"]
    let greetMessages = ["未選択","初めまして！マッチングありがとうございます！","ありがとうございます！","承知しました！"]
    let scheduleMessages = ["未選択","日時を提案","返信ー了承","返信ー再提案"]
    let missMessages = ["未選択","すみません、間違えました。上記のメッセージは無視してください。"]
    let okayMes_1 = Array(1...31)
    let okayMes_2 = Array(0...24)
    let okayMes_3 = Array(0...3).map {($0 * 15)}
    var okayText_1 = ""
    var okayText_2 = ""
    var okayText_3 = ""
    var pickerText = ""
    let datePicker: UIDatePicker = UIDatePicker()
    
    
    let userDefaults = UserDefaults.standard
    var listener: ListenerRegistration!
    var jsqMessages: [JSQMessage] = []
    
    var roomId: String?
    var OpponentId: String?
    var listener2: ListenerRegistration!
    var opUserId:String?
    var Users:String?
    var topImage: UIImage = UIImage(named: "callButton_chat")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //設定
        senderId = userDefaults.string(forKey: "uid")
        senderDisplayName = userDefaults.string(forKey: "name")
        // 新しいメッセージを受信するたびに下にスクロールする
        automaticallyScrollsToMostRecentMessage = true
        // クリーンアップツールバーの設定
        inputToolbar!.contentView!.leftBarButtonItem = nil
        
        //test
        self.keyboardController.textView.inputView = picker
        
        //pickerの設定
        picker.delegate = self
        picker.dataSource = self
        
        datePicker.datePickerMode = UIDatePicker.Mode.date
    }
    
    func setData(_ data: ChatRoomData){
        //初期化
        jsqMessages = []
        
        //Id設定
        self.roomId = data.roomId
        if userDefaults.integer(forKey: "gender") == 1 {
            self.OpponentId = data.female
        } else if userDefaults.integer(forKey: "gender") == 2 {
            self.OpponentId = data.male
        }
        
        //メッセージ取得
        if listener == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.ChatPath).document(roomId!).collection(Const.MessagePath).order(by: "sendTime",descending: true).limit(to: 25)
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
        
        //性別毎に相手のuidを取得
        if UserDefaults.standard.integer(forKey: "gender") == 1 {
            opUserId = self.OpponentId
            Users = "Female_Users"
        }else if UserDefaults.standard.integer(forKey: "gender") == 2 {
            opUserId = self.OpponentId
            Users = "Male_Users"
        }
        
        if listener2 == nil{
        // listener未登録なら、登録してスナップショットを受信する
        
            let Ref = Firestore.firestore().collection(Users!).document(opUserId!)
            listener2 = Ref.addSnapshotListener() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
            }
            //画像を設定
            let imageRef = Storage.storage().reference().child(Const.ImagePath).child(querySnapshot?.get("photoId") as! String)
                imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print(error)
                    } else {
                        self.topImage = UIImage(data: data!)!
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //上のバーを表示、下のバーを消す
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        //送信を反映
        self.finishReceivingMessage(animated: true)
    }
    
     //アイテムごとに参照するメッセージデータを返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return jsqMessages[indexPath.row]
    }


         //アイテムごとのMessageBubble(背景)を返す
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if jsqMessages[indexPath.row].senderId == senderId {
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
            
        if jsqMessages[indexPath.row].senderId == senderId {
                cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.darkGray
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
        
        if text == "" {
            return
        }
        
        //ピッカービューを初期化
        selectMode = 0
        pickerMode = 0
        
        //キーボードを閉じる
        self.view.endEditing(true)
        
        //送信を反映
        self.finishReceivingMessage(animated: true)
        
        //firebaseに保存
        let Ref = Firestore.firestore().collection(Const.ChatPath).document(roomId!).collection(Const.MessagePath).document()
        let Dic = ["senderId": senderId,"displayName": senderDisplayName,"text": text,"sendTime": date] as [String:Any]
        Ref.setData(Dic)
        
        //textFieldをクリアする
        self.inputToolbar.contentView.textView.text = ""
        
        self.finishSendingMessage()
        
        testRecvMessage()
    }
    
    //テスト用「マグロならあるよ！」を返す
    func testRecvMessage() {
           
        let message = JSQMessage(senderId: "sushi", displayName: "B", text: "マグロならあるよ！")
        let Ref = Firestore.firestore().collection(Const.ChatPath).document(roomId!).collection(Const.MessagePath).document()
        let Dic = ["senderId": message?.senderId,"displayName": message?.senderDisplayName,"text": message?.text,"sendTime": Date()] as [String:Any]
        Ref.setData(Dic)
        self.finishReceivingMessage(animated: true)
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
    
    @IBAction func callButton(_ sender: Any) {
        let PrepareRoom = self.storyboard?.instantiateViewController(identifier: "PrepareRoom") as! PrepareRoom
        PrepareRoom.roomName = self.roomId
        self.navigationController?.pushViewController(PrepareRoom, animated: true)
    }
}





