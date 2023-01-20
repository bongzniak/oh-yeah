//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Bongzniak on 2023/01/20.
//
import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Logger"
private let iOSTargetVersion = "16.0"

let project = Project.framework(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    dependencies: [
        .external(name: "CocoaLumberjack"),
        .external(name: "CocoaLumberjackSwift")
    ]
)
