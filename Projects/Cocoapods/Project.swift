//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Bongzniak on 2023/01/20.
//
import ProjectDescription
import ProjectDescriptionHelpers

private let projectName = "Cocoapods"
private let iOSTargetVersion = "16.0"

let project = Project.framework(
    name: projectName,
    platform: .iOS,
    iOSTargetVersion: iOSTargetVersion,
    dependencies: []
)
