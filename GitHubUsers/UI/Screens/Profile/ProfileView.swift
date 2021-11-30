//
//  ProfileView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/23.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private(set) var viewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            NavigationView {
                GeometryReader { proxy in
                    VStack(alignment: .leading) {
                        configSearchCountContent
                        Divider()
                        authorizeInfoContent(width: proxy.size.width / 2)
                        Divider()
                        if viewModel.authorizeState == .valid {
                            ScrollView(.vertical) {
                                detailInfoContent
                                Divider()
                                if viewModel.repositories.count > 0 {
                                    repositoriesContent
                                } else if (viewModel.repositories.count == 0 &&
                                           !viewModel.showIndicator) {
                                    emptyRepositoryContent
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .navigationTitle(localString.profile())
            }
            .navigationViewStyle(StackNavigationViewStyle())
            if viewModel.showIndicator {
                GradientIndicatorView()
            }
        }
        .alert(isPresented: $viewModel.authInfo.showAlert) {
            Alert(title: Text(viewModel.authInfo.state.title),
                  dismissButton: .default(localString.close.text,
                                          action: {}))
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: viewModel.count) { _ in
            viewModel.updateSearchCount()
        }
        .onAppear {
            viewModel.fetchAccessToken()
            viewModel.fetchSettting()
        }
    }
}

private extension ProfileView {
    func authorizeInfoContent(width: CGFloat) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                authorizeContent(width: width)
                Spacer()
                Circle()
                    .foregroundColor(viewModel.authorizeState.color)
                    .frame(width: 20, height: 20)
                Spacer()
            }
            .frame(height: 40)
            Text(localString.lastDate(viewModel.lastDate))
                .font(.system(.footnote, design: .rounded))
                .foregroundColor(Color.gray)
        }
    }
    
    func authorizeContent(width: CGFloat) -> some View {
        NavigationLink(
            destination: LoginWebView(viewModel: .init(container: viewModel.container)),
            isActive: $viewModel.isShowLoginView) {
                Text(localString.authorize())
                    .font(.system(.title3, design: .rounded))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .frame(width: width)
                    .foregroundColor(OpenColor.BLUE.color(9))
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(OpenColor.GRAY.color(1))
                            .shadow(radius: 2)
                    )
            }
    }
    
    var configSearchCountContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewModel.count.titleMessage)
                .font(.system(.headline, design: .rounded))
                .foregroundColor(OpenColor.GRAY.color(6))
            Picker(selection: $viewModel.count, content: {
                Text(SearchCount.ten.title).monospacedDigit()
                    .tag(SearchCount.ten)
                Text(SearchCount.twenty.title).monospacedDigit()
                    .tag(SearchCount.twenty)
                Text(SearchCount.thirty.title).monospacedDigit()
                    .tag(SearchCount.thirty)
                Text(SearchCount.fifty.title).monospacedDigit()
                    .tag(SearchCount.fifty)
            }, label: {
                Text(localString.empty())
            })
                .padding(.vertical)
                .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    var detailInfoContent: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                statusContent
                if !viewModel.userInfo.bio.isEmpty {
                    bioContent
                }
                Divider()
                if !viewModel.userInfo.email.isEmpty {
                    mailContent
                }
                if !viewModel.userInfo.location.isEmpty {
                    locationContent
                }
                followContent
            }
            .padding(.vertical, 8)
            
            Divider()
        }
        .padding([.leading, .bottom], 16)
    }
    
    var emptyRepositoryContent: some View {
        VStack {
            Spacer()
            
            localString.noRepository.text
                .font(.system(.title2, design: .default))
                .foregroundColor(OpenColor.GRAY.color(6))
        }
    }
    
    var repositoriesContent: some View {
        VStack(alignment: .leading) {
            Text(localString.repositories())
                .font(.system(.title, design: .rounded).bold())
                .padding(.leading, 8)
            LazyVStack (alignment: .leading, spacing: 16) {
                ForEach(viewModel.repositories) { repository in
                    NavigationLink(
                        destination: WebView(loadUrl: repository.htmlUrl)
                    ){
                        VStack {
                            RepositoryView(
                                viewModel: .init(container: viewModel.container, repository: repository))
                        }
                    }
                }
            }
        }
    }
    
    var statusContent: some View {
        HStack(spacing: 0){
            imageContent
            Spacer().frame(width: 16)
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.userInfo.name).font(.title2.bold())
                HStack {
                    Text(viewModel.userInfo.login).font(.subheadline)
                    Spacer()
                }
            }
            Spacer()
        }
    }
    
    var imageContent: some View {
        AsyncImage(url: URL(string: viewModel.userInfo.avatarUrl)) { image in
            image.resizable()
            
        } placeholder: {
            ProgressView()
        }
        .frame(width: 100, height: 100)
        .clipShape(RoundedRectangle(cornerRadius: 3.0))
        .shadow(radius: 8)
        .aspectRatio(contentMode: .fit)
        
    }
    
    var bioContent: some View {
        HStack (alignment: .center) {
            Image(systemName: "person.wave.2")
                .resizable()
                .scaledToFit()
                .frame(width: 24)
                .foregroundColor(OpenColor.RED.color(7))
            Text(viewModel.userInfo.bio)
                .font(.footnote).fontWeight(.light)
                .background(RoundedRectangle(cornerRadius: 4).foregroundColor(Color.clear).shadow(radius: 3))
        }
    }
    
    var locationContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "location.circle")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundColor(OpenColor.INDIGO.color(5))
            Text(viewModel.userInfo.location)
                .font(.callout).fontWeight(.light)
        }
    }
    
    var mailContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "envelope.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .foregroundColor(OpenColor.INDIGO.color(5))
            if let url = URL(string: localString.mailto(viewModel.userInfo.email)) {
                Link(destination: url, label: {
                    Text(viewModel.userInfo.email)
                        .underline()
                        .foregroundColor(OpenColor.PINK.color(7))
                })
            }
        }
    }
    
    var followContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 20)
                .foregroundColor(OpenColor.ORANGE.color(7))
            Text(localString.follwers(viewModel.userInfo.followers, viewModel.userInfo.following))
                .font(.system(.caption2, design: .rounded).bold())
                .fontWeight(.light)
        }
    }
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: .init(container: .preview))
    }
}
#endif
