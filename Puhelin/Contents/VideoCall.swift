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
        let apiKey = "7dc43da3-26d9-4c5b-bb15-b16ac1570364"
        let domain = "localhost"

        var roomName: String?
    
        let lock: NSLock = NSLock.init()
        var arrayMediaStreams: NSMutableArray = []
        var arrayVideoViews: NSMutableDictionary = [:]

        var peer: SKWPeer?
        var localStream: SKWMediaStream?
        var sfuRoom: SKWSFURoom?

    @IBOutlet var remoteView: SKWVideo!
    @IBOutlet weak var localView: SKWVideo!
    
        override func viewDidLoad() {
            super.viewDidLoad()
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            UIApplication.shared.isIdleTimerDisabled = true
            self.setupStream(peer: peer!)
            self.joinRoom()
        }

        override func viewDidDisappear(_ animated: Bool) {
            UIApplication.shared.isIdleTimerDisabled = false
            super.viewDidDisappear(animated)
        }

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
    
    
        func joinRoom() {
            
            
            // join SFU room
            let option = SKWRoomOption.init()
            option.mode = .ROOM_MODE_SFU
            option.stream = self.localStream
            sfuRoom = peer?.joinRoom(withName: roomName!, options: option) as? SKWSFURoom

            
            
            // room event handling
            sfuRoom?.on(.ROOM_EVENT_OPEN, callback: {obj in
            })

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
            
            

            sfuRoom?.on(.ROOM_EVENT_STREAM, callback: {obj in
                let mediaStream: SKWMediaStream = obj as! SKWMediaStream
                self.lock.lock()
                // add videos
                self.arrayMediaStreams.add(mediaStream)
                self.lock.unlock()
            })

            
            
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
                return
            }
            sfuRoom.close()
            self.dismiss(animated: true, completion: nil)
        }
    
}
    

