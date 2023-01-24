//
//  VocabularyCell.swift
//  VocabularyTests
//
//  Created by bongzniak on 2023/01/20.
//  Copyright © 2023 com.bongzniak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import Reusable

import Common

final class VocabularyCell: BaseCollectionViewCell, ReactorKit.View, Reusable {
    
    typealias Reactor = VocabularyCellReactor
    
    private enum Metric {
        static let height: CGFloat = 90
    }
    
    private enum Color {
    }
    
    private enum Font {
    }
    
    private enum Image {
        static let speaker: UIImage? = UIImage(systemName: "speaker.wave.3")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        static let speakerFill: UIImage? = UIImage(systemName: "speaker.wave.3.fill")?
            .withTintColor(.blue, renderingMode: .alwaysOriginal)
    }
        
    // MARK: Properties
    
    private let ttsManager: TTSManager = TTSManager.shared
        
    // MARK: UI Views
    
    let spellingLabel: UILabel = UILabel().then {
        $0.text = "Apple"
    }
    let descriptionLabel: UILabel = UILabel().then {
        $0.text = "사과"
    }
    let groupLabel: UILabel = UILabel().then {
        $0.text = "필수 영단어 100"
    }
    let speakerButton: UIButton = UIButton().then {
        $0.setImage(Image.speaker, for: .normal)
        $0.setImage(Image.speakerFill, for: .selected)
    }
    
    // MARK: Initializing
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: UI Setup
    
     override func addViews() {
        super.addViews()
        
        contentView.addSubview(spellingLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(groupLabel)
        contentView.addSubview(speakerButton)
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = .gray
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        spellingLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(8)
        }
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(spellingLabel)
            $0.top.equalTo(spellingLabel.snp.bottom).offset(8)
        }
        groupLabel.snp.makeConstraints {
            $0.leading.equalTo(spellingLabel)
            $0.bottom.equalToSuperview().inset(8)
        }
        speakerButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        
        // Action
        speakerButton.rx.tap
            .asDriver(onErrorJustReturn: ())
            .drive { [weak self] _ in
                self?.startTTS("Apple")
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: Binding
    func bind(reactor: Reactor) {
        
        // Action
        
        // State
        
        // View
    }
    
    private func startTTS(_ spelling: String) {
        guard !ttsManager.isPlaying() else { return }
        
        self.speakerButton.isSelected = true
        
        self.ttsManager.delegate = self
        self.ttsManager.play(spelling)
    }
    
    private func stopTTS() {
        speakerButton.isSelected = false
        
        ttsManager.delegate = nil
    }
}

extension VocabularyCell: TTSManagerDelegate {
    func speechDidFinish() {
        stopTTS()
    }
}

extension VocabularyCell {
    class func size(width: CGFloat) -> CGSize {
        CGSize(width: width, height: Metric.height)
    }
}
