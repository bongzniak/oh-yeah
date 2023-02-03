// 
// BaseCollectionViewCell.swift
// 
// Created by bongzniak on 2022/06/07.
//

import UIKit

import RxSwift
import RxCocoa

open class BaseCollectionViewCell: UICollectionViewCell {

    // MARK: Properties
    
    public var disposeBag = DisposeBag()
    
    public let tapGesture = UITapGestureRecognizer()

    // MARK: Initializing

    public override init(frame: CGRect) {
        super.init(frame: .zero)

        self.addViews()
        self.setupViews()
        self.setupConstraints()
        
        self.addGestureRecognizer(self.tapGesture)
        self.contentView.isUserInteractionEnabled = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        logger.verbose("DEINIT: \(String(describing: type(of: self)))")
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }
    
    // MARK: UI Setup

    open func addViews() {
    }

    open func setupViews() {
    }

    open func setupConstraints() {
    }
}

extension Reactive where Base: BaseCollectionViewCell {
    public var tap: ControlEvent<Void> {
        return ControlEvent(events: base.tapGesture.rx.event.map { _ in () })
    }
}
