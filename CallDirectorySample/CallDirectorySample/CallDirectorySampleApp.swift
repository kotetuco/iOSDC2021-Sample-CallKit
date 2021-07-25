//
//  CallDirectorySampleApp.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import SwiftUI
import SharedConstants
import UserDefaultsUtilities

@main
struct CallDirectorySampleApp: App {
    var body: some Scene {
        WindowGroup {
            let callDirectoryDriver = CallDirectoryDriver(identifier: "co.kotetu.example.displayname.calldirectory")
            let userDefaultsDriver = UserDefaultsDriver(appGroupID: AppConstants.appGroupID)
            SubmitView(viewModel: SubmitViewModel(callKitDriver: callDirectoryDriver, userDefaultsDriver: userDefaultsDriver))
        }
    }
}
