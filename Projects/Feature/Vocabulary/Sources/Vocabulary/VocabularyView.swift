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

import Core
import DesignSystem

protocol VocabularyViewDelegate: AnyObject {
    func sentenceButtonDidTap(_ sentence: String)
}

final class VocabularyView: BaseView {
    
    typealias RxDataSource = RxCollectionViewSectionedReloadDataSource<VocabularySection>
    
    private enum Metric {
        static var cellWidth: CGFloat {
            UIScreen.main.bounds.width
            - Metric.CollectionView.contentInset.left
            - Metric.CollectionView.contentInset.right
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
    
    weak var delegate: VocabularyViewDelegate?

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
    
    // MARK: Initializing
    
    override init() {
        super.init()
        
        backgroundColor = .ohWhite
        
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
            configureCell: { [weak self]
                (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                switch sectionItem {
                    case .vocabulary(let vocabulary):
                        let cell: VocabularyCell = collectionView.dequeueReusableCell(for: indexPath)
                        cell.reactor = VocabularyCellReactor(vocabulary: vocabulary)
                        self?.cellBind(cell)
                        return cell
                }
            }
        )
    }
    
    private func cellSize(indexPath: IndexPath) -> CGSize {
        let sectionItem = dataSource[indexPath.section].items[indexPath.item]
        switch sectionItem {
            case .vocabulary:
                return VocabularyCell.size(width: Metric.cellWidth)
        }
    }
    
    private func cellBind(_ cell: VocabularyCell) {
        cell.sentenceButton.rx.tap
            .map {
                cell.reactor?.currentState.vocabulary.spelling ?? ""
            }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self, onNext: { owner, text in
                owner.delegate?.sentenceButtonDidTap(text)
            })
            .disposed(by: disposeBag)
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
