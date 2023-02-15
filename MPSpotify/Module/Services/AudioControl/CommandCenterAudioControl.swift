//
//  CommandCenterAudioControl.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 14.02.23.
//

import MediaPlayer
import UIKit

protocol ButtonControlsDelegate: AnyObject {
  func didTapNextButton()
  func didTapBackwardButton()
}

protocol CommandCenterAudioControlProtocol {
  var playerQueue: AVQueuePlayer? { get set }
  var position: Int { get set }
  var track: [AudioTrack] { get set } 
  
  func startPlaybacks(
    from viewController: UIViewController,
    track: [AudioTrack], position: Int)

  func play(at index: Int)
  func pause(_ playButton: UIButton)
  func play(_ playButton: UIButton)
  func playOnNewPosition(_ slider: UISlider,_ playButton: UIButton)

  func observePlayerCurrentTime(currentTimeLabel: UILabel, remainingTimeLabel: UILabel, currentTimeSlider: UISlider)

  func setupRemoteTransportControls(_ playButton: UIButton)
  func setupNowPlaying(title: String)

  func updateNowPlaying(isPause: Bool)
}

final class CommandCenterAudioControl: CommandCenterAudioControlProtocol {

  var playerQueue: AVQueuePlayer?
  var position: Int = 0
  var track: [AudioTrack]

  weak var buttonControls: ButtonControlsDelegate?

  var playerTracks: [AVPlayerItem] {
    track.compactMap({
      guard let url = URL(string: $0.previewURL ?? "") else {
        return nil
      }
      return AVPlayerItem(url: url)
    })
  }

  init(track: [AudioTrack]) {
    self.track = track
  }

  func startPlaybacks(
    from viewController: UIViewController,
    track: [AudioTrack], position: Int) {
    self.track = track
    self.position = position
    self.playerQueue = AVQueuePlayer(items: playerTracks)
    play(at: position)
  }

  //MARK: - Play

  func play(at index: Int) {
    playerQueue?.actionAtItemEnd = .none
    playerQueue?.replaceCurrentItem(with: playerTracks[index])
    playerQueue?.play()
  }

  func pause(_ playButton: UIButton) {
    playerQueue?.pause()
    updateNowPlaying(isPause: true)
    playButton.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
  }

  func play(_ playButton: UIButton) {
    playerQueue?.play()
    updateNowPlaying(isPause: false)
    playButton.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
  }

  func playOnNewPosition(_ slider: UISlider,_ playButton: UIButton) {
    let seconds = Double(slider.value)
    guard let timeScale = playerQueue?.currentTime().timescale else { return }

    let durationDoubleValue = Double(playerQueue?.currentItem?.duration.value ?? CMTimeValue(0.0))
    let durationDoubleTimeScale = Double(playerQueue?.currentItem?.duration.timescale ?? CMTimeScale(0.0))

    let seekTime = CMTimeMakeWithSeconds(seconds * durationDoubleValue / durationDoubleTimeScale, preferredTimescale: timeScale)
    playerQueue?.seek(to: seekTime)
    play(playButton)
    updateNowPlaying(isPause:false)
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

//MARK: - BackGroundControls

    func setupRemoteTransportControls(_ playButton: UIButton) {
    // Get the shared MPRemoteCommandCenter
    let commandCenter = MPRemoteCommandCenter.shared()



    // Add handler for Play Command
    commandCenter.playCommand.addTarget { [weak self] event in
      if self?.playerQueue?.timeControlStatus == .paused {
        self?.play(playButton)
             return .success
         }
         return .commandFailed
     }

    // Add handler for Pause Command
    commandCenter.pauseCommand.addTarget { [weak self] event in
      if self?.playerQueue?.timeControlStatus == .playing {
        self?.pause(playButton)
            return .success
        }
      return .deviceNotFound
    }

      commandCenter.nextTrackCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
        self?.buttonControls?.didTapNextButton()
        return .success
      }
      commandCenter.previousTrackCommand.addTarget { [weak self] event -> MPRemoteCommandHandlerStatus in
        self?.buttonControls?.didTapBackwardButton()
        return .success
      }

      commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
             let seconds = (event as? MPChangePlaybackPositionCommandEvent)?.positionTime ?? 0

             let time = CMTime(seconds: seconds, preferredTimescale: 1000)
              print(event)

        self?.playerQueue?.seek(to: time)
             return .success
         }
  }

  func setupNowPlaying(title: String) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title

        if let image = UIImage(named: "image") {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: image.size) { size in
                return image
            }
        }

      nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.playerQueue?.currentTime().seconds
      nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerTracks[position].asset.duration.seconds

      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.playerQueue?.rate


        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

  func updateNowPlaying(isPause: Bool) {
        // Define Now Playing Info
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo!

      nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = isPause ? 0 : 1
      nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = self.playerQueue?.currentTime().seconds
    nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerTracks[position].asset.duration.seconds


        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

}
