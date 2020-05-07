//
//  VideoCall.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/24.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SkyWay
import AVFoundation
import SCLAlertView

class VideoCall: UIViewController{
    
    // SkyWay Configuration Parameter
    //定数
    let apiKey = "7dc43da3-26d9-4c5b-bb15-b16ac1570364"
    let domain = "localhost"
    let lock: NSLock = NSLock.init()
    let userDefaults = UserDefaults.standard
    let session: AVAudioSession = AVAudioSession.sharedInstance()
    
    //変数
    var arrayMediaStreams: NSMutableArray = []
    var arrayVideoViews: NSMutableDictionary = [:]
    var peer: SKWPeer?
    var localStream: SKWMediaStream?
    var sfuRoom: SKWMeshRoom?
    var stream: SKWMediaStream?
    var video: SKWVideo?
    var roomName: String?
    var mode: Int?
    var delegate:VideoModal?
    var timerNum: Double!
    var timer: Timer?
    var possibleTime:Double!

    //部品
    @IBOutlet var remoteView: SKWVideo!
    @IBOutlet weak var localView: SKWVideo!
    @IBOutlet weak var lemoveButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressTime: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localView.layer.cornerRadius = 10
        lemoveButton.layer.cornerRadius = 10
        progressTime.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        
        let nav = self.navigationController
        delegate = nav!.viewControllers[nav!.viewControllers.count - 2] as? PrepareRoom
        
    }
    
    func addAudioSessionObservers() {
        
        AVAudioSession.sharedInstance()
        
        let center = NotificationCenter.default
        //割り込み（他アプリの通話とか）
        center.addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        //経路変化（イヤホンとか）
        center.addObserver(self, selector: #selector(audioSessionRouteChanged(_:)), name: AVAudioSession.routeChangeNotification, object: nil)
        
    }
    
    //割り込み（他アプリの通話とか
    @objc func handleInterruption(_ notification: Notification) {
        
        
    }
    
    //経路変化（イヤホンとか）
    @objc func audioSessionRouteChanged(_ notification: Notification) {
        guard let desc = notification.userInfo?[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription
                else { return }
            let outputs = desc.outputs
            for component in outputs {
                if component.portType == AVAudioSession.Port.headphones ||
                    component.portType == AVAudioSession.Port.bluetoothA2DP ||
                    component.portType == AVAudioSession.Port.bluetoothLE ||
                    component.portType == AVAudioSession.Port.bluetoothHFP {
                    // イヤホン(Bluetooth含む)が抜かれた時の処理
                    //スピーカーにする
                        do {
                            try self.session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                        } catch let error as NSError {
                            //エラー処理
                            print(error)
                        }
                    
                    return
                }
            }
        // イヤホン(Bluetooth含む)が差された時の処理
        }
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //時間制限ごとの処理
        let num = userDefaults.integer(forKey: UserDefaultsData.callLimit)
        if num == 0 {
            possibleTime = 15 * 60
        }
        if num == 1 {
            possibleTime = 30 * 60
        }
        if num == 2 {
            possibleTime = 45 * 60
        }
        if num == 3 {
            possibleTime = 60 * 60
        }
        timerNum = Double(possibleTime)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.minute,.hour,.second]
        let outputString = formatter.string(from: timerNum)
        timerLabel.text = outputString
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.isIdleTimerDisabled = true
        self.setupStream(peer: peer!)
        self.addAudioSessionObservers()
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
        option.mode = .ROOM_MODE_MESH
        option.stream = self.localStream
        sfuRoom = peer?.joinRoom(withName: roomName!, options: option) as? SKWMeshRoom
            
            
        // room event handling
        //　入った時に呼ばれるOPEN
        sfuRoom?.on(.ROOM_EVENT_OPEN, callback: {obj in
            self.mode = 0
            //スピーカーにする
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                do {
                    try self.session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                } catch let error as NSError {
                    //エラー処理
                    print(error)
                }
            }
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
        if self.mode == 0{
            sfuRoom.close()
            self.peer?.destroy()
            self.navigationController?.popViewController(animated: true)
        }else{
            //アラート
            let appearance = SCLAlertView.SCLAppearance(
                    showCloseButton: false
                )
                let alertView = SCLAlertView(appearance: appearance)
                alertView.addButton("退出する") {
                    //探す画面に戻る
                    sfuRoom.close()
                    self.peer?.destroy()
                    self.delegate?.videomodal(modalmode: 1)
                    self.navigationController?.popViewController(animated: true)
                }
                alertView.addButton("戻る",backgroundColor: .lightGray,textColor: .black) {
                    return
                }
                alertView.showWarning("ビデオチャットから退出します。", subTitle: "まだ通話時間は残っていますがよろしいですか？")
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
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .positional
            formatter.allowedUnits = [.minute,.hour,.second]
            let outputString = formatter.string(from: timerNum)
            self.timerLabel.text = outputString
            let progressNum = 1 / possibleTime!
            self.progressTime.setProgress(progressTime.progress + Float(progressNum), animated: true)
        }
    }
}
    
//通話をしたかどうか
protocol VideoModal {
    func videomodal(modalmode: Int)
}

extension Notification.Name {
    static let AVAudioSessionRouteChange = Notification.Name("AVAudioSessionRouteChange")
}
