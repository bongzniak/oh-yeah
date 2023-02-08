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

final class SaveVocabularyViewController: BaseViewController, View {
    
    typealias Reactor = SaveVocabularyViewReactor
    
    // MARK: Properties

    weak var coordinator: SaveVocabularyCoordinator?
    
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
        self.navigationItem.leftBarButtonItem = closeBarButton
        self.navigationItem.rightBarButtonItem = saveBarButton
    }
    
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        closeBarButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.navigationController?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        saveBarButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                owner.reactor?.action.onNext(.save)
            }
            .disposed(by: disposeBag)
        
        bodyView.searchSententButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { owner, _ in
                let spelling = owner.bodyView.spellingTextView.text
                guard owner.isSearchButtonEnable(spelling) else {
                    // TODO: Show toast >> 단어를 입력 후 눌러주세요
                    return
                }
                owner.searchSentence(spelling: spelling)
            }
            .disposed(by: bodyView.disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        reactor.state.map { $0.spelling }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(bodyView.spellingTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.description }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(bodyView.descriptionTextView.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.sentence }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(bodyView.sentenceTextView.rx.text)
            .disposed(by: disposeBag)
        
        bodyView.spellingTextView.rx.text
            .map { $0 ?? "" }
            .map { self.isSearchButtonEnable($0) }
            .asDriver(onErrorJustReturn: false)
            .drive(bodyView.searchSententButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        bodyView.spellingTextView.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .map { $0 ?? "" }
            .drive(with: self) { owner, text in
                owner.reactor?.action.onNext(.onChangedSpelling(text))
            }
            .disposed(by: disposeBag)
        
        bodyView.descriptionTextView.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .map { $0 ?? "" }
            .drive(with: self) { owner, text in
                owner.reactor?.action.onNext(.onChangedDescription(text))
            }
            .disposed(by: disposeBag)
        
        bodyView.sentenceTextView.rx.text
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .map { $0 ?? "" }
            .drive(with: self) { owner, text in
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
    class func instance() -> SaveVocabularyViewController {
        SaveVocabularyViewController(
            reactor: SaveVocabularyViewReactor(
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
