//
//  Player.swift
//  PlayKit
//
//  Created by Noam Tamim on 28/08/2016.
//  Copyright © 2016 Kaltura. All rights reserved.
//

import UIKit
import AVFoundation

public enum PlayerEventType : Int {
    case ad_break_ready
    case ad_break_ended
    case ad_break_started
    case all_ads_completed
    case clicked
    case complete
    case cuepoints_changed
    case first_quartile
    case loaded
    case log
    case midpoint
    case pause
    case resume
    case skipped
    case started
    case stream_loaded
    case tapped
    case third_quartile
    case playhead_state_changed
    case item_did_play_to_end_time
}

public protocol PlayerDataSource: class {
    func playerVideoView(_ player: Player) -> UIView
    
    func playerCanPlayAd(_ player: Player) -> Bool
    func playerCompanionView(_ player: Player) -> UIView?
    func playerAdWebOpenerPresentingController(_ player: Player) -> UIViewController?
}

public protocol PlayerDelegate: class {
    func player(_ player: Player, failedWith error: String)
    func player(_ player: Player, didReceive event: PlayerEventType)
    
    func player(_ player: Player, adDidProgressToTime mediaTime: TimeInterval, totalTime: TimeInterval)
    func playerAdDidRequestContentResume(_ player: Player)
    func playerAdDidRequestContentPause(_ player: Player)
    
    func player(_ player: Player, adWebOpenerWillOpenExternalBrowser webOpener: NSObject!)
    func player(_ player: Player, adWebOpenerWillOpenInAppBrowser webOpener: NSObject!)
    func player(_ player: Player, adWebOpenerDidOpenInAppBrowser webOpener: NSObject!)
    func player(_ player: Player, adWebOpenerWillCloseInAppBrowser webOpener: NSObject!)
    func player(_ player: Player, adWebOpenerDidCloseInAppBrowser webOpener: NSObject!)
}

public protocol Player {
    
    var dataSource: PlayerDataSource? { get set }
    var delegate: PlayerDelegate? { get set }
    
    /**
     Get the player's View component.
     */
    var view: UIView? { get }
    
    /**
     Get/set the current player position.
     */
    var currentTime: TimeInterval? { get set }
    
    var layer: CALayer! { get }
    
    /**
     Should playback start when ready?
     If set to true after entry is loaded, this will start playback.
     If set to false while entry is playing, this will pause playback.
     */
    var autoPlay: Bool? { get set }
    
    /**
     Prepare for playing an entry. If `config.autoPlay` is true, the entry will automatically
     play when it's ready.
     */
    func prepare(_ config: PlayerConfig)
    
    /**
     Convenience method for setting shouldPlayWhenReady to true.
     */
    func play()
    
    /**
     Convenience method for setting shouldPlayWhenReady to false.
     */
    func pause()
    
    func resume()
    
    func seek(to time: CMTime)
    
    /**
     Prepare for playing the next entry. If `config.shouldAutoPlay` is true, the entry will automatically
     play when it's ready and the current entry is ended.
     
    */
    func prepareNext(_ config: PlayerConfig) -> Bool

    /**
     Load the entry that was prepared with prepareNext(), without waiting for the current entry to end.
     */
    func loadNext() -> Bool
    
    /**
     Release player resources.
    */
    func destroy()
    
    func addBoundaryTimeObserver(origin: Origin, offset: TimeInterval, wait: Bool, observer: TimeObserver)
}

public protocol TimeObserver {
    func timeReached(player: Player, origin: Origin, offset: TimeInterval)
}

public enum Origin {
    case start
    case end
}

protocol DecoratedPlayerProvider {
    func getDecoratedPlayer() -> PlayerDecoratorBase?
}
