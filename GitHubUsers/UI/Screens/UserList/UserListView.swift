//
//  UserListView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import SwiftUI

struct UserListView: View {
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
        .onChange(of: viewModel.searchCount) { _ in
            viewModel.updateSearchCount()
        }
    }
}

private extension UserListView {
    var userInfoContent: some View {
        NavigationView {
            VStack(spacing: 4) {
                inputContent
                ZStack {
                    userListContent
                    if viewModel.showIndicator {
                        indicatorContent
                    }
                    if viewModel.isShowEmpty {
                        emptyContent
                    }
                    settingContent
                }
            }
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
            viewModel.fetchUserList(false)
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
    
    var settingContent: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                menuContent
                Spacer().frame(width: 16, height: 16)
            }
            Spacer()
        }
    }
    
    var menuContent: some View {
        Menu(content: {
            Picker(selection: $viewModel.searchCount, content: {
                Text(SearchCount.ten.titleMessage).monospacedDigit()
                    .tag(SearchCount.ten)
                Text(SearchCount.twenty.titleMessage).monospacedDigit()
                    .tag(SearchCount.twenty)
                Text(SearchCount.thirty.titleMessage).monospacedDigit()
                    .tag(SearchCount.thirty)
                Text(SearchCount.fifty.titleMessage).monospacedDigit()
                    .tag(SearchCount.fifty)
            }, label: {
                Text(localString.empty())
            })
                .padding()
        }) {
            Image(systemName: viewModel.searchCount.titleImage)
                .resizable()
                .scaledToFit()
                .frame(width: 36)
                .foregroundColor(OpenColor.INDIGO.color(9))
                .shadow(radius: 3)
        }
    }
}

#if DEBUG
struct UserListView_Previews: PreviewProvider {
    static let viewModel = UserListViewModel.init(container: .preview)
    static var previews: some View {
        UserListView(viewModel: viewModel, apiAlertBag: viewModel.apiAlertBag)
    }
}
#endif
