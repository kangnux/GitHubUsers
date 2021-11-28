//
//  GitHubUsersApp.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import SwiftUI

@main
struct GitHubUsersApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(viewModel: initRealViewModel())
                .environmentObject(TriggerObject())
        }
    }
    
    private func initRealViewModel() -> MainViewModel {
        let environment = AppEnvironment.bootstrap()
        return MainViewModel(container: environment.container)
    }
}
