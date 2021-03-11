//
//  ListViewController.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 09.03.2021.
//

import UIKit

class ListViewController: UIViewController {

    private var accessToken: String!
    private var viewModel: ListViewModel!
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, TextStatisticModel>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        createDataSource()
        downloadAndSetupData()
    }
    
    convenience init(accessToken: String) {
        self.init()
        self.accessToken = accessToken
        self.viewModel = ListViewModel()
    }
    
    //VC does not deinit but disappearing from view hierarchy
    deinit {
        print("ListViewController deinited")
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.reuseID)
    }
    
    
    
    //MARK: - Download Data -
    private func downloadAndSetupData() {
        var textStatistic = [TextStatisticModel]()
        NetworkManager.shared.textRequest(accessToken: accessToken) { (response) in
            switch response {
            case .success(let text):
                if let responseText = text.data, !responseText.isEmpty {
                    textStatistic = self.viewModel.getTextStatistic(str: responseText)
                    var snapshot = NSDiffableDataSourceSnapshot<Section, TextStatisticModel>()
                    snapshot.appendSections([.statistic])
                    snapshot.appendItems(textStatistic, toSection: .statistic)
                    self.dataSource.apply(snapshot, animatingDifferences: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    UIApplication.getTopViewController()?.showAlert(with: "Error", and: error.localizedDescription)
                }
            }
        }
    }
}

extension ListViewController {
    enum Section: Int, CaseIterable {
        case statistic
        
        func description(usersCount: Int) -> String {
            switch self {
            case .statistic:
                return "Statistic"
            }
        }
    }
}

//MARK: - Create UICollectionViewDiffableDataSource -
extension ListViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, TextStatisticModel>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, data) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .statistic:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseID, for: indexPath) as! CollectionViewCell
                cell.configre(letter: data.letter, count: data.count)
                return cell
            }
        })
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (senctionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let section = Section(rawValue: senctionIndex) else {
                fatalError("Unknown section kind")
            }
            switch section {
            case .statistic:
                return self.createSection()
            }
        }
        
        return layout
    }
    
    private func createSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 5)
        group.interItemSpacing = .fixed(5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        
        return section
    }
}
