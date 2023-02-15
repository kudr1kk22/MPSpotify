//
//  PlayerViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 9.02.23.
//

import Foundation
import AVKit
import MediaPlayer

protocol PlayerObserverDelegate: AnyObject {
  func updateUI()
}

protocol PlayerViewModelProtocol {
  var audioControl: CommandCenterAudioControlProtocol { get }
  var imageURL: URL? { get }
  var playerDelegate: PlayerObserverDelegate? { get set }

  func observePlayer()
  func removeObserver()

  func didTapPlayButton(_ playButton: UIButton,_ imageView: UIImageView)
  func didTapNextButton()
  func didTapBackwardButton()
}

final class PlayerViewModel: PlayerViewModelProtocol {

  //MARK: - Properties

  var imageURL: URL? {
    return URL(string: audioControl.track.first?.album?.images.first?.url ?? "")
  }

  
  weak var playerDelegate: PlayerObserverDelegate?
  var audioControl: CommandCenterAudioControlProtocol
  
  //MARK: - Initialization
  
  init(audioControl: CommandCenterAudioControl) {
    self.audioControl = audioControl
    audioControl.buttonControls = self
  }
  
  
  
  //MARK: - Observers
  
  func observePlayer() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.playerDidFinishPlaying(sender:)),
                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
  }
  
  @objc func playerDidFinishPlaying(sender: Notification) {
    print("Finished playing")
    if audioControl.position < audioControl.track.count - 1 {
      audioControl.position = audioControl.position + 1
    } else {
      audioControl.position = 0
    }
    playerDelegate?.updateUI()
    audioControl.play(at: audioControl.position)
    audioControl.updateNowPlaying(isPause: false)
    
  }
  
  func removeObserver() {
    NotificationCenter.default.removeObserver(self)
  }
}


  //MARK: - PlayerViewModelProtocol

  extension PlayerViewModel: ButtonControlsDelegate {

    //MARK: - Play Button Action

    func didTapPlayButton(_ playButton: UIButton,_ imageView: UIImageView) {
      if let playerQueue = audioControl.playerQueue {
        if playerQueue.timeControlStatus == .playing {
          audioControl.pause(playButton, imageView)
        } else {
          audioControl.play(playButton, imageView)
        }
      }
    }

    //MARK: - Next Track Button

    func didTapNextButton() {
      if  audioControl.position <  audioControl.track.count - 1 {
        audioControl.position =  audioControl.position + 1
      } else {
        audioControl.position = 0
      }
      playerDelegate?.updateUI()
      audioControl.play(at: audioControl.position)
      audioControl.updateNowPlaying(isPause: false)
    }

    //MARK: - Prev Track Button

    func didTapBackwardButton() {
      if  audioControl.position > 0 {
        audioControl.position =  audioControl.position - 1
      }
      playerDelegate?.updateUI()
      audioControl.play(at: audioControl.position)
      audioControl.updateNowPlaying(isPause: false)
    }

  }

