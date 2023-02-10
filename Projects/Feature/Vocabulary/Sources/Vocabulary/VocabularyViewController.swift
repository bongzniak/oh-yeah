//
//  VocabularyViewController.swift
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

final class VocabularyViewController: BaseViewController, View {
    
    typealias Reactor = VocabularyViewReactor
    
    // MARK: Properties

    // MARK: UI
    
    let bodyView: VocabularyView
    
    // MARK: Initializing
    
    init(
        reactor: Reactor,
        bodyView: VocabularyView
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
        
        bodyView.delegate = self
        
        reactor?.action.onNext(.fetch)
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
        
        self.bodyView.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        self.bodyView.plusActionButton.rx.throttleTap
            .map { Reactor.Action.plusActionButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.bodyView.shuffleActionButton.rx.throttleTap
            .map { Reactor.Action.shuffle }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bodyView.sectionTitleView.rx.throttleTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.reactor?.coordinator.pushToGroup()
            }
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
}

// MARK: VocabularyViewDelegate

extension VocabularyViewController: VocabularyViewDelegate {
    func vocabularyCellDidTap(_ vocabulary: Vocabulary) {
        reactor?.action.onNext(.update(vocabulary))
    }
}

// MARK: VocabularyViewController

extension VocabularyViewController {
    class func instance(coordinator: VocabularyCoordinator) -> VocabularyViewController {
        VocabularyViewController(
            reactor: VocabularyViewReactor(
                coordinator: coordinator,
                vocabularyService: VocabularyCoreDataService(
                    repository: VocabularyCoreDataRepository(coreDataManager: CoreDataManager.shared)
                )
            ),
            bodyView: VocabularyView.instance()
        )
    }
}
