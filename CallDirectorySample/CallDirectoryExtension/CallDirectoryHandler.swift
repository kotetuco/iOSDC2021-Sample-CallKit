//
//  CallDirectoryHandler.swift
//  CallDirectoryExtension
//
//  Created by kotetu on 2021/07/25.
//

import Foundation
import CallKit
import CoreModule

final class CallDirectoryHandler: CXCallDirectoryProvider {
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        printToConsole("Start.")
        context.delegate = self

        guard let appGroupID = appGroupID else {
            context.cancelRequest(withError: CallDirectoryError.gettingAppGroupIDIsFailed)
            return
        }

        let userDefaultsDriver = UserDefaultsDriver(suiteName: appGroupID)

        guard let phoneNumberText = userDefaultsDriver.string(forKey: UserDefaultsKeys.phoneNumber.rawValue),
              let phoneNumber = CXCallDirectoryPhoneNumber(phoneNumberText),
              let displayName = userDefaultsDriver.string(forKey: UserDefaultsKeys.displayName.rawValue) else {
            context.cancelRequest(withError: CallDirectoryError.invalidParameter)
            return
        }

        // カスタムエラーを意図的に出したい場合はtrueにしてください。
        #if false
        context.cancelRequest(withError: CallDirectoryError.invalidParameter)
        return
        #endif

        printToConsole("phoneNumber:\(phoneNumberText), displayName:\(displayName)")

        context.removeAllIdentificationEntries()
        context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: displayName)
        // 重複エラーを意図的に出したい場合はtrueにしてください。
        #if false
        context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: displayName)
        #endif

        // メモリサイズオーバーエラーを意図的に出したい場合はtrueにしてください。
        #if false
        let tooMatchMemory = Data(count: 1000_000_000)
        _ = tooMatchMemory.base64EncodedString()
        #endif

        context.completeRequest()
        printToConsole("Complete.")
    }

    private var appGroupID: String? {
        Bundle.main.object(forInfoDictionaryKey: "AppGroupID") as? String
    }

    private func printToConsole(_ text: String) {
        #if DEBUG
        NSLog("[Debug]:" + text)
        #endif
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
