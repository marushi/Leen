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
import SCLAlertView
import JSQMessagesViewController

class ChatRoom: JSQMessagesViewController {
    
    @objc dynamic var noneReadedMes:Int = 0
    
    //定数
    let picker = UIPickerView()
    let datePicker: UIDatePicker = UIDatePicker()
    let textField = UITextField()
    let selectMessages = ["未選択","挨拶","日程調整","通話前","通話後","その他"]
    let greetMessages = ["未選択","初めまして！マッチングありがとうございます！","こちらこそありがとうございます！","日程調整しましょう！","日程調整しませんか？","いいですね！","承知しました！"]
    let scheduleMessages = ["未選択","日時を提案","返信ー了承","すみません、いただいた日時では合わせることが難しそうです。","大丈夫です！","そうしましょう！","楽しみにしてます！"]
    let beforCall = ["未選択","通話ルームに入ります！","すみません遅れます！","すみません、時間に間に合いません。","すみません、急用が入ってしまいました。","日程変更できないでしょうか？","すみません、予定が合わなくなってしまったため今回はキャンセルさせてください。","○分後でも大丈夫ですか？"]
    let afterCall = ["未選択","もう一度通話しませんか？","今からもう一度通話しませんか？","通話が切れてしまいました。","ごめんなさい時間が取れそうにないです。","別の日にしませんか？","また時間ができたらご連絡します。"]
    let otherMessages = ["未選択","すみません送信ミスです！","ありがとうございます！","大丈夫です！","了解です！","わかりました。","申し訳ないです。","すみません。","いいですね！","ありがとうございました。"]
    let okayMes_1 = Array(1...31)
    let okayMes_2 = Array(0...24)
    let okayMes_3 = Array(0...3).map {($0 * 15)}
    let userDefaults = UserDefaults.standard
    let button = UIButton(type: .system)
     
    //変数
    var chatroommode = 0
    var pickerMode = 0
    var selectMode = 0
    var scheduleadjustMode = 0
    var okayText_1 = ""
    var okayText_2 = ""
    var okayText_3 = ""
    var pickerText = ""
    var listener: ListenerRegistration!
    var listener2: ListenerRegistration!
    var listener3: ListenerRegistration!
    var jsqMessages: [JSQMessage] = []
    var roomId: String?
    var OpponentId: String?
    var Users:String?
    var topImage: UIImage = UIImage()
    var opName:String?
    var profileData:MyProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定
        senderId = userDefaults.string(forKey: "uid")
        senderDisplayName = userDefaults.string(forKey: "name")
        // 新しいメッセージを受信するたびに下にスクロールする
        automaticallyScrollsToMostRecentMessage = true
        // クリーンアップツールバーの設定
        inputToolbar!.contentView!.leftBarButtonItem = nil
        inputToolbar.contentView.rightBarButtonItem.setTitle("送信", for: .normal)
        inputToolbar.contentView.textView.placeHolder = "メッセージを選択"
        //pickerの設定
        picker.delegate = self
        picker.dataSource = self
        datePicker.datePickerMode = UIDatePicker.Mode.date
        //オブザーバー
        self.addObserver(self, forKeyPath: "noneReadedMes", options: [.old,.new], context: nil)
        //待合室へのボタン
        // UIButtonのインスタンスを作成する
        button.addTarget(self, action: #selector(callButton(_:)), for: .touchUpInside)
        let image = UIImage(systemName: "phone.fill")
        button.setImage(image, for: .normal)
        button.tintColor = ColorData.salmon
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.backgroundColor = .white
        button.layer.borderColor = ColorData.salmon.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.shadowOpacity = 0.5
        button.layer.shadowRadius = 1
        button.tag = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //下のバーを消す
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        if self.view.frame.size.width > 400 {
            button.frame = CGRect(x: (self.navigationController?.navigationBar.frame.size.width)! * 0.7 , y: 50, width: 60, height: 60)
        }else{
            button.frame = CGRect(x: (self.navigationController?.navigationBar.frame.size.width)! * 0.7 , y: 30, width: 60, height: 60)
        }
        self.navigationController?.view.addSubview(button)
        
        //送信を反映
        self.finishReceivingMessage(animated: true)
        if chatroommode == 0{
            self.keyboardController.textView.inputView = picker
            self.keyboardController.textView.isEditable = false
        }else{
            self.button.isHidden = true
        }
        //既読処理
        readedFunction()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.listener3.remove()
        let buttonView = self.navigationController?.view.viewWithTag(1)
        buttonView?.removeFromSuperview()
        
        //部屋から退出
        let ref = Firestore.firestore().collection(Const.ChatPath).document(roomId!)
        let num = userDefaults.integer(forKey: "gender")
        ref.setData(["roomEnter" + String(num):false],merge: true)
    }
    
    @IBAction func button(_ sender: Any) {
        let BlackView = self.storyboard?.instantiateViewController(identifier: "BlackView") as! BlackView
        BlackView.roomId = self.roomId!
        BlackView.roomMode = 0
        present(BlackView,animated: true,completion: nil)
    }
    
    //既読処理
    func readedFunction(){
        //部屋に入室
        let ref = Firestore.firestore().collection(Const.ChatPath).document(roomId!)
        let num = userDefaults.integer(forKey: "gender")
        ref.setData(["roomEnter" + String(num):true],merge: true)
        if listener3 == nil{
        // listener未登録なら、登録してスナップショットを受信する
            let Ref = Firestore.firestore().collection(Const.ChatPath).document(roomId!).collection(Const.MessagePath).whereField("readed", isEqualTo: false).whereField("senderId", isEqualTo: OpponentId!)
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
                        let ref = Firestore.firestore().collection(Const.ChatPath).document(self.roomId!).collection(Const.MessagePath).document(nonReadMesData[i].id!)
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
        
        // listener未登録なら、登録してスナップショットを受信する
        
            let Ref = Firestore.firestore().collection(Users!).document(OpponentId!)
            Ref.getDocument() { (querySnapshot, error) in
            if let error = error {
                print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                return
                }
                self.profileData = MyProfileData(document: querySnapshot!)
                //名前
                if let name:String = querySnapshot?.get("name") as? String {
                    self.navigationItem.title = name
                }
                //画像を設定
                let imageRef = Storage.storage().reference().child(Const.ImagePath).child(querySnapshot?.get("photoId") as! String)
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
        //ピッカービューを初期化
        selectMode = 0
        pickerMode = 0
        //キーボードを閉じる
        self.view.endEditing(true)
        //送信を反映
        self.finishReceivingMessage(animated: true)
        //------------firebaseに保存------------
        //メッセージ
        let Ref = Firestore.firestore().collection(Const.ChatPath).document(roomId!).collection(Const.MessagePath).document()
        let Dic = ["senderId": senderId as Any
            ,"displayName": senderDisplayName as Any
            ,"text": text as Any
            ,"sendTime": date as Any
            ,"readed": false
            ,"token": userDefaults.string(forKey: "token") as Any] as [String:Any]
        Ref.setData(Dic)
        //最新メッセージとして記録
            let ref = Firestore.firestore().collection(Const.ChatPath).document(roomId!)
            ref.setData(["LastRefreshTime":date as Any,"LastRefreshMessage":text as Any],merge: true)
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
        Profile.profileData = profileData
        Profile.goodButton.isHidden = true
        present(Profile,animated: true,completion: nil)
    }
    
    
    @objc func callButton(_ sender: Any) {
        let PrepareRoom = self.storyboard?.instantiateViewController(identifier: "PrepareRoom") as! PrepareRoom
        PrepareRoom.roomName = self.roomId
        PrepareRoom.opid = OpponentId
        PrepareRoom.topImage = topImage
        self.navigationController?.pushViewController(PrepareRoom, animated: true)
    }
    
    
}

//日付の受け渡し
extension ChatRoom:ModalViewControllerDelegate{
    func modalDidFinished(modalText: [String]) {
        var settext:String = ""
        for text in modalText{
            settext = settext + text + "、"
        }
        self.keyboardController.textView.text = settext + "以上の日程はどうでしょうか？"
        self.keyboardController.textView.becomeFirstResponder()
        self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
    }
}

//ピッカービューをtoolbarに設定
extension ChatRoom{
    override var inputAccessoryView: UIView? {
        if chatroommode == 0{
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
        }else{
            return UIToolbar()
        }
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
    
    //タイトルの数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerMode {
        case 0:
            return selectMessages.count
        case 1:
            return greetMessages.count
        case 2:
            return scheduleMessages.count
        case 3:
            return beforCall.count
        case 4:
            return afterCall.count
        case 5:
            return otherMessages.count
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
    
    //ピッカーのタイトル
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerMode {
        case 0:
            return selectMessages[row]
        case 1:
            return greetMessages[row]
        case 2:
            return scheduleMessages[row]
        case 3:
            return beforCall[row]
        case 4:
            return afterCall[row]
        case 5:
            return otherMessages[row]
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
    
    //選択したときの処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerMode == 0 {
            switch row {
            case 0:
                return
            case 1:
                selectMode = 1  //挨拶
            case 2:
                selectMode = 2  //日程調整
            case 3:
                selectMode = 3  //通話前
            case 4:
                selectMode = 4  //通話後
            case 5:
                selectMode = 5  //その他
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
            case 3:
                if row == 0 {
                pickerText = ""
                }else{
                pickerText = beforCall[row]
                }
            case 4:
                if row == 0 {
                pickerText = ""
                }else{
                pickerText = afterCall[row]
                }
            case 5:
                if row == 0 {
                pickerText = ""
                }else{
                pickerText = otherMessages[row]
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
                let schedule = self.storyboard?.instantiateViewController(identifier: "schedule")
                schedule?.modalTransitionStyle = .crossDissolve
                self.present(schedule!,animated: true,completion: nil)
            case 2:
                pickerMode = 22
                self.keyboardController.textView.text = "ご提案ありがとうございます！では、"
                picker.reloadAllComponents()
            default:
                self.keyboardController.textView.text = scheduleMessages[scheduleadjustMode]
                self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
            }
        }else if pickerMode == 22 {
            self.keyboardController.textView.text = "ご提案ありがとうございます！では、 " + okayText_1 + okayText_2 + okayText_3 + "  でも大丈夫ですか？"
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }
        else{
            self.keyboardController.textView.text = pickerText
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }
    }
}


extension ChatRoom:dismissDelegate{
    func selfdismissFunction(_ type: Bool) {
        if type == true{
            self.navigationController?.popViewController(animated: true)
        }
    }
}
