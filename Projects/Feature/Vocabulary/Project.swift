//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Bongzniak on 2023/01/20.
//
import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Vocabulary"
private let iOSTargetVersion = "16.0"

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
]

let project = Project.frameworkWithDemoApp(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    infoPlist: infoPlist,
    dependencies: [
        .project(target: "Core", path: .relativeToRoot("Projects/Core")),
        .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem")),
        .project(target: "Group", path: .relativeToRoot("Projects/Feature/Group")),
        .project(target: "Cocoapods", path: .relativeToRoot("Projects/Cocoapods")),
        .external(name: "ReactorKit"),
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxDataSources"),
        .external(name: "RxOptional"),
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "Reusable"),
    ]
)
