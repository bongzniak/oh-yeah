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

import Core
import DesignSystem

final class VocabularyCell: BaseCollectionViewCell, ReactorKit.View, Reusable {
    
    typealias Reactor = VocabularyCellReactor
    
    private enum Metric {
        static let cornerRadius: CGFloat = 8
        static let padding: CGFloat = 8
        
        enum StarImageStackView {
            enum Margin {
                static let top: CGFloat = 10
            }
        }
        
        enum LabelStackView {
            enum Margin {
                static let top: CGFloat = 4
            }
            static let spacing: CGFloat = 6
        }
        
        enum GroupLabel {
            enum Margin {
                static let top: CGFloat = 16
            }
        }
        
        enum SpeackerButton {
            static let size: CGSize = CGSize(width: 44, height: 44)
        }
    }
    
    private enum Color {
        static let background: UIColor = .gray2
        static let spellingLabel: UIColor = .gray10
        static let descriptionLabel: UIColor = .blue6
        static let sentenceLabel: UIColor = .gray8
        static let groupLabel: UIColor = .gray6
    }
    
    private enum Font {
        static let spellingLabel: UIFont = .regular(ofSize: 16)
        static let descriptionLabel: UIFont = .bold(ofSize: 14)
        static let sentenceLabel: UIFont = .regular(ofSize: 12)
        static let groupLabel: UIFont = .regular(ofSize: 10)
    }
    
    private enum Image {
        static let speaker: UIImage? = UIImage(systemName: "speaker.wave.3")?
            .withTintColor(.gray10, renderingMode: .alwaysOriginal)
        static let speakerFill: UIImage? = UIImage(systemName: "speaker.wave.3.fill")?
            .withTintColor(.gray10, renderingMode: .alwaysOriginal)
        static let starFill: UIImage? = UIImage(systemName: "star.fill")?
            .withTintColor(.gray10, renderingMode: .alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .regular(ofSize: 8)))
    }
    
    private enum Localized {
        static let sectence: String = "예문"
        static let group: String = "필수 영단어 100"
    }
    
    // MARK: Properties
    
    private let ttsManager: TTSManager = TTSManager.shared
    
    // MARK: UI Views
    let starImageStackView: UIStackView = UIStackView().then {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .horizontal
        $0.spacing = 1
    }
    
    let labelStackView: UIStackView = UIStackView().then {
        $0.alignment = .fill
        $0.distribution = .fill
        $0.axis = .vertical
        $0.spacing = Metric.LabelStackView.spacing
    }
    let spellingLabel: UILabel = UILabel().then {
        $0.font = Font.spellingLabel
        $0.textColor = Color.spellingLabel
        $0.numberOfLines = 0
    }
    let descriptionLabel: UILabel = UILabel().then {
        $0.font = Font.descriptionLabel
        $0.textColor = Color.descriptionLabel
        $0.numberOfLines = 0
    }
    let sentenceLabel: UILabel = UILabel().then {
        $0.font = Font.sentenceLabel
        $0.textColor = Color.sentenceLabel
        $0.numberOfLines = 0
    }
    
    let groupLabel: UILabel = UILabel().then {
        $0.text = Localized.group
        $0.font = Font.groupLabel
        $0.textColor = Color.groupLabel
    }
    let speakerButton: UIButton = UIButton().then {
        $0.setImage(Image.speaker, for: .normal)
        $0.setImage(Image.speakerFill, for: .selected)
    }
    
    // MARK: Initializing
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        removeStartImageStackViewSubviews()
    }
    
    // MARK: UI Setup
    
    override func addViews() {
        super.addViews()
        
        contentView.addSubview(starImageStackView)
        
        labelStackView.addArrangedSubview(spellingLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        labelStackView.addArrangedSubview(sentenceLabel)
        contentView.addSubview(labelStackView)
        
        contentView.addSubview(groupLabel)
        contentView.addSubview(speakerButton)
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.layer.cornerRadius = Metric.cornerRadius
        contentView.backgroundColor = Color.background
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        starImageStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Metric.StarImageStackView.Margin.top)
            $0.leading.equalToSuperview().inset(Metric.padding)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(starImageStackView.snp.bottom).offset(Metric.LabelStackView.Margin.top)
            $0.leading.trailing.equalToSuperview().inset(Metric.padding)
        }
        groupLabel.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(Metric.GroupLabel.Margin.top)
            $0.leading.equalTo(spellingLabel)
        }
        speakerButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview()
            $0.size.equalTo(Metric.SpeackerButton.size)
        }
    }
    
    // MARK: Binding
    
    func bind(reactor: Reactor) {
        // Action
        bindAction(reactor: reactor)
        
        // State
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: Reactor) {
        speakerButton.rx.tap
            .map {
                reactor.currentState.vocabulary.spelling
            }
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, spelling in
                owner.startTTS(spelling)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: Reactor) {
        
        reactor.state.map { $0.vocabulary.spelling }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(spellingLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.vocabulary.description }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowDescription }
            .distinctUntilChanged()
            .map { !$0 }
            .asDriver(onErrorJustReturn: true)
            .drive(descriptionLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.vocabulary.sentence }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(sentenceLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isShowSentence }
            .distinctUntilChanged()
            .map { !$0 }
            .asDriver(onErrorJustReturn: true)
            .drive(sentenceLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.vocabulary.starCount }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, starCound in
                owner.removeStartImageStackViewSubviews()
                owner.addArrangedStarImageStackViews(count: starCound)
            }
            .disposed(by: disposeBag)
    }
    
    private func removeStartImageStackViewSubviews() {
        for view in starImageStackView.subviews {
            starImageStackView.removeArrangedSubview(view)
        }
    }
    
    private func addArrangedStarImageStackViews(count: Int) {
        for _ in 0...count {
            starImageStackView.addArrangedSubview(makeStartImageView())
        }
    }

    private func makeStartImageView() -> UIImageView {
        UIImageView(image: Image.starFill)
    }
}


// MARK: TTS

extension VocabularyCell {
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

// MARK: TTSManagerDelegate

extension VocabularyCell: TTSManagerDelegate {
    func speechDidFinish() {
        stopTTS()
    }
}

// MARK: Size

extension VocabularyCell {
    class func size(
        width: CGFloat,
        vocabulary: Vocabulary
    ) -> CGSize {
        let contentWidth = width - Metric.padding
        var height: CGFloat = 0
        
        // StarStackView
        
        height += Metric.StarImageStackView.Margin.top
        height += Image.starFill?.size.height ?? 0
        
        // SpellingLabel
        
        height += Metric.LabelStackView.Margin.top
        height += vocabulary.spelling.textSize(
            font: Font.spellingLabel,
            width: contentWidth
        ).height
        
        
        if vocabulary.isExpand {
            // DescriptionLabel

            if !vocabulary.description.isEmpty {
                height += Metric.LabelStackView.spacing
                height += vocabulary.description.textSize(
                    font: Font.descriptionLabel,
                    width: contentWidth
                ).height
            }
            
            // SentenceLabel
            
            if !vocabulary.sentence.isEmpty {
                height += Metric.LabelStackView.spacing
                height += vocabulary.sentence.textSize(
                    font: Font.sentenceLabel,
                    width: contentWidth
                ).height
            }
        }
        
        // GroupLabel
        
        height += Metric.GroupLabel.Margin.top
        height += vocabulary.group.textSize(
            font: Font.groupLabel,
            width: contentWidth
        ).height
        
        // Bottom padding
        
        height += Metric.padding
        
        return CGSize(width: width, height: height)
    }
}
