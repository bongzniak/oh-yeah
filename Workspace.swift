//
//  Workspace.swift
//  Config
//
//  Created by bongzniak on 2023/01/20.
//

import ProjectDescription

let workspace = Workspace(
    name: "oh-yeah",
    projects: [
        "Projects/App",
        "Projects/Core",
        "Projects/Feature/*",
        "Projects/UI/*"
    ]
)
