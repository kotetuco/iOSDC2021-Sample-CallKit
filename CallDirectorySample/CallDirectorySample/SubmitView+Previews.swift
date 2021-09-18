//
//  SubmitView+Previews.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import Combine
import CoreModule
import SwiftUI

struct SubmitView_Previews: PreviewProvider {
    static var previews: some View {
        SubmitView(viewModel: SubmitViewModel(callKitDriver: CallDirectoryDriverDummy(),
                                              userDefaultsDriver: UserDefaultsDriverDummy()))
    }

    final class CallDirectoryDriverDummy: CallDirectoryDriverInterface {
        func status() -> Future<Bool, Error> {
            Future<Bool, Error> { promise in
                promise(.success(true))
            }
        }

        func register(phoneNumber: Int, displayName: String) -> Future<Void, Error> {
            Future<Void, Error> { promise in
                promise(.success(()))
            }
        }
    }

    final class UserDefaultsDriverDummy: UserDefaultsDriverInterface {
        func set(string: String, forKey: String) {}
        func string(forKey: String) -> String? { nil }
    }
}
