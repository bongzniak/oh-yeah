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
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {

        // Action
        
    }
}

extension SaveVocabularyViewController {
    class func instance() -> SaveVocabularyViewController {
        SaveVocabularyViewController(
            reactor: SaveVocabularyViewReactor(),
            bodyView: SaveVocabularyView.instance()
        )
    }
}
