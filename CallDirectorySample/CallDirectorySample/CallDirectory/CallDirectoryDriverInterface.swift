//
//  CallDirectoryDriverInterface.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import Combine
import Foundation

protocol CallDirectoryDriverInterface {
    func status() -> Future<Bool, Error>
    func register(phoneNumber: Int, displayName: String) -> Future<Void, Error>
}
