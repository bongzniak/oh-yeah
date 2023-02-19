//
//  Dependencies.swift
//  Config
//
//  Created by bongzniak on 2023/01/20.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: SwiftPackageManagerDependencies(
        [
            .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .upToNextMajor(from: "3.2.0")),
            .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0")),
            .remote(url: "https://github.com/RxSwiftCommunity/RxDataSources.git", requirement: .exact("5.0.2")),
            .remote(url: "https://github.com/RxSwiftCommunity/RxOptional", requirement: .upToNextMajor(from: "5.0.5")),
            .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
            .remote(url: "https://github.com/Moya/Moya.git", requirement: .upToNextMajor(from: "15.0.3")),
            .remote(url: "https://github.com/SnapKit/SnapKit", requirement: .upToNextMajor(from: "5.0.1")),
            .remote(url: "https://github.com/devxoul/Then", requirement: .upToNextMajor(from: "3.0.0")),
            .remote(url: "https://github.com/AliSoftware/Reusable.git", requirement: .upToNextMajor(from: "4.1.2")),
        ],
        productTypes: [
            "ReactorKit": .framework,
            "RxSwift": .framework,
            "RxCocoa": .framework,
            "RxDataSources": .framework,
            "RxOptional": .framework,
            "Moya": .framework,
            "Alamofire": .framework,
            "SnapKit": .framework,
            "Then": .framework,
            "Kingfisher": .framework,
            "Reusable": .framework,
        ]
//        baseSettings: .settings(configurations: [
//            .debug(name: "DEV"),
//            .release(name: "PROD")
//        ])
    ),
    platforms: [.iOS]
)
