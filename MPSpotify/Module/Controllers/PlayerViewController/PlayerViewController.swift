//
//  PlayerViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 9.02.23.
//

import UIKit
import AVKit

final class PlayerViewController: UIViewController {

  //MARK: - IBOutlets

  @IBOutlet private weak var currentTimeSlider: UISlider!
  @IBOutlet private weak var currentTimeLabel: UILabel!
  @IBOutlet private weak var remainingTimeLabel: UILabel!
  @IBOutlet private weak var songNameLabel: UILabel!
  @IBOutlet private weak var artistNameLabel: UILabel!
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var playPauseButton: UIButton!

  //MARK: - IBActions

  @IBAction private func playPauseButtonDidTap(_ sender: UIButton) {
    viewModel.didTapPlayButton(sender)
  }

  @IBAction private func backwardButtonDidTap() {
    viewModel.didTapBackwardButton()
    timeObserve()
  }

  @IBAction private func forwardButtonDidTap() {
    viewModel.didTapNextButton()
    timeObserve()
  }

  @IBAction private func didBeginDraggingSlider(_ sender: UISlider) {
    viewModel.audioControl.pause(playPauseButton)

  }

  @IBAction private func didEndDraggingSlider(_ sender: UISlider) {
    viewModel.audioControl.playOnNewPosition(sender, playPauseButton)
  }


  //MARK: - Properties

  private var viewModel: PlayerViewModelProtocol

  //MARK: - Initialization

  init(viewModel: PlayerViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  deinit {
    viewModel.removeObserver()
  }

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setGradientLayer()
    viewModel.playerDelegate = self
    timeObserve()
    setupLabels()
    viewModel.observePlayer()
    viewModel.audioControl.setupRemoteTransportControls(playPauseButton)
    setBackgroundControls()
  }




  //MARK: - Observers

  private func timeObserve() {
    viewModel.audioControl.observePlayerCurrentTime(currentTimeLabel: currentTimeLabel, remainingTimeLabel: remainingTimeLabel, currentTimeSlider: currentTimeSlider)

  }

  //MARK: - Setup Labels from ViewModel

  private func setupLabels() {
    songNameLabel.text = viewModel.audioControl.track[viewModel.audioControl.position].name
    artistNameLabel.text = viewModel.audioControl.track[viewModel.audioControl.position].artists.first?.name
    if let imageURL = URL(string: viewModel.audioControl.track[viewModel.audioControl.position].album?.images.first?.url ?? "") {
      imageView.sd_setImage(with: imageURL)
    }
  }

  private func setBackgroundControls() {
    let trackName = "\(viewModel.audioControl.track[viewModel.audioControl.position].artists.first?.name ?? "") - \(viewModel.audioControl.track[viewModel.audioControl.position].name)"
    viewModel.audioControl.setupNowPlaying(title: trackName)
  }

  //MARK: - Gradient Layer
  func setGradientLayer() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = self.view.bounds
    gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    self.view.layer.insertSublayer(gradientLayer, at: 0)
  }

}
extension PlayerViewController: PlayerObserverDelegate {
  func updateUI() {
    setupLabels()
    setBackgroundControls()
  }
}


