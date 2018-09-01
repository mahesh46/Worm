//
//  PlayerView.swift
//  Worm
//
//  Created by Administrator on 27/03/2018.
//  Copyright © 2018 mahesh lad. All rights reserved.
//

import UIKit
import AVKit;
import AVFoundation;
class PlayerView: UIView {
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self;
    }
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer;
    }
    var player: AVPlayer? {
        get {
            return playerLayer.player;
        }
        set {
            playerLayer.player = newValue;
        }
    }
}
