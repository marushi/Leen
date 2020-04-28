//
//  BlackView.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/04/28.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class BlackView: UIViewController {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var modoruButton: UIButton!
    
    var roomId:String?
    var roomMode: Int?
    var delegate:dismissDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deleteButton.layer.cornerRadius = 22.5
        modoruButton.layer.cornerRadius = 22.5
        //delegateの設定
        let nav = self.presentingViewController as? UINavigationController
        delegate = nav?.viewControllers[1] as? ChatRoom
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //delegateの設定
        if self.roomMode == 0 {
            let nav = self.presentingViewController as? UINavigationController
            delegate = nav?.viewControllers[1] as? ChatRoom
        }else if self.roomMode == 1 {
            let nav = self.presentingViewController as? UINavigationController
            delegate = nav?.viewControllers[1] as? ChatRoom2
        }
    }
    
           
    
    @IBAction func roomDelete(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        alertView.addButton("削除する") {
            //データベースから削除
            if self.roomMode == 0 {
                let ref = Firestore.firestore()
                let Ref = ref.collection(Const.ChatPath).document(self.roomId!)
                let messeageRef = ref.collection(Const.ChatPath).document(self.roomId!).collection(Const.MessagePath)
                Ref.delete(completion: nil)
                messeageRef.document().delete()
                self.delegate?.selfdismissFunction(true)
                self.dismiss(animated: true, completion: nil)
            }else if self.roomMode == 1 {
                let ref = Firestore.firestore()
                let Ref = ref.collection(Const.MatchingPath).document(self.roomId!)
                let messeageRef = ref.collection(Const.MatchingPath).document(self.roomId!).collection(Const.MessagePath)
                Ref.delete(completion: nil)
                messeageRef.document().delete()
                self.delegate?.selfdismissFunction(true)
                self.dismiss(animated: true, completion: nil)
            }
            
            }
        alertView.addButton("キャンセル",backgroundColor: .lightGray,textColor: .black) {
            return
        }
        alertView.showWarning("本当に削除しますか？", subTitle: "この操作は取り消せません。")
    }
    
    @IBAction func modoru(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

protocol dismissDelegate {
    func selfdismissFunction(_ type:Bool)
}
