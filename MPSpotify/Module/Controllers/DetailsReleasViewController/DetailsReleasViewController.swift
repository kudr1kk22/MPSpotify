//
//  DetailsReleasViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 7.02.23.
//

import UIKit

final class DetailsReleasViewController: UIViewController {

//MARK: - IBOutlets

  @IBOutlet private weak var tableView: UITableView!

  //MARK: - Properites

  private var detailsReleasVCViewModel: DetailsReleasVMProtocol

  //MARK: - Initialization

  init(detailsReleasVCViewModel: DetailsReleasVMProtocol) {
    self.detailsReleasVCViewModel = detailsReleasVCViewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    registerTableView()
    bind()
  }

  private func bind() {
    detailsReleasVCViewModel.complitionHandler = {
          print("Content updated detailsReleasVCViewModel")
      self.tableView.reloadData()
      }
  }

  private func registerTableView() {
    self.tableView.dataSource = self
    self.tableView.delegate = self

    let nibDefaultCell = UINib(nibName: "\(DetailsRealeasTableViewCell.self)", bundle: nil)

    tableView.register(nibDefaultCell, forCellReuseIdentifier: "\(DetailsRealeasTableViewCell.self)")

    let nibHeaderCell = UINib(nibName: "\(HeaderView.self)", bundle: nil)

    tableView.register(nibHeaderCell, forHeaderFooterViewReuseIdentifier: "\(HeaderView.self)")

  }

  func playTracks(_ position: Int) {
    let tracksWithAlbum: [AudioTrack] = detailsReleasVCViewModel.tracks.compactMap({
      var track = $0
      track.album = self.detailsReleasVCViewModel.album
      return track
    })
    let viewModel = PlayerViewModel(track: tracksWithAlbum)
    let playerVC = PlayerViewController(viewModel: viewModel)
    viewModel.startPlaybacks(from: playerVC, track: tracksWithAlbum, position: position)
    present(playerVC, animated: true)
    viewModel.playerQueue?.play()
  }

}



//MARK: - UITableViewDataSource

extension DetailsReleasViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return detailsReleasVCViewModel.viewModels.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailsRealeasTableViewCell.self)", for: indexPath) as? DetailsRealeasTableViewCell else { return UITableViewCell() }
      cell.configure(with: self.detailsReleasVCViewModel.viewModels[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "\(HeaderView.self)") as? HeaderView else { return UITableViewHeaderFooterView() }
    let headerViewModel = HeaderViewVM(
      artistName: detailsReleasVCViewModel.album.artists.first?.name ?? "-",
      songName: detailsReleasVCViewModel.album.name,
      releaseDate: "\(String.formattedDate(string: detailsReleasVCViewModel.album.releaseDate))",
      image: URL(string: detailsReleasVCViewModel.album.images.first?.url ?? "")
    )
    headerView.configure(with: headerViewModel)
    headerView.headerViewDelegate = self
  return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return UIScreen.main.bounds.height / 2.3
  }

}

//MARK: - UITableViewDelegate

extension DetailsReleasViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    playTracks(indexPath.row)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 70.0
  }


  }

extension DetailsReleasViewController: HeaderViewPlayButtonTapDelegate {
  func playAlltracks(_ header: HeaderView) {
       playTracks(0)
    }
  
  }






