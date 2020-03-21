//
//  VideoCall.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/24.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SkyWay

class VideoCall: UIViewController{
    
    // SkyWay Configuration Parameter
    //定数
    let apiKey = "7dc43da3-26d9-4c5b-bb15-b16ac1570364"
    let domain = "localhost"
    let lock: NSLock = NSLock.init()
    
    //変数
    var arrayMediaStreams: NSMutableArray = []
    var arrayVideoViews: NSMutableDictionary = [:]
    var peer: SKWPeer?
    var localStream: SKWMediaStream?
    var sfuRoom: SKWSFURoom?
    var stream: SKWMediaStream?
    var video: SKWVideo?
    var roomName: String?
    var mode: Int?
    var delegate:VideoModal?
    var timerNum: Int!
    var timer: Timer?

    //部品
    @IBOutlet var remoteView: SKWVideo!
    @IBOutlet weak var localView: SKWVideo!
    @IBOutlet weak var lemoveButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lemoveButton.layer.cornerRadius = lemoveButton.frame.size.height / 2
        let nav = self.navigationController
        delegate = nav!.viewControllers[nav!.viewControllers.count - 2] as? PrepareRoom
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerNum = 180
        timerLabel.text = "\(timerNum!)"
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = true
        self.setupStream(peer: peer!)
        self.joinRoom()
    }

    override func viewDidDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    //デイニシャライザ
    deinit {
        localStream = nil
        sfuRoom = nil
        peer = nil
    }
    
    //ローカルストリームの設定
    func setupStream(peer:SKWPeer){
        SKWNavigator.initialize(peer);
        let constraints:SKWMediaConstraints = SKWMediaConstraints()
        self.localStream = SKWNavigator.getUserMedia(constraints)
        self.localStream?.addVideoRenderer(self.localView, track: 0)
    }
    
    //ルームに入室
    func joinRoom() {
            
        // join SFU room
        let option = SKWRoomOption.init()
        option.mode = .ROOM_MODE_SFU
        option.stream = self.localStream
        sfuRoom = peer?.joinRoom(withName: roomName!, options: option) as? SKWSFURoom
            
            
        // room event handling
        //　入った時に呼ばれるOPEN
        sfuRoom?.on(.ROOM_EVENT_OPEN, callback: {obj in
            self.mode = 0
            
        })
        
        //閉じた時に呼ばれるCLOSE
        sfuRoom?.on(.ROOM_EVENT_CLOSE, callback: {obj in
            self.lock.lock()
            self.arrayMediaStreams.enumerateObjects({obj, _, _ in
                let mediaStream: SKWMediaStream = obj as! SKWMediaStream
                let peerId = mediaStream.peerId!
                // remove other videos
                if let video: SKWVideo = self.arrayVideoViews.object(forKey: peerId) as? SKWVideo {
                    mediaStream.removeVideoRenderer(video, track: 0)
                    video.removeFromSuperview()
                    self.arrayVideoViews.removeObject(forKey: peerId)
                }
            })
            self.arrayMediaStreams.removeAllObjects()
            self.lock.unlock()
            // leave SFU room
            self.sfuRoom?.offAll()
            self.sfuRoom = nil
        })
        
        //音声と映像の処理
        sfuRoom?.on(.ROOM_EVENT_STREAM, callback: {obj in
            self.mode = 1
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.TimerStart), userInfo: nil, repeats: true)
            let mediaStream: SKWMediaStream = obj as! SKWMediaStream
            self.lock.lock()
            // add videos
            self.arrayMediaStreams.add(mediaStream)
            mediaStream.addVideoRenderer(self.remoteView, track: 0)
            self.lock.unlock()
        })

            
        //音声と映像を削除する
        sfuRoom?.on(.ROOM_EVENT_REMOVE_STREAM, callback: {obj in
            let mediaStream: SKWMediaStream = obj as! SKWMediaStream
            let peerId = mediaStream.peerId!
            self.lock.lock()
            // remove video
            if let video: SKWVideo = self.arrayVideoViews.object(forKey: peerId) as? SKWVideo {
                mediaStream.removeVideoRenderer(video, track: 0)
                video.removeFromSuperview()
                self.arrayVideoViews.removeObject(forKey: peerId)
            }
            self.arrayMediaStreams.remove(mediaStream)
            self.lock.unlock()
        })

    
        //Peerの除去
        sfuRoom?.on(.ROOM_EVENT_PEER_LEAVE, callback: {obj in
            let peerId = obj as! String
            var checkStream: SKWMediaStream? = nil
            self.lock.lock()
            self.arrayMediaStreams.enumerateObjects({obj, _, _ in
                let mediaStream: SKWMediaStream = obj as! SKWMediaStream
                if peerId == mediaStream.peerId {
                    checkStream = mediaStream
                }
            })
            if let checkStream = checkStream {
                // remove video
                if let video: SKWVideo = self.arrayVideoViews.object(forKey: peerId) as? SKWVideo {
                    checkStream.removeVideoRenderer(video, track: 0)
                    video.removeFromSuperview()
                    self.arrayVideoViews.removeObject(forKey: peerId)
                }
                self.arrayMediaStreams.remove(checkStream)
            }
            self.lock.unlock()
        })
    }

    @IBAction func leaveRoom(_ sender: Any) {
        guard let sfuRoom = self.sfuRoom else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        sfuRoom.close()
        if self.mode == 0{
            self.navigationController?.popViewController(animated: true)
        }else{
            self.delegate?.videomodal(modalmode: 1)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    //
    //1秒毎にカウントする
    //
    @objc func TimerStart(timer: Timer){
        timerNum -= 1
        if timerNum < 0 {
            self.timer!.invalidate()
            self.leaveRoom(lemoveButton as Any)
        }else{
            self.timerLabel.text = "\(timerNum!)"
        }
    }
}
    
//通話をしたかどうか
protocol VideoModal {
    func videomodal(modalmode: Int)
}

