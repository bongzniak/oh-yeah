//
//  SaveVocabularyViewController.swift
//  VocabularyDemoApp
//
//  Created by bongzniak on 2023/02/06.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

import Core
import Group

final class SaveVocabularyViewController: BaseViewController, View {
    
    typealias Reactor = SaveVocabularyViewReactor
    
    // MARK: Properties

    // MARK: UI
    
    let closeBarButton = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: nil,
        action: nil
    )
    let saveBarButton = UIBarButtonItem(
        barButtonSystemItem: .save,
        target: nil,
        action: nil
    )
    let bodyView: SaveVocabularyView
    
    // MARK: Initializing
    
    init(
        reactor: Reactor,
        bodyView: SaveVocabularyView
    ) {
        defer {
            self.reactor = reactor
        }
        
        self.bodyView = bodyView
        
        super.init()
        
        setupNavigation()
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
    }
    
    // MARK: Setup
    
    override func setupProperty() {
        super.setupProperty()
    }
    
    override func setupDelegate() {
        super.setupDelegate()
    }
    
    func setupNavigation() {
        navigationItem.leftBarButtonItem = closeBarButton
        navigationItem.rightBarButtonItem = saveBarButton
    }
    
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
        bindView(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        
        closeBarButton.rx.throttleTap
            .map { Reactor.Action.closeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        saveBarButton.rx.throttleTap
            .map { Reactor.Action.save }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        bodyView.searchSententButton.rx.throttleTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let spelling = owner.bodyView.spellingTextView.text
                guard owner.isSearchButtonEnable(spelling) else { return }
                owner.searchSentence(spelling: spelling)
            }
            .disposed(by: bodyView.disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.pulse(\.$spelling)
            .asDriver(onErrorJustReturn: "")
            .drive(bodyView.spellingTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$description)
            .asDriver(onErrorJustReturn: "")
            .drive(bodyView.descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$sentence)
            .asDriver(onErrorJustReturn: "")
            .drive(bodyView.sentenceTextView.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindView(reactor: Reactor) {
        bodyView.spellingTextView.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                guard let text else { return }
                owner.bodyView.searchSententButton.isEnabled = owner.isSearchButtonEnable(text)
            }
            .disposed(by: disposeBag)
        
        bodyView.spellingTextView.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                guard let text else { return }
                owner.reactor?.action.onNext(.onChangedSpelling(text))
            }
            .disposed(by: disposeBag)
        
        bodyView.descriptionTextView.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                guard let text else { return }
                owner.reactor?.action.onNext(.onChangedDescription(text))
            }
            .disposed(by: disposeBag)
        
        bodyView.sentenceTextView.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, text in
                guard let text else { return }
                owner.reactor?.action.onNext(.onChangedSentence(text))
            }
            .disposed(by: disposeBag)
    }
    
    private func isSearchButtonEnable(_ text: String) -> Bool {
        return !text.isEmpty && text.count > 2
    }
    
    private func searchSentence(spelling: String) {
        if let url = URL(
            string: "https://en.dict.naver.com/#/search?range=example&query=\(spelling)"
        ) {
            UIApplication.shared.open(url)
        }
    }
}

extension SaveVocabularyViewController {
    class func instance(coordinator: SaveVocabularyCoordinator) -> SaveVocabularyViewController {
        SaveVocabularyViewController(
            reactor: SaveVocabularyViewReactor(
                coordinator: coordinator,
                groupID: nil,
                vocabularyID: nil,
                vocabularyService: VocabularyCoreDataService(
                    repository: VocabularyCoreDataRepository(
                        coreDataManager: CoreDataManager.shared
                    )
                )
            ),
            bodyView: SaveVocabularyView.instance()
        )
    }
}
