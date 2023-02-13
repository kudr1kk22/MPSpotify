//
//  HomeViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 24.01.23.
//

import UIKit

final class HomeViewController: UIViewController {

  @IBOutlet private weak var collectionView: UICollectionView!

  //MARK: - Properties

  private var homeVCViewModel: HomeVCViewModelProtocol

  //MARK: - Initialization

  init(homeVCViewModel: HomeVCViewModelProtocol) {
    self.homeVCViewModel = homeVCViewModel
    super.init(nibName: "\(HomeViewController.self)", bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    registerCells()
    configureCompositionalLayout()
  }

  //MARK: - Binding

  private func bind() {
    homeVCViewModel.complitionHandler = {
      print("Content updated")
      self.fetchData()
    }
  }

  //MARK: - Play tracks

  func playTracks(_ position: Int) {
    guard let tracks = homeVCViewModel.recommendationsModel?.tracks else { return }
    let filter = tracks.filter { $0.previewURL != nil }
    let viewModel = PlayerViewModel(track: filter)
    let playerVC = PlayerViewController(viewModel: viewModel)
    viewModel.startPlaybacks(from: playerVC, track: filter, position: position)
    present(playerVC, animated: true)
    viewModel.playerQueue?.play()
  }


  //MARK: - Update UI elements from model

  private func fetchData() {
    guard let newAlbums = homeVCViewModel.newReleasesModel?.albums.items,
          let tracks = homeVCViewModel.recommendationsModel?.tracks else { fatalError("Models are nil")
    }
      self.homeVCViewModel.configureModels(newAlbums: newAlbums, tracks: tracks)
      self.collectionView.reloadData()

    }


  //MARK: - Create CollectionViewCell

  private func registerCells() {

      let nib = UINib(nibName: "\(NewReleaseCollectionViewCell.self)",
                      bundle: nil)
      collectionView.register(nib, forCellWithReuseIdentifier: "\(NewReleaseCollectionViewCell.self)")

      let recommendedCollectionViewNib = UINib(nibName: "\(RecommendedCollectionViewCell.self)", bundle: nil)
      collectionView.register(recommendedCollectionViewNib, forCellWithReuseIdentifier: "\(RecommendedCollectionViewCell.self)")

      let headernib = UINib(nibName: "\(HeaderTitleViewCell.self)", bundle: nil)
      collectionView.register(headernib,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderTitleViewCell.self)")

      collectionView.dataSource = self
      collectionView.delegate = self
    }

    // MARK: - Setup Layout



  func configureCompositionalLayout(){
      let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
        return HomeViewController.createSectionLayout(section: sectionIndex)
      }

      collectionView.setCollectionViewLayout(layout, animated: true)
  }





  }


  //MARK: - UICollectionViewDelegate

  extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      collectionView.deselectItem(at: indexPath, animated: true)

      let section = homeVCViewModel.sections[indexPath.section]

      switch section {
      case .newReleases:
        let album = homeVCViewModel.newAlbums[indexPath.row]
        let albumVM = DetailsReleasViewModel(album: album, apiCaller: homeVCViewModel.apiCaller)
        let albumVC = DetailsReleasViewController(detailsReleasVCViewModel: albumVM)
        albumVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(albumVC, animated: true)

      case .recommendedTracks:
        playTracks(indexPath.row)

      }

    }

  }

  //MARK: - UICollectionViewDataSource

  extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
      let type = homeVCViewModel.sections[section]
      switch type {
      case .newReleases(let viewModels):
        return viewModels.count
      case .recommendedTracks(let viewModels):
        return viewModels.count
      }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
      return homeVCViewModel.sections.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

      let type = homeVCViewModel.sections[indexPath.section]
      switch type {
      case .newReleases(let viewModels):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(NewReleaseCollectionViewCell.self)", for: indexPath) as? NewReleaseCollectionViewCell else { return UICollectionViewCell() }
        let viewModel = viewModels[indexPath.row]
        DispatchQueue.main.async {
          cell.configure(with: viewModel)
        }

        return cell



      case .recommendedTracks(viewModels: let viewModels):
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(RecommendedCollectionViewCell.self)", for: indexPath) as? RecommendedCollectionViewCell else { return UICollectionViewCell() }
        let viewModel = viewModels[indexPath.row]
        DispatchQueue.main.async {
          cell.configure(with: viewModel)
        }
        return cell
      }


    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
      guard let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: "\(HeaderTitleViewCell.self)",
        for: indexPath) as? HeaderTitleViewCell,kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
    }
      let section = indexPath.section
      let title = homeVCViewModel.sections[section].title
      header.configure(with: title)
      return header
    }


  }

extension HomeViewController {

  static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
    let supplementaryViews = [
      NSCollectionLayoutBoundarySupplementaryItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .absolute(50)
        ),
        elementKind: UICollectionView.elementKindSectionHeader,
        alignment: .top
      )
    ]

    switch section {
    case 0:
      // Item
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(1.0)
        )
      )

      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

      // Vertical group in horizontal group
      let verticalGroup = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(390)
        ),
        subitem: item,
        count: 3
      )

      let horizontalGroup = NSCollectionLayoutGroup.horizontal(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(0.9),
          heightDimension: .absolute(390)
        ),
        subitem: verticalGroup,
        count: 1
      )

      // Section
      let section = NSCollectionLayoutSection(group: horizontalGroup)
      section.orthogonalScrollingBehavior = .groupPaging
      section.boundarySupplementaryItems = supplementaryViews
      return section

    case 1:
      // Item
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(1.0)
        )
      )

      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1),
          heightDimension: .absolute(80)
        ),
        subitem: item,
        count: 1
      )

      let section = NSCollectionLayoutSection(group: group)
      section.boundarySupplementaryItems = supplementaryViews
      return section
    default:
      // Item
      let item = NSCollectionLayoutItem(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalHeight(1.0)
        )
      )

      item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)

      let group = NSCollectionLayoutGroup.vertical(
        layoutSize: NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .absolute(390)
        ),
        subitem: item,
        count: 1
      )
      let section = NSCollectionLayoutSection(group: group)
      section.boundarySupplementaryItems = supplementaryViews
      return section
    }
  }
}

