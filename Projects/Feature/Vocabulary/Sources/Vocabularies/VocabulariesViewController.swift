//
//  VocabulariesViewController.swift
//  Vocabulary
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

import Core

final class VocabulariesViewController: BaseViewController, View {
    
    typealias Reactor = VocabulariesViewReactor
    
    // MARK: Properties
    
    // MARK: UI
    
    let bodyView: VocabulariesView
    
    // MARK: Initializing
    
    init(
        reactor: Reactor,
        bodyView: VocabulariesView
    ) {
        defer {
            self.reactor = reactor
        }
        
        self.bodyView = bodyView
        
        super.init()
        
        self.bodyView.parentViewController = self
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
        
        reactor?.action.onNext(.fetch(nil))
    }
    
    // MARK: Setup
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupDelegate() {
        super.setupDelegate()
    }
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {

        // Action
        
        bodyView.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bodyView.plusActionButton.rx.throttleTap
            .map { Reactor.Action.plusActionButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bodyView.shuffleActionButton.rx.throttleTap
            .map { Reactor.Action.shuffle }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bodyView.sectionTitleView.rx.throttleTap
            .map { Reactor.Action.groupSelectButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        reactor.pulse(\.$sections)
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, sections in
                owner.bodyView.sections.accept(sections)
            }
            .disposed(by: disposeBag)
            
        reactor.pulse(\.$isRefreshing)
            .asDriver(onErrorJustReturn: false)
            .drive(bodyView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$group)
            .map { $0?.name ?? "모든 그룹" }
            .asDriver(onErrorJustReturn: "")
            .drive(bodyView.sectionTitleView.rx.subtitle)
            .disposed(by: disposeBag)
    }
    
    // Using BodyView
    
    func bindCell(_ cell: VocabularyCell) {
        cell.rx.throttleTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { [weak cell] owner, _ in
                guard var vocabulary = cell?.reactor?.currentState.vocabulary else { return }
                vocabulary.isExpand.toggle()
                owner.reactor?.action.onNext(.update(vocabulary))
            }
            .disposed(by: cell.disposeBag)
        
        cell.rx.throttleLongPress
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { [weak cell] owner, _ in
                guard let vocabulary = cell?.reactor?.currentState.vocabulary else { return }
                owner.reactor?.action.onNext(.edit(vocabulary))
            }
            .disposed(by: cell.disposeBag)
    }
}

// MARK: VocabularyViewController

extension VocabulariesViewController {
    class func instance(coordinator: VocabulariesCoordinator) -> VocabulariesViewController {
        VocabulariesViewController(
            reactor: VocabulariesViewReactor(
                coordinator: coordinator,
                vocabularyService: VocabularyCoreDataService(
                    repository: VocabularyCoreDataRepository(coreDataManager: CoreDataManager.shared)
                )
            ),
            bodyView: VocabulariesView.instance()
        )
    }
}
