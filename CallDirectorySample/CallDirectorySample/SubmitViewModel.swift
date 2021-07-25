//
//  SubmitViewModel.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import Combine
import Foundation

enum AlertType {
    case invalidInput
    case submitError
    case disabled
}

final class SubmitViewModel: ObservableObject {
    @Published var phoneNumberText: String
    @Published var displayName: String

    @Published var submitEnabled: Bool = true
    @Published var isShowAlert: Bool = false
    @Published var alertStatus: AlertType?

    private let callKitDriver: CallDirectoryDriverInterface
    private var cancellables: [AnyCancellable] = []

    init(phoneNumber: String = "", displayName: String = "", callKitDriver: CallDirectoryDriverInterface) {
        self.phoneNumberText = phoneNumber
        self.displayName = displayName
        self.callKitDriver = callKitDriver
    }

    func callDirectopryStatus() {
        callKitDriver.status()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    // TODO: Error handling
                    break
                }
            } receiveValue: { [weak self] isEnabled in
                guard let self = self else { return }
                self.isShowAlert = !isEnabled
                self.submitEnabled = isEnabled
                self.alertStatus = .disabled
            }
            .store(in: &cancellables)
    }

    func submit() {
        guard !phoneNumberText.isEmpty, !displayName.isEmpty, let phoneNumber = Int(phoneNumberText) else {
            isShowAlert = true
            alertStatus = .invalidInput
            return
        }
        isShowAlert = false
        alertStatus = nil

        submitEnabled = false

        callKitDriver.register(phoneNumber: phoneNumber, displayName: displayName)
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .finished:
                    break
                case let .failure(error):
                    print(error)
                    self?.isShowAlert = true
                    self?.alertStatus = .invalidInput
                }
                self?.submitEnabled = true
            } receiveValue: {}
            .store(in: &cancellables)
    }
}
