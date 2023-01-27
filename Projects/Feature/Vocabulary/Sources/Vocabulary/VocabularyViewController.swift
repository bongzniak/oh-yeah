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

// Module
import Common

final class VocabularyViewController: BaseViewController, View {
    
    typealias Reactor = VocabularyViewReactor
    
    // MARK: Properties

    private weak var coordinator: VocabularyCoordinator?
    
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
    }
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {

        // Action
        
        self.bodyView.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        
        reactor.state.map {
                $0.sections
            }
            .asDriver(onErrorJustReturn: [])
            .drive(with: self) { owner, sections in
                owner.bodyView.sections.accept(sections)
            }
            .disposed(by: disposeBag)
            
        reactor.pulse(\.$isRefreshing)
            .asDriver(onErrorJustReturn: false)
            .drive(bodyView.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
    }
}

extension VocabularyViewController {
    class func instance() -> VocabularyViewController {
        VocabularyViewController(
            reactor: VocabularyViewReactor(),
            bodyView: VocabularyView.instance()
        )
    }
}
