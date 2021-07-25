//
//  SubmitView+Previews.swift
//  CallDirectorySample
//
//  Created by kotetu on 2021/07/25.
//

import SharedConstants
import SwiftUI
import UserDefaultsUtilities

struct SubmitView_Previews: PreviewProvider {
    static var previews: some View {
        // TODO: Use Dummy Driver
        let callDirectoryDriver = CallDirectoryDriver(identifier: "co.kotetu.example.displayname.calldirectory")
        let userDefaultsDriver = UserDefaultsDriver(appGroupID: AppConstants.appGroupID)
        SubmitView(viewModel: SubmitViewModel(callKitDriver: callDirectoryDriver, userDefaultsDriver: userDefaultsDriver))
    }
}
