//
//  SubmitView.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import SwiftUI

struct SubmitView: View {
    @ObservedObject private var viewModel: SubmitViewModel

    init(viewModel: SubmitViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("Please input phone number and display name.")
                    .padding()

                TextField("Phone Number", text: $viewModel.phoneNumberText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.phonePad)
                    .padding()

                TextField("Display Name", text: $viewModel.displayName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Submit") {
                    UIApplication.shared.endEditing()
                    viewModel.submit()
                }
                .disabled(!viewModel.submitEnabled ||
                            viewModel.phoneNumberText.isEmpty ||
                            viewModel.displayName.isEmpty)
            }
            .navigationTitle("Call Directory Sample")
            .alert(isPresented: $viewModel.isShowAlert, content: {
                Alert(title: Text(alertMessage))
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.callDirectopryStatus()
        }
    }

    private var alertMessage: String {
        switch viewModel.alertStatus {
        case .disabled:
            return "Call directory extension is disabled."
        case .invalidInput:
            return "Invalid input."
        case .submitError:
            return "Submit error."
        case .none:
            return "Internal Error."
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
