//
//  CallDirectoryDriver.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import CallKit
import CallDirectoryUtils
import Combine
import Foundation

final class CallDirectoryDriver: CallDirectoryDriverInterface {
    public enum StatusError: Error {
        case internalError
        case unknownStatus
    }

    public enum RegisterError: Error {
        case internalError
        case loadingInterrupted
        case duplicateEntries
        case notCompatibleError
        case invalidInput
        case unknownError
    }

    private let identifier: String

    init(identifier: String) {
        self.identifier = identifier
    }

    func status() -> Future<Bool, Error> {
        return Future<Bool, Error> { [weak self] promise in
            guard let identifier = self?.identifier, !identifier.isEmpty else {
                promise(.failure(StatusError.internalError))
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
                    promise(.failure(StatusError.unknownStatus))
                @unknown default:
                    promise(.failure(StatusError.internalError))
                }
            }
        }
    }

    func register(phoneNumber: Int, displayName: String) -> Future<Void, Error> {
        return Future<Void, Error> { [weak self] promise in
            guard let identifier = self?.identifier, !identifier.isEmpty else {
                promise(.failure(RegisterError.internalError))
                return
            }

            CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: identifier) { error in
                guard let relaodError = error else {
                    promise(.success(()))
                    return
                }

                guard let callDirectoryManagerError = relaodError as? CXErrorCodeCallDirectoryManagerError else {
                    promise(.failure(RegisterError.unknownError))
                    return
                }

                switch callDirectoryManagerError.code {
                case .loadingInterrupted:
                    // メモリ上限超過エラー
                    promise(.failure(RegisterError.loadingInterrupted))
                case .duplicateEntries:
                    // 電話番号の二重登録
                    promise(.failure(RegisterError.duplicateEntries))
                default:
                    promise(.failure(RegisterError.notCompatibleError))
                }
            }
        }
    }
}
