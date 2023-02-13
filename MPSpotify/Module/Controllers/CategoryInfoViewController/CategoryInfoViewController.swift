//
//  CategoryInfoViewController.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 11.02.23.
//

import UIKit

final class CategoryInfoViewController: UIViewController {

  //MARK: - IBOutlets

  @IBOutlet private weak var collectionView: UICollectionView!

  //MARK: - Properties
  private var categoryInfoViewModel: CategoryInfoViewModelProtocol


  

  //MARK: - Initialization

  init(categoryInfoViewModel: CategoryInfoViewModelProtocol) {
    self.categoryInfoViewModel = categoryInfoViewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    title = categoryInfoViewModel.category.name
    registerCells()
    bind()

  }

  //MARK: - Binding

  private func bind() {
    categoryInfoViewModel.complitionHandler = {
          print("Content updated categoryInfoViewModel")
      self.collectionView.reloadData()
      }
  }


  //MARK: - Create CollectionViewCell

  private func registerCells() {
    let nib = UINib(nibName: "\(CategoryInfoCollectionViewCell.self)",
                    bundle: nil)
    collectionView.register(nib, forCellWithReuseIdentifier: "\(CategoryInfoCollectionViewCell.self)")

    collectionView.dataSource = self
    collectionView.delegate = self
  }

}

extension CategoryInfoViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return categoryInfoViewModel.playlists.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryInfoCollectionViewCell.self)", for: indexPath) as? CategoryInfoCollectionViewCell else { return UICollectionViewCell() }
    let playlist = categoryInfoViewModel.playlists[indexPath.row]

    DispatchQueue.main.async {
      cell.configure(with: CategoryInfoCollectionViewCellViewModel(
        name: playlist.name,
        imageURL: URL(string: playlist.images.first?.url ?? ""),
        creatorName: playlist.owner.displayName))
    }
      return cell
  }

}

extension CategoryInfoViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    let playlist = categoryInfoViewModel.playlists[indexPath.row]
    let playlistVM = PlaylistViewModel(playlist: playlist, apiCaller: categoryInfoViewModel.apiCaller)
    let playlistVC = PlaylistViewController(playlistViewModel: playlistVM)
    playlistVC.navigationItem.largeTitleDisplayMode = .never
    navigationController?.pushViewController(playlistVC, animated: true)

  }

 

}
