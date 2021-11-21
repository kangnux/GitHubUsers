//
//  MainView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import SwiftUI

struct MainView: View {
    @Environment(\.scenePhase) private var scenePhase
    @ObservedObject private(set) var viewModel: MainViewModel
    
    var body: some View {
        ZStack {
            TabView(selection: $viewModel.tab) {
                searchViewContent.tag(MainViewTab.user)
                    .tabItem {
                        Image(systemName: "person.2.circle.fill")
                            .resizable()
                            .scaledToFit()
                        localString.user.text
                    }
                
                pinViewContent.tag(MainViewTab.pin)
                    .tabItem {
                        Image(systemName: "pin.circle")
                            .resizable()
                            .scaledToFit()
                        localString.pin.text
                    }
                thankViewContent.tag(MainViewTab.thank)
                    .tabItem {
                        Image(systemName: "flame.circle.fill")
                            .resizable()
                            .scaledToFit()
                        localString.thank.text
                    }
                
            }
            .accentColor(OpenColor.BLUE.color(8))
        }
    }
}

private extension MainView {
    var searchViewContent: some View {
        UserListView(viewModel: viewModel.userListViewModel,
                     apiAlertBag: viewModel.userListViewModel.apiAlertBag)
    }
    
    var pinViewContent: some View {
        PinView(viewModel: viewModel.pinViewModel, apiAlertBag: viewModel.pinViewModel.apiAlertBag)
    }
    
    var thankViewContent: some View {
        ThankView(viewModel: viewModel.thankViewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(viewModel: .init(container: .preview))
    }
}
