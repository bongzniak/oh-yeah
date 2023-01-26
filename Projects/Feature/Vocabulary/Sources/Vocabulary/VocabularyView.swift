//
//  VocabularyView.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SnapKit
import Then
import Reusable

import Common

final class VocabularyView: BaseView {
    
    typealias RxDataSource = RxCollectionViewSectionedReloadDataSource<VocabularySection>
    
    private enum Metric {
        static var width: CGFloat {
            UIScreen.main.bounds.width
        }
        enum CollectionView {
            static let contentInset: UIEdgeInsets = UIEdgeInsets(
                top: 12,
                left: 24,
                bottom: 12,
                right: 24
            )
        }
    }
    
    private enum Color {   
    }
    
    private enum Font {    
    }
    
    private enum Localized {
    }
    
    // MARK: Properties

    var dataSource: RxDataSource!
    let sections = PublishRelay<[VocabularySection]>()
    
    // MARK: UI
    
    let refreshControl = UIRefreshControl()
    let collectionView = UICollectionView(
        frame: CGRect.zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
        $0.contentInset = Metric.CollectionView.contentInset
    }
    
    let testLabel: UILabel = UILabel().then {
        $0.text = ""
    }
    
    // MARK: Initializing
    
    override init() {
        super.init()
        
        backgroundColor = .white
        
        dataSource = dataSourceFactory()

        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    
    override func addViews() {
        super.addViews()

        addSubview(collectionView)
    }
    
    override func setupViews() {
        super.setupViews()

        collectionView.refreshControl = refreshControl
        collectionView.register(cellType: VocabularyCell.self)
    }

    override func setupConstraints() {
        super.setupConstraints()

        collectionView.snp.makeConstraints {
            $0.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func bind() {
        collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        sections
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension VocabularyView {
    private func dataSourceFactory() -> RxDataSource {
        RxDataSource(
            configureCell: {
                (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                switch sectionItem {
                    case .voca(let cellReactor):
                        let cell: VocabularyCell = collectionView.dequeueReusableCell(for: indexPath)
                        cell.reactor = cellReactor
                        return cell
                }
            }
        )
    }
    
    private func cellSize(indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = Metric.width
        - collectionView.contentInset.left
        - collectionView.contentInset.right
        
        let sectionItem = dataSource[indexPath.section].items[indexPath.item]
        switch sectionItem {
            case .voca:
                return VocabularyCell.size(width: cellWidth)
        }
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension VocabularyView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        cellSize(indexPath: indexPath)
    }
}

extension VocabularyView {
    class func instance() -> VocabularyView {
        VocabularyView()
    } 
}
