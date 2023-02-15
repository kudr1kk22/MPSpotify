//
//  SearchViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 24.01.23.
//

import UIKit


final class SearchViewController: UIViewController {

  //MARK: - IBOutlets

  @IBOutlet private weak var collectionView: UICollectionView!


  //MARK: - Initialization

  init(searchViewModel: SearchViewModelProtocol) {
    self.searchViewModel = searchViewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Properties

  private var searchViewModel: SearchViewModelProtocol

  private let searchController: UISearchController = {
      let vc = UISearchController(searchResultsController: SearchResultsViewController())
      return vc
  }()

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchController()
    bind()
    registerCells()
    self.collectionView.reloadData()
  }

  //MARK: - Binding

  private func bind() {
    searchViewModel.complitionHandler = {
          print("Content updated")
      }
  }

//MARK: - Setup search controller

  func setupSearchController() {

    searchController.searchBar.placeholder = "Songs, Artists, Albums"
    searchController.searchBar.searchBarStyle = .minimal
    searchController.searchBar.barStyle = .black
    searchController.definesPresentationContext = true
    navigationItem.searchController = searchController
    searchController.searchResultsUpdater = self
    
  }

  //MARK: - Create CollectionViewCell

  private func registerCells() {
    let nib = UINib(nibName: "\(CategoriesCollectionViewCell.self)",
                    bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "\(CategoriesCollectionViewCell.self)")

    collectionView.dataSource = self
    collectionView.delegate = self
  }


}

//MARK: - UICollectionViewDataSource

extension SearchViewController: UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return searchViewModel.categories.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoriesCollectionViewCell.self)", for: indexPath) as? CategoriesCollectionViewCell else { return UICollectionViewCell() }
    let category = searchViewModel.categories[indexPath.row]

    DispatchQueue.main.async {
      cell.configure(with: CategoriesCellViewModel(
        title: category.name,
        imageURL: URL(string: category.icons.first?.url ?? "")))
    }

    return cell
  }

}

//MARK: - UICollectionViewDelegate

extension SearchViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      collectionView.deselectItem(at: indexPath, animated: true)
      let category = searchViewModel.categories[indexPath.row]
    let caterogyInfoVM = CategoryInfoViewModel(category: category, apiCaller: searchViewModel.apiCaller)
    let caterogyInfoVC = CategoryInfoViewController(categoryInfoViewModel: caterogyInfoVM)
    caterogyInfoVC.navigationItem.largeTitleDisplayMode = .never
      navigationController?.pushViewController(caterogyInfoVC, animated: true)

    }
  }

//MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    guard let text = searchController.searchBar.text else { return }

      searchViewModel.search(from: text)
      guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
            let query = searchController.searchBar.text,
            !query.trimmingCharacters(in: .whitespaces).isEmpty else {
          return
      }
      resultsController.delegate = self
      resultsController.update(with: searchViewModel.searchResults)

    }

  }


extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ result: SearchResult) {
      let apiCaller = APICaller(authManager: AuthManager())
        switch result {
        case .album(let model):
            let vc = DetailsReleasViewController(detailsReleasVCViewModel: DetailsReleasViewModel(album: model, apiCaller: apiCaller))
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        case .track(let model):
          let viewModel = PlayerViewModel(audioControl: CommandCenterAudioControl(track: [model]))
          let playerVC = PlayerViewController(viewModel: viewModel)
          viewModel.audioControl.startPlaybacks(from: playerVC, track: [model], position: 0)
          present(playerVC, animated: true)
          viewModel.audioControl.playerQueue?.play()
        case .playlist(let model):
            let vc = PlaylistViewController(playlistViewModel: PlaylistViewModel(playlist: model, apiCaller: apiCaller))
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
