//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Bongzniak on 2023/01/20.
//
import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Design"
private let iOSTargetVersion = "16.0"

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UILaunchStoryboardName": "LaunchScreen",
    "UIAppFonts": [
        "Pretendard-Bold.otf",
        "Pretendard-Medium.otf",
        "Pretendard-Regular.otf",
    ]
]

let project = Project.frameworkWithDemoApp(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    infoPlist: infoPlist,
    dependencies: [
        .project(target: "Logger", path: .relativeToRoot("Projects/Core/Logger")),
        .external(name: "RxSwift")
    ]
)
