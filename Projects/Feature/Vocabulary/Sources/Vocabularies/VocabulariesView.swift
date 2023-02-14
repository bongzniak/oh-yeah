//
//  VocabulariesView.swift
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

final class VocabulariesView: BaseView {
    
    typealias RxDataSource = RxCollectionViewSectionedReloadDataSource<VocabularySection>
    
    private enum Metric {
        static var cellWidth: CGFloat {
            UIScreen.main.bounds.width - Metric.CollectionView.contentInset.horizontal
        }
        enum CollectionView {
            static let contentInset: UIEdgeInsets = UIEdgeInsets(
                top: 12,
                left: 12,
                bottom: 12,
                right: 12
            )
        }
    }
    
    private enum Color {   
    }
    
    private enum Font {    
    }
    
    private enum Image {
        static let shuffle = UIImage(systemName: "shuffle")
        static let plus = UIImage(systemName: "plus")
    }
    
    private enum Localized {
    }
    
    // MARK: Properties

    weak var parentViewController: VocabulariesViewController?
    
    lazy var dataSource: RxDataSource = dataSourceFactory()
    let sections = PublishRelay<[VocabularySection]>()
    
    // MARK: UI
    
    let sectionTitleView = SectionTitleView()
    let refreshControl = UIRefreshControl()
    let collectionView = UICollectionView(
        frame: CGRect.zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        
        $0.contentInset = Metric.CollectionView.contentInset
    }
    
    let shuffleActionButton: UIButton = UIButton().then {
        $0.setImage(Image.shuffle, for: .normal)
    }
    
    let plusActionButton: UIButton = UIButton().then {
        $0.setImage(Image.plus, for: .normal)
    }
    
    // MARK: Initializing
    
    override init() {
        super.init()
        
        backgroundColor = .ohWhite
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup
    
    override func setupProperty() {
        super.setupProperty()
     
        sectionTitleView.title = "오늘 공부할 단어들이에요!!"
        
        collectionView.refreshControl = refreshControl
        collectionView.register(cellType: VocabularyCell.self)
        collectionView.register(cellType: EmptyCell.self)
        
        shuffleActionButton.backgroundColor = .blue1
        shuffleActionButton.layer.cornerRadius = 22
        
        plusActionButton.backgroundColor = .blue4
        plusActionButton.layer.cornerRadius = 22
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubview(sectionTitleView)
        addSubview(collectionView)
        addSubview(shuffleActionButton)
        addSubview(plusActionButton)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        sectionTitleView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(sectionTitleView.snp.bottom)
            $0.leading.bottom.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        shuffleActionButton.snp.makeConstraints {
            $0.trailing.equalTo(plusActionButton)
            $0.bottom.equalTo(plusActionButton.snp.top).offset(-6)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        
        plusActionButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
    }
    
    override public func setupBind() {
        super.setupBind()
        
        collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        sections
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension VocabulariesView {
    private func dataSourceFactory() -> RxDataSource {
        RxDataSource(
            configureCell: { [weak self]
                (_, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                switch sectionItem {
                    case .vocabulary(let vocabulary):
                        let cell: VocabularyCell = collectionView.dequeueReusableCell(for: indexPath)
                        cell.reactor = VocabularyCellReactor(vocabulary: vocabulary)
                        self?.parentViewController?.bindCell(cell)
                        return cell
                        
                    case .empty:
                        let cell: EmptyCell = collectionView.dequeueReusableCell(for: indexPath)
                        return cell
                }
            }
        )
    }
    
    private func cellSize(indexPath: IndexPath) -> CGSize {
        let sectionItem = dataSource[indexPath.section].items[indexPath.item]
        switch sectionItem {
            case .vocabulary(let vocabulary):
                return VocabularyCell.size(width: Metric.cellWidth, vocabulary: vocabulary)
                
            case .empty:
                return EmptyCell.size(
                    width: Metric.cellWidth,
                    height: collectionView.frame.height - Metric.CollectionView.contentInset.vertical
                )
        }
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension VocabulariesView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        cellSize(indexPath: indexPath)
    }
}

extension VocabulariesView {
    class func instance() -> VocabulariesView {
        VocabulariesView()
    } 
}
