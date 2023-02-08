//
//  GroupView.swift
//  Group
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import Reusable
import SnapKit
import Then

import Core

protocol GroupViewDelegate: AnyObject {
    func groupCellDidTap(id: String)
}

final class GroupView: BaseView {
    
    typealias RxDataSource = RxCollectionViewSectionedReloadDataSource<GroupSection>
    
    // MARK: Constants
    
    private enum Metric {
        static var cellWidth: CGFloat {
            UIScreen.main.bounds.width - Metric.CollectionView.contentInset.horizontal
        }
        enum CollectionView {
            static let contentInset: UIEdgeInsets = UIEdgeInsets(12)
        }
        
        enum PlusActionButton {
            static let size = CGSize(width: 44, height: 44)
        }
    }
    
    private enum Color {   
    }
    
    private enum Font {    
    }
    
    private enum Localized {
    }
    
    // MARK: Properties
    
    weak var delegate: GroupViewDelegate?

    var dataSource: RxDataSource!
    let sections = PublishRelay<[GroupSection]>()
    
    // MARK: UI
    
    let searchBar: UISearchBar = UISearchBar().then {
        $0.barTintColor = UIColor.white
        $0.setBackgroundImage(
            UIImage.init(),
            for: UIBarPosition.any,
            barMetrics: UIBarMetrics.default
        )
        $0.placeholder = "검색할 그룹명을 입력하세요"
    }
    
    let refreshControl = UIRefreshControl()
    let collectionView = UICollectionView(
        frame: CGRect.zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.isScrollEnabled = true
        $0.backgroundColor = .clear
        $0.contentInset = Metric.CollectionView.contentInset
    }
    
    let plusActionButton: UIButton = UIButton().then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.backgroundColor = .blue4
        $0.layer.cornerRadius = 22
    }
    
    // MARK: Initializing
    
    override init() {
        super.init()
        
        dataSource = dataSourceFactory()

        bind()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: UI Setup
    
    override func setupProperty() {
        super.setupProperty()
        
        collectionView.refreshControl = refreshControl
        collectionView.register(cellType: GroupCell.self)
        
        backgroundColor = .white
    }
    
    override func setupDelegate() {
        super.setupDelegate()
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        
        addSubview(searchBar)
        addSubview(collectionView)
        addSubview(plusActionButton)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        searchBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(safeAreaLayoutGuide)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
        plusActionButton.snp.makeConstraints {
            $0.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(10)
            $0.size.equalTo(Metric.PlusActionButton.size)
        }
    }
    
    // MARK: Binding
    
    private func bind() {
        collectionView.rx.setDelegate(self)
            .disposed(by: self.disposeBag)
        
        sections
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        
    }
}

extension GroupView {
    private func dataSourceFactory() -> RxDataSource {
        RxDataSource(
            configureCell: { [weak self]
                (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                switch sectionItem {
                    case .unknown:
                        let cell: GroupCell = collectionView.dequeueReusableCell(for: indexPath)
                        cell.reactor = GroupCellReactor(group: nil, isSelected: false)
                        self?.cellBind(cell)
                        return cell
                        
                    case .group(let group, let isSelected):
                        let cell: GroupCell = collectionView.dequeueReusableCell(for: indexPath)
                        cell.reactor = GroupCellReactor(group: group, isSelected: isSelected)
                        self?.cellBind(cell)
                        return cell
                }
            },
            canMoveItemAtIndexPath: { _, _ in
                true
            }
        )
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension GroupView: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        cellSize(indexPath: indexPath)
    }
    
    private func cellSize(indexPath: IndexPath) -> CGSize {
        let sectionItem = dataSource[indexPath.section].items[indexPath.item]
        switch sectionItem {
            case .unknown, .group(_, _):
                return GroupCell.size(width: Metric.cellWidth)
        }
    }
    
    private func cellBind(_ cell: GroupCell) {
        cell.rx.throttleTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                guard let id = cell.reactor?.currentState.id else { return }
                owner.delegate?.groupCellDidTap(id: id)
            }
            .disposed(by: cell.disposeBag)
    }
}

extension GroupView {
    class func instance() -> GroupView {
        GroupView()
    } 
}
