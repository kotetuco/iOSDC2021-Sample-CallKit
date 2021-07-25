//
//  CallDirectoryDriver.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import CallKit
import Combine
import Foundation

final class CallDirectoryDriver: CallDirectoryDriverInterface {
    public enum CallDirectoryDriverError: Error {
        case internalError
        case unknownStatus
    }

    private let identifier: String

    init(identifier: String) {
        self.identifier = identifier
    }

    func status() -> Future<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let identifier = self?.identifier, !identifier.isEmpty else {
                promise(.failure(CallDirectoryDriverError.internalError))
                return
            }
            CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(withIdentifier: identifier) { status, getStatusError in
                if let error = getStatusError {
                    promise(.failure(error))
                    return
                }
                switch status {
                case .enabled:
                    promise(.success(true))
                case .disabled:
                    promise(.success(false))
                case .unknown:
                    promise(.failure(CallDirectoryDriverError.unknownStatus))
                @unknown default:
                    promise(.failure(CallDirectoryDriverError.internalError))
                }
            }
        }
    }

    func register(phoneNumber: Int, displayName: String) -> Future<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let identifier = self?.identifier, !identifier.isEmpty else {
                promise(.failure(CallDirectoryDriverError.internalError))
                return
            }
            CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: identifier) { reloadError in
                if let error = reloadError {
                    promise(.failure(error))
                    return
                }
                promise(.success(()))
            }
        }
    }
}
