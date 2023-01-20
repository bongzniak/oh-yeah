// 
// BaseCollectionViewCell.swift
// 
// Created by bongzniak on 2022/06/07.
//

import Logger

import UIKit

import RxSwift

open class BaseCollectionViewCell: UICollectionViewCell {


    var disposeBag = DisposeBag()

    // MARK: Initializing

    override init(frame: CGRect) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false

        self.addViews()
        self.setupViews()
        self.setupConstraints()
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
