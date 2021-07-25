//
//  CallDirectorySampleApp.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import SwiftUI

@main
struct CallDirectorySampleApp: App {
    var body: some Scene {
        WindowGroup {
            let driver = CallDirectoryDriver(identifier: "co.kotetu.example.displayname.calldirectory")
            SubmitView(viewModel: SubmitViewModel(callKitDriver: driver))
        }
    }
}
