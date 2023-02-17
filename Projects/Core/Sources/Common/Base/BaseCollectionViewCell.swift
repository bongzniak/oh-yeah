// 
// BaseCollectionViewCell.swift
// 
// Created by bongzniak on 2022/06/07.
//

import UIKit

import RxSwift
import RxCocoa

open class BaseCollectionViewCell: UICollectionViewCell, BaseViewProtocol {

    // MARK: Properties
    
    public var disposeBag = DisposeBag()
    
    let tapGesture = UITapGestureRecognizer()
    let longPressGesture = UILongPressGestureRecognizer()
    
    // MARK: Initializing

    public override init(frame: CGRect) {
        super.init(frame: .zero)
        
        self.addGestureRecognizer(self.tapGesture)
        self.addGestureRecognizer(self.longPressGesture)
        
        self.contentView.isUserInteractionEnabled = true

        setupProperty()
        setupDelegate()
        setupHierarchy()
        setupLayout()
        setupBind()
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

    open func setupProperty() {}
    open func setupDelegate() {}
    open func setupHierarchy() {}
    open func setupLayout() {}
    open func setupBind() {}
}

extension Reactive where Base: BaseCollectionViewCell {
    public var throttleTap: Observable<Void> {
        return ControlEvent(events: base.tapGesture.rx.event.map { _ in () })
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    }
    
    public var throttleLongPress: Observable<Void> {
        return ControlEvent(events: base.longPressGesture.rx.event.map { _ in () })
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
    }
}
