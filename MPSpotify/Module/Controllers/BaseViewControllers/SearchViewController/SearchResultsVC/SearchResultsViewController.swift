//
//  SearchResultsViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 15.02.23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: SearchResult)
}

final class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  //MARK: - IBOutlets

  @IBOutlet private weak var tableView: UITableView!

  //MARK: - Properties

  weak var delegate: SearchResultsViewControllerDelegate?
  var sections: [SearchSection] = []
  var searchResults: [SearchResult] = []


  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.keyboardDismissMode = .onDrag
    registerCells()
  }

  private func registerCells() {
    let nibCell = UINib(nibName: "\(SearchResultsTableViewCell.self)", bundle: nil)

    tableView.register(nibCell, forCellReuseIdentifier: "\(SearchResultsTableViewCell.self)")

    self.tableView.delegate = self
    self.tableView.dataSource = self
  }

   func scrollViewDidScroll(_ scrollView: UIScrollView) {
       if !tableView.isDecelerating {
           view.endEditing(true)
       }
   }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
    let result = sections[indexPath.section].results[indexPath.row]
      delegate?.didTapResult(result)
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    return sections.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sections[section].results.count
  }

  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    if let headerView = view as? UITableViewHeaderFooterView {
      headerView.contentView.backgroundColor = .black
      headerView.backgroundView?.backgroundColor = .black
      headerView.textLabel?.textColor = .white
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let result = sections[indexPath.section].results[indexPath.row]

      switch result {
      case .album(let album):
          guard let cell = tableView.dequeueReusableCell(
              withIdentifier: "\(SearchResultsTableViewCell.self)",
              for: indexPath
          ) as? SearchResultsTableViewCell else {
              return  UITableViewCell()
          }
          let viewModel = SearchResultTableViewModel(
              title: album.name,
              subtitle: album.artists.first?.name ?? "",
              imageURL: URL(string: album.images.first?.url ?? "")
          )
          cell.configure(with: viewModel)
          return cell
      case .track(let track):
          guard let cell = tableView.dequeueReusableCell(
              withIdentifier: "\(SearchResultsTableViewCell.self)",
              for: indexPath
          ) as? SearchResultsTableViewCell else {
              return  UITableViewCell()
          }
          let viewModel = SearchResultTableViewModel(
              title: track.name,
              subtitle: track.artists.first?.name ?? "-",
              imageURL: URL(string: track.album?.images.first?.url ?? "")
          )
          cell.configure(with: viewModel)
          return cell
      case .playlist(let playlist):
          guard let cell = tableView.dequeueReusableCell(
              withIdentifier: "\(SearchResultsTableViewCell.self)",
              for: indexPath
          ) as? SearchResultsTableViewCell else {
              return  UITableViewCell()
          }
          let viewModel = SearchResultTableViewModel(
              title: playlist.name,
              subtitle: playlist.owner.displayName,
              imageURL: URL(string: playlist.images.first?.url ?? "")
          )
          cell.configure(with: viewModel)
          return cell
      }
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section].title
  }

  //MARK: - Update results

  func update(with results: [SearchResult]) {

      let albums = results.filter({
          switch $0 {
          case .album:
            return true
          default:
            return false
          }
      })

      let tracks = results.filter({
          switch $0 {
          case .track:
            return true
          default:
            return false
          }
      })

      let playlists = results.filter({
          switch $0 {
          case .playlist:
            return true
          default:
            return false
          }
      })

    self.sections = [
          SearchSection(title: "Songs", results: tracks),
          SearchSection(title: "Playlists", results: playlists),
          SearchSection(title: "Albums", results: albums)
      ]

      tableView.reloadData()
      tableView.isHidden = results.isEmpty
  }

}
