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
        static let height: CGFloat = 100
        
        static let speakerButton: CGSize = CGSize(width: 44, height: 44)
    }
    
    private enum Color {
        static let background: UIColor = .gray2
        enum SentenceButton {
            static let background: UIColor = .blue4
            // static let text: UIColor = .white
            static let text: UIColor = .blue4
        }
        static let spellingLabel: UIColor = .gray10
        static let descriptionLabel: UIColor = .gray8
        static let groupLabel: UIColor = .gray6
    }
    
    private enum Font {
        static let sectenceButton: UIFont = .regular(ofSize: 14)
        static let spellingLabel: UIFont = .regular(ofSize: 16)
        static let descriptionLabel: UIFont = .regular(ofSize: 12)
        static let groupLabel: UIFont = .regular(ofSize: 10)
    }
    
    private enum Image {
        static let speaker: UIImage? = UIImage(systemName: "speaker.wave.3")?
            .withTintColor(.gray10, renderingMode: .alwaysOriginal)
        static let speakerFill: UIImage? = UIImage(systemName: "speaker.wave.3.fill")?
            .withTintColor(.gray10, renderingMode: .alwaysOriginal)
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
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 1
    }
    let sentenceButton: UIButton = UIButton().then {
        $0.titleLabel?.font = Font.sectenceButton
        $0.setTitle(Localized.sectence, for: .normal)
        $0.setTitleColor(Color.SentenceButton.text, for: .normal)
        
        $0.configuration?.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        
//        $0.layer.borderWidth = 1
//        $0.layer.cornerRadius = 4
//        $0.layer.borderColor = UIColor.gray3.cgColor
//        $0.backgroundColor = Color.SentenceButton.background
    }
    let spellingLabel: UILabel = UILabel().then {
        $0.font = Font.spellingLabel
        $0.textColor = Color.spellingLabel
    }
    let descriptionLabel: UILabel = UILabel().then {
        $0.font = Font.descriptionLabel
        $0.textColor = Color.descriptionLabel
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
        
        for view in starImageStackView.subviews {
            starImageStackView.removeArrangedSubview(view)
        }
    }
    
    // MARK: UI Setup
    
    override func addViews() {
        super.addViews()
        
        contentView.addSubview(starImageStackView)
        contentView.addSubview(sentenceButton)
        contentView.addSubview(spellingLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(groupLabel)
        contentView.addSubview(speakerButton)
    }
    
    override func setupViews() {
        super.setupViews()
        
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = Color.background
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        starImageStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(8)
        }
        sentenceButton.snp.makeConstraints {
            $0.top.equalTo(starImageStackView)
            $0.trailing.equalToSuperview().inset(8)
        }
        
        spellingLabel.snp.makeConstraints {
            $0.top.equalTo(starImageStackView.snp.bottom).offset(8)
            $0.leading.equalToSuperview().inset(8)
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
            $0.size.equalTo(Metric.speakerButton)
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
            .asDriver(onErrorJustReturn: "")
            .drive(spellingLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.vocabulary.description }
            .asDriver(onErrorJustReturn: "")
            .drive(descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.vocabulary.starCount }
            .asDriver(onErrorJustReturn: 0)
            .filter { $0 > 1 }
            .drive(onNext: { [weak self] starCount in
                guard let self = self else { return }
                
                for view in self.starImageStackView.subviews {
                    self.starImageStackView.removeArrangedSubview(view)
                }
                for _ in 0...starCount {
                    self.starImageStackView.addArrangedSubview(self.makeStartImageView())
                }
            })
            .disposed(by: disposeBag)
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
    
    private func makeStartImageView() -> UIImageView {
        UIImageView(
            image: UIImage(systemName: "star.fill")?
                .withTintColor(.gray10, renderingMode: .alwaysOriginal)
                .withConfiguration(UIImage.SymbolConfiguration(font: .regular(ofSize: 8)))
        )
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
