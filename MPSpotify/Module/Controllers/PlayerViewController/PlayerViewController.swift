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

  //MARK: - IBActions

  @IBAction private func playPauseButtonDidTap(_ sender: UIButton) {
    viewModel.didTapPlayButton(sender)
  }

  @IBAction private func backwardButtonDidTap() {
    viewModel.didTapBackwardButton()
    setupLabels()
    timeObserve()
  }

  @IBAction private func forwardButtonDidTap() {
    viewModel.didTapNextButton()
    setupLabels()
    timeObserve()
  }

  @IBAction private func didBeginDraggingSlider(_ sender: UISlider) {
    viewModel.pause()

  }

  @IBAction private func didEndDraggingSlider(_ sender: UISlider) {
        viewModel.playOnNewPosition(sender)
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
  }


  //MARK: - Observers

  private func timeObserve() {
    viewModel.observePlayerCurrentTime(currentTimeLabel: currentTimeLabel, remainingTimeLabel: remainingTimeLabel, currentTimeSlider: currentTimeSlider)

  }

  //MARK: - Setup Labels from ViewModel

  private func setupLabels() {
    songNameLabel.text = viewModel.track[viewModel.position].name
    artistNameLabel.text = viewModel.track[viewModel.position].artists.first?.name
    if let imageURL = URL(string: viewModel.track[viewModel.position].album?.images.first?.url ?? "") {
      DispatchQueue.main.async {
        if let imageData = try? Data(contentsOf: imageURL) {
          self.imageView.image = UIImage(data: imageData)
        }
      }
    }
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
  }
}

