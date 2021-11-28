//
//  UserListView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import SwiftUI

struct UserListView: View {
    @Environment(\.colorScheme) var currentMode
    @EnvironmentObject var trigger: TriggerObject
    @ObservedObject private(set) var viewModel: UserListViewModel
    @ObservedObject private(set) var apiAlertBag: ApiAlertBag
    @State private var isEditing = false
    @State private var isShowSetting = false
    @State private var isShowCancel = false
    
    var body: some View {
        ZStack {
            userInfoContent
        }
        .edgesIgnoringSafeArea(.all)
        
        .alert(isPresented: $apiAlertBag.isPresented) {
            apiAlertBag.alert.alert
        }
        .onFirstAppear {
            viewModel.fetchSettting()
        }
        .onChange(of: trigger.refreshTrigger) { value in
            viewModel.refresh = value
        }
        .onChange(of: viewModel.refresh) { value in
            viewModel.refresh(type: value.type)
        }
    }
}

private extension UserListView {
    var userInfoContent: some View {
        NavigationView {
            VStack(spacing: 4) {
                inputContent
                TagView(tags: $viewModel.tags,
                        searchKey: $viewModel.searchKey)
                    .frame(height: viewModel.tags.count > 0 ? 48 : 8)
                ZStack {
                    userListContent
                    if viewModel.showIndicator {
                        indicatorContent
                    }
                    if viewModel.isShowEmpty {
                        emptyContent
                    }
                }
            }
            .background(currentMode == .light ?
                        GradientColor.lighBlue.gradient : GradientColor.darkBlue.gradient)
            .navigationBarHidden(isShowCancel)
            .navigationTitle(localString.user())
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var userListContent: some View {
        List(viewModel.userListInfo.list) { userInfo in
            NavigationLink(
                destination: detailsView(userInfo: userInfo),
                tag: userInfo.login,
                selection: $viewModel.routingState.tapLogin) {
                    OmitUserView(viewModel: .init(container: viewModel.container, userInfo))
                }
        }
        .listStyle(InsetGroupedListStyle())
        .refreshable {
            viewModel.refresh = viewModel.refresh.toggle(type: .pull)
        }
    }
    
    var inputContent: some View {
        SearchBarView(searchKey: $viewModel.searchKey,
                      isShowCancel: $isShowCancel)
    }
    
    func detailsView(userInfo: UserEntity) -> some View {
        UserDetailView(viewModel: .init(container: viewModel.container,
                                        userInfo:userInfo))
    }
    
    var emptyContent: some View {
        VStack(alignment: .center) {
            Image(systemName: "magnifyingglass")
                .resizable()
                .scaledToFit()
                .frame(width: 36)
                .foregroundColor(OpenColor.RED.color(9))
                .shadow(radius: 3)
            Text(localString.noResults(viewModel.searchKey.debugDescription))
                .font(.system(.title3, design: .rounded))
        }
    }
    
    var indicatorContent: some View {
        ZStack{
            Rectangle()
                .foregroundColor(Color.black.opacity(0.30))
            VStack {
                IndicatorView()
                    .frame(width: 48, height: 48)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#if DEBUG
struct UserListView_Previews: PreviewProvider {
    static let viewModel = UserListViewModel.init(container: .preview)
    static var previews: some View {
        UserListView(viewModel: viewModel, apiAlertBag: viewModel.apiAlertBag)
            .environmentObject(TriggerObject())
    }
}
#endif
