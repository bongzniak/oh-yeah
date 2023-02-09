//
//  GroupViewController.swift
//  Group
//
//  Created by bongzniak on 2023/02/08.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

import Core
import DesignSystem

final class GroupViewController: BaseViewController, View {
    
    typealias Reactor = GroupViewReactor
    
    // MARK: Properties

    // MARK: UI
    
    let backBarButton: UIBarButtonItem = UIBarButtonItem(
        image: UIImage(systemName: "arrow.backward")?
            .withTintColor(.gray10, renderingMode: .alwaysOriginal),
        style: .plain,
        target: nil,
        action: nil
    )
    let doneBarButton: UIBarButtonItem = UIBarButtonItem(systemItem: .done)
    
    let bodyView: GroupView
    
    // MARK: Initializing
    
    init(
        reactor: Reactor,
        bodyView: GroupView
    ) {
        defer {
            self.reactor = reactor
        }
        
        self.bodyView = bodyView
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    
    override func loadView() {
        super.loadView()

        view = bodyView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = doneBarButton
        
        reactor?.action.onNext(.fetch(keyword: ""))
    }
    
    // MARK: Setup
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupDelegate() {
        super.setupDelegate()
        
        bodyView.delegate = self
    }
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        bindView(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        // Action
        
        backBarButton.rx.throttleTap
            .map { Reactor.Action.backBarButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bodyView.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        bodyView.plusActionButton.rx.throttleTap
            .map {
                Reactor.Action.plusActionButton(
                    title: "title",
                    message: "message",
                    okTitle: "ok",
                    cancelTitle: "cancel"
                )
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        // State
        
        reactor.pulse(\.$sections)
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, sections in
                owner.bodyView.sections.accept(sections)
            }
            .disposed(by: disposeBag)
            
        reactor.pulse(\.$isRefreshing)
            .asDriver(onErrorJustReturn: false)
            .drive(self.bodyView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindView(reactor: Reactor) {
        // View
        
        bodyView.searchBar.rx.text
            .distinctUntilChanged()
            .skip(1)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                guard let text else { return }
                owner.reactor?.action.onNext(.fetch(keyword: text))
            }
            .disposed(by: bodyView.disposeBag)
    }
}

// MARK: GroupViewDelegate

extension GroupViewController: GroupViewDelegate {
    func groupCellDidTap(id: String) {
        reactor?.action.onNext(.clickGroup(id: id))
    }
}


extension GroupViewController {
    class func instance(
        coordinator: GroupCoordinator,
        selectMode: SelectMode,
        selectedIDs: Set<String>
    ) -> GroupViewController {
        GroupViewController(
            reactor: GroupViewReactor(
                coordinator: coordinator,
                groupService: GroupCoreDataService(
                    repository: GroupCoreDataRepository(coreDataManager: CoreDataManager.shared)
                ),
                selectMode: selectMode,
                selectedIDs: selectedIDs
            ),
            bodyView: GroupView.instance()
        )
    }
}
