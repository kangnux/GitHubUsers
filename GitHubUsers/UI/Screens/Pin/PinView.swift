//
//  PinView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import SwiftUI

struct PinView: View {
    @EnvironmentObject var trigger: TriggerObject
    @Environment(\.colorScheme) var currentMode
    @ObservedObject private(set) var viewModel: PinViewModel
    @ObservedObject private(set) var apiAlertBag: ApiAlertBag
    @State private var selectedIndex = 0
    
    var body: some View {
        NavigationView{
            VStack {
                segmentContent
                ZStack {
                    if selectedIndex == 0 {
                        userListContent
                    } else {
                        repositoriesContent
                    }
                }
            }
            .navigationBarTitle(localString.pin(), displayMode: .inline)
            .background(currentMode == .light ?
                        GradientColor.lighBlue.gradient : GradientColor.darkBlue.gradient)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .edgesIgnoringSafeArea(.all)
        .alert(isPresented: $apiAlertBag.isPresented) {
            apiAlertBag.alert.alert
        }
        .onFirstAppear {
            viewModel.refresh = viewModel.refresh.toggle(type: .appear)
        }
        .onChange(of: trigger.refreshTrigger) { value in
            viewModel.refresh = value
        }
        .onChange(of: viewModel.refresh) { value in
            viewModel.refresh(type: value.type)
        }
    }
}

private extension PinView {
    var segmentContent: some View {
        Picker(localString.pin(),
               selection: $selectedIndex) {
            Text(localString.user()).tag(0)
            Text(localString.repositories()).tag(1)
        }
               .pickerStyle(SegmentedPickerStyle())
    }
    
    var userListContent: some View {
        ZStack {
            List(viewModel.userListInfo.list) { userInfo in
                NavigationLink(
                    destination: detailsView(userInfo: userInfo),
                    tag: userInfo.login,
                    selection: $viewModel.routingState.tapLogin) {
                        OmitUserView(viewModel: .init(container: viewModel.container, userInfo))
                    }
            }
            .listStyle(InsetGroupedListStyle())
            
            if viewModel.userListInfo.list.count == 0 {
                emptyContent
            }
        }
    }
    
    var repositoriesContent: some View {
        ZStack {
            ScrollView(.vertical) {
                Spacer()
                    .frame(height: 36)
                VStack(alignment: .leading) {
                    LazyVStack (alignment: .leading, spacing: 16) {
                        ForEach(viewModel.repositories) { repository in
                            NavigationLink(
                                destination: WebView(loadUrl: repository.htmlUrl)
                            ){
                                VStack {
                                    RepositoryView(viewModel: .init(container: viewModel.container, repository: repository))
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            if viewModel.repositories.count == 0 {
                emptyContent
            }
        }
        .background(currentMode == .dark ? Color.black : Color.white)
    }
    
    func detailsView(userInfo: UserEntity) -> some View {
        UserDetailView(viewModel: viewModel.userDetailViewModel)
    }
    
    var emptyContent: some View {
        VStack(alignment: .center) {
            Image(systemName: "doc.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(width: 48)
                .foregroundColor(OpenColor.BLUE.color(9))
            Text(localString.noPinItem())
                .font(.system(.title3, design: .rounded))
        }
    }
}

#if DEBUG
struct PinView_Previews: PreviewProvider {
    static let viewModel = PinViewModel(container: .preview)
    static var previews: some View {
        PinView(viewModel: viewModel, apiAlertBag: viewModel.apiAlertBag)
            .environmentObject(TriggerObject())
    }
}
#endif
