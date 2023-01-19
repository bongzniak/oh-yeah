//
//  Dependencies.swift
//  Config
//
//  Created by bongzniak on 2023/01/20.
//

import ProjectDescription

let dependencies = Dependencies(
    carthage: nil,
    swiftPackageManager: SwiftPackageManagerDependencies(
        [],
        baseSettings: .settings(configurations: [
            .debug(name: "DEV"),
            .release(name: "PROD")
        ])
    ),
    platforms: [.iOS]
)
