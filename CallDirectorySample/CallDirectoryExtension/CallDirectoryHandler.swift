//
//  CallDirectoryHandler.swift
//  CallDirectoryExtension
//
//  Created by kotetu on 2021/07/25.
//

import Foundation
import CallKit
import SharedConstants
import UserDefaultsUtilities

final class CallDirectoryHandler: CXCallDirectoryProvider {
    enum CallDirectoryUserError: Error {
        case invalidParameter
    }

    private let userDefaultsDriver = UserDefaultsDriver(appGroupID: AppConstants.appGroupID)

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        guard let phoneNumberText = userDefaultsDriver.string(forKey: UserDefaultsKeys.phoneNumber.rawValue),
              let phoneNumber = CXCallDirectoryPhoneNumber(phoneNumberText),
              let displayName = userDefaultsDriver.string(forKey: UserDefaultsKeys.displayName.rawValue) else {
            context.cancelRequest(withError: CallDirectoryUserError.invalidParameter)
            return
        }

        context.removeAllIdentificationEntries()
        context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: displayName)

        context.completeRequest()
    }
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occurred while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }
}
