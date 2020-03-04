//
//  PrepareRoom.swift
//  Puhelin
//
//  Created by 丸子司恩 on 2020/02/24.
//  Copyright © 2020 shion.maruko. All rights reserved.
//

import UIKit
import SkyWay

class PrepareRoom: UIViewController {
    
    // SkyWay Configuration Parameter
    let apikey = "7dc43da3-26d9-4c5b-bb15-b16ac1570364"
    let domain = "localhost"
    var roomName: String?
    
    fileprivate var peer: SKWPeer?
    fileprivate var mediaConnection: SKWMediaConnection?
    fileprivate var localStream: SKWMediaStream?
    
    @IBOutlet weak var localStreamView: SKWVideo!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        localStreamView.layer.borderWidth = 1
        localStreamView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //new peerIdと同じことをする＝peerOpenも発火
        let option: SKWPeerOption = SKWPeerOption.init();
        option.key = apikey
        option.domain = domain
        
        peer = SKWPeer(options: option)
        
        if let _peer = peer{
            self.setupStream(peer: _peer)
            self.setupPeerCallBacks(peer: _peer)
        }else{
            print("failed to create peer setup")
        }
    }
    
    
    
    @IBAction func joinButton(_ sender: Any) {
        let VideoCall = self.storyboard?.instantiateViewController(identifier: "VideoCall") as! VideoCall
        VideoCall.peer = peer
        VideoCall.localStream = localStream
        VideoCall.roomName = roomName
        self.navigationController?.pushViewController(VideoCall, animated: true)
    }
    
    
    
    //ローカルストリームの設定
    func setupStream(peer:SKWPeer){
        SKWNavigator.initialize(peer);
        let constraints:SKWMediaConstraints = SKWMediaConstraints()
        self.localStream = SKWNavigator.getUserMedia(constraints)
        self.localStream?.addVideoRenderer(self.localStreamView, track: 0)
    }
}

//初期設定peerIdの設定
extension PrepareRoom{
    
    func setupPeerCallBacks(peer:SKWPeer){
        
        //Open発火処理
        peer.on(.PEER_EVENT_OPEN, callback: {obj in
            if let peerId = obj as? String{
                DispatchQueue.main.async {
                }
                print("your peerId: \(peerId)")
            }
        })
        
        peer.on(.PEER_EVENT_ERROR, callback:{ (obj) -> Void in
            if let error = obj as? SKWPeerError{
                print("\(error)")
            }
        })
        
        
    }
}