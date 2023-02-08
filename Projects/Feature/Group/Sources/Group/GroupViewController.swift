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

    weak var coordinator: GroupCoordinator?
    
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
        
        coordinator?.delegate = self
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
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        self.bodyView.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        bodyView.plusActionButton.rx.throttleTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.coordinator?.presentCreateGroup(
                    title: "asdasd",
                    message: "message",
                    okTitle: "ok",
                    cancelTitle: "cancel"
                )
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        // State
        
        reactor.state.map { $0.sections }
            .subscribe(onNext: { [weak self] sections in
                self?.bodyView.sections.accept(sections)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: false)
            .drive(self.bodyView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
    
    private func bindView(reactor: Reactor) {
        // View
        
        bodyView.searchBar.rx.text
            .skip(1)
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .map { $0 ?? "" }
            .drive(with: self) { owner, text in
                owner.reactor?.action.onNext(.fetch(keyword: text))
            }
            .disposed(by: bodyView.disposeBag)
    }
}

extension GroupViewController {
    class func instance(
        selectMode: SelectMode,
        selectedIDs: Set<String>
    ) -> GroupViewController {
        GroupViewController(
            reactor: GroupViewReactor(
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


// MARK: GroupCoordinatorDelegate

extension GroupViewController: GroupCoordinatorDelegate {
    func createGroup(name: String) {
        reactor?.action.onNext(.createGroup(name: name))
    }
}

extension GroupViewController: GroupViewDelegate {
    func groupCellDidTap(id: String) {
        reactor?.action.onNext(.clickGroup(id: id))
    }
}
