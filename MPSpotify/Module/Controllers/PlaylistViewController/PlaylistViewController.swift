//
//  PlaylistViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 12.02.23.
//

import UIKit

final class PlaylistViewController: UIViewController {

  //MARK: - IBOutlets

  @IBOutlet private weak var tableView: UITableView!

  //MARK: - Properties

  private var playlistViewModel: PlaylistViewModelProtocol

  //MARK: - Initialization

  init(playlistViewModel: PlaylistViewModelProtocol) {
    self.playlistViewModel = playlistViewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = playlistViewModel.playlist.name
    registerTableView()
    bind()
  }


  //MARK: - Binding

  private func bind() {
    playlistViewModel.complitionHandler = {
      print("playlistViewModel was updated")
      self.tableView.reloadData()
    }
  }


  //MARK: - Creating TableView

  private func registerTableView() {
    self.tableView.dataSource = self
    self.tableView.delegate = self

    let nibDefaultCell = UINib(nibName: "\(PlaylistTableViewCell.self)", bundle: nil)

    tableView.register(nibDefaultCell, forCellReuseIdentifier: "\(PlaylistTableViewCell.self)")

    let nibHeaderCell = UINib(nibName: "\(PlaylistVCHeaderView.self)", bundle: nil)

    tableView.register(nibHeaderCell, forHeaderFooterViewReuseIdentifier: "\(PlaylistVCHeaderView.self)")

  }

  func playTracks(_ position: Int) {
    let tracks = playlistViewModel.tracks
    let viewModel = PlayerViewModel(audioControl: CommandCenterAudioControl(track: tracks))
    let playerVC = PlayerViewController(viewModel: viewModel)
    viewModel.audioControl.startPlaybacks(from: playerVC, track: tracks, position: position)
    present(playerVC, animated: true)
    viewModel.audioControl.playerQueue?.play()
  }
}

extension PlaylistViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return playlistViewModel.viewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(PlaylistTableViewCell.self)", for: indexPath) as? PlaylistTableViewCell else { return UITableViewCell() }
    let viewModel = playlistViewModel.viewModels[indexPath.row]
    DispatchQueue.main.async {
      cell.configure(with: viewModel)
    }
    return cell
  }

  //MARK: - Configure header tableview

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(PlaylistVCHeaderView.self)") as? PlaylistVCHeaderView else { return UITableViewHeaderFooterView() }
    let headerViewModel = PlaylistVCHeaderViewVM(
      name: playlistViewModel.playlist.name,
      ownerName: playlistViewModel.playlist.owner.displayName,
      description: playlistViewModel.playlist.description,
      imageURL: URL(string: playlistViewModel.playlist.images.first?.url ?? ""))
    headerView.configure(with: headerViewModel)
    headerView.playlistVCheaderViewDelegate = self
    return headerView
  }

}




extension PlaylistViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    playTracks(indexPath.row)
  }

}


//MARK: - Playlist header play button tap delegate

extension PlaylistViewController: PlaylistHeaderViewPlayButtonTapDelegate {
  func playAlltracks(_ header: PlaylistVCHeaderView) {
           playTracks(0)
  }
}
