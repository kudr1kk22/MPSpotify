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

  //MARK: - Properties

  private var searchViewModel: SearchViewModelProtocol

  //MARK: - Initialization

  init(searchViewModel: SearchViewModelProtocol) {
    self.searchViewModel = searchViewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
    registerCells()
    self.collectionView.reloadData()
  }

  private func bind() {
    searchViewModel.complitionHandler = {
          print("Content updated")
      }
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

