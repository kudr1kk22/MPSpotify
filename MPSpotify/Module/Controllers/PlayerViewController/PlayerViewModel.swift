//
//  PlayerViewModel.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 9.02.23.
//

import Foundation
import AVKit

protocol PlayerObserverDelegate: AnyObject {
  func updateUI()
}

protocol PlayerViewModelProtocol {
  var position: Int { get set }
  var track: [AudioTrack] { get }
  var imageURL: URL? { get }
  var playerDelegate: PlayerObserverDelegate? { get set }

  func observePlayerCurrentTime(currentTimeLabel: UILabel, remainingTimeLabel: UILabel, currentTimeSlider: UISlider)

  func startPlaybacks(
      from viewController: UIViewController,
      track: [AudioTrack], position: Int
  )
  
  func observePlayer()
  func removeObserver()

  func pause()
  func playOnNewPosition(_ slider: UISlider)
  
  func didTapPlayButton(_ playButton: UIButton)
  func didTapNextButton()
  func didTapBackwardButton()
}

final class PlayerViewModel {

  //MARK: - Properties

  var position: Int = 0

  var playerQueue: AVQueuePlayer?


  var imageURL: URL? {
    return URL(string: track.first?.album?.images.first?.url ?? "")
  }

  var track: [AudioTrack]

  var playerTracks: [AVPlayerItem] {
    track.compactMap({
     guard let url = URL(string: $0.previewURL ?? "") else {
       return nil
      }
      return AVPlayerItem(url: url)
    })
  }

  weak var playerDelegate: PlayerObserverDelegate?

  //MARK: - Initialization

  init(track: [AudioTrack]) {
    self.track = track
  }

  //MARK: - Play

  func play(at index: Int) {
    playerQueue?.actionAtItemEnd = .none
    playerQueue?.replaceCurrentItem(with: playerTracks[index])
    playerQueue?.play()
  }

  func pause() {
    playerQueue?.pause()
  }

  func playOnNewPosition(_ slider: UISlider) {
    let seconds = Double(slider.value)
    guard let timeScale = playerQueue?.currentTime().timescale else { return }

    let durationDoubleValue = Double(playerQueue?.currentItem?.duration.value ?? CMTimeValue(0.0))
    let durationDoubleTimeScale = Double(playerQueue?.currentItem?.duration.timescale ?? CMTimeScale(0.0))

      let seekTime = CMTimeMakeWithSeconds(seconds * durationDoubleValue / durationDoubleTimeScale, preferredTimescale: timeScale)
      playerQueue?.seek(to: seekTime)


    playerQueue?.play()
  }

  //MARK: - Observers

  func observePlayer() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.playerDidFinishPlaying(sender:)),
                                           name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)

  }

  @objc func playerDidFinishPlaying(sender: Notification) {
      print("Finished playing")
    if position < track.count - 1 {
      position = position + 1
    } else {
      position = 0
    }
    playerDelegate?.updateUI()
    play(at: position)

  }

   func removeObserver() {
      NotificationCenter.default.removeObserver(self)
  }

  //MARK: - Time Setup

  func observePlayerCurrentTime(currentTimeLabel: UILabel, remainingTimeLabel: UILabel, currentTimeSlider: UISlider) {
    let interval = CMTimeMake(value: 1, timescale: 5)
    playerQueue?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] _ in
      if let currentItem = self?.playerQueue?.currentItem {
        let duration = currentItem.duration
        let currentTime = currentItem.currentTime()
        currentTimeLabel.text = currentTime.toDisplayString()
        let currentDurationText = (duration - currentTime).toDisplayString()
        remainingTimeLabel.text = "-\(currentDurationText)"
        self?.updateCurrentTimeSlider(currentTimeSlider: currentTimeSlider)
      }
    }
  }

  func updateCurrentTimeSlider(currentTimeSlider: UISlider) {
    let currentTimeSeconds = CMTimeGetSeconds(self.playerQueue?.currentTime() ?? CMTime())
    let durationSeconds = CMTimeGetSeconds(self.playerQueue?.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
      let percentage = currentTimeSeconds / durationSeconds
      currentTimeSlider.value = Float(percentage)
  }
}

//MARK: - PlayerViewModelProtocol

extension PlayerViewModel: PlayerViewModelProtocol {

  func startPlaybacks(
    from viewController: UIViewController,
    track: [AudioTrack], position: Int
  ) {
    self.track = track
    self.position = position
    self.playerQueue = AVQueuePlayer(items: playerTracks)
    play(at: position)
  }

  //MARK: - Play Button Action

  func didTapPlayButton(_ playButton: UIButton) {
    if let playerQueue = playerQueue {
      if playerQueue.timeControlStatus == .playing {
        playerQueue.pause()
        playButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
      } else {
        playerQueue.play()
        playButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
      }
    }
  }

  //MARK: - Next Track Button

  func didTapNextButton() {
    if position < track.count - 1 {
      position = position + 1
    } else {
      position = 0
    }
    play(at: position)
  }

  //MARK: - Prev Track Button

  func didTapBackwardButton() {
    if position > 0 {
      position = position - 1
    }
    play(at: position)
    }
  }










