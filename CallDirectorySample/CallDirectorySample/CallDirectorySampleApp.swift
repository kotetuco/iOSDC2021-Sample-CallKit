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
            SubmitView(viewModel: SubmitViewModel(callKitDriver: try! callDirectoryDriver(),
                                                  userDefaultsDriver: try! userDefaultsDriver()))
        }
    }

    private func callDirectoryDriver() throws -> CallDirectoryDriverInterface {
        guard let bundleIdentifier = Bundle.main.object(forInfoDictionaryKey: "CallDirectoryExtensionBundleIdentifier") as? String else {
            throw InstantiateError.bundleIdentiferNotFound
        }
        return CallDirectoryDriver(bundleIdentifier: bundleIdentifier)
    }

    private func userDefaultsDriver() throws -> UserDefaultsDriverInterface {
        guard let appGroupID = Bundle.main.object(forInfoDictionaryKey: "AppGroupID") as? String else {
            throw InstantiateError.appGroupIDNotFound
        }
        return UserDefaultsDriver(suiteName: appGroupID)
    }

    enum InstantiateError: Error {
        case bundleIdentiferNotFound
        case appGroupIDNotFound
    }
}
