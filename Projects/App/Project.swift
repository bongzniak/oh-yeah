//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by bongzniak on 2023/01/20.
//
import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "App"
private let iOSTargetVersion = "16.0"

let infoPlistPath: String = "Supporting Files/info.plist"

let project = Project.app(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    infoPlist: infoPlistPath,
    dependencies: [
        .project(target: "Core", path: .relativeToRoot("Projects/Core")),
        .project(target: "Splash", path: .relativeToRoot("Projects/Feature/Splash")),
    ]
)
