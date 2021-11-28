//
//  UserDetailView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/18.
//

import SwiftUI

struct UserDetailView: View {
    @State private var orientation = UIDeviceOrientation.unknown
    @ObservedObject private(set) var viewModel: UserDetailViewModel
    @State var image: UIImage = UIImage()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                detailInfoContent
                repositoriesContent
            }
        }
        .navigationTitle(localString.repositories())
        .navigationBarTitleDisplayMode(.inline)
        .onRotate { newOrientation in
            orientation = newOrientation
        }
        .onFirstAppear {
            viewModel.fetchUserRepositories()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private extension UserDetailView {
    var detailInfoContent: some View {
        VStack(alignment: .leading) {
            statusContent
            if !viewModel.userInfo.bio.isEmpty {
                bioContent
            }
            Divider()
            VStack(alignment: .leading) {
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
            pinContent
                .padding(.trailing, 8)
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
    
    var pinContent: some View {
        Button (action: {
            withAnimation {
                viewModel.updatePinUserStatus(!viewModel.isUserPin)
            }
        }) {
            Image(systemName: viewModel.isUserPin ? "pin" : "pin.slash")
                .frame(width: 36, height: 36)
                .imageScale(.large)
                .background(OpenColor.BLUE.color(5))
                .foregroundColor(
                    OpenColor.PINK.color(1).opacity(viewModel.isUserPin ? 1.0 : 0.5))
                .clipShape(Circle())
                .opacity(viewModel.isUserPin ? 1 : 0.3)
                .shadow(radius:  viewModel.isUserPin ? 3 : 0)
        }
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
struct UserDetailView_Previews: PreviewProvider {
    static let user = UserEntity(
        login: "octocat",
        name: "The Octocat",
        avatarUrl: "https://avatars.githubusercontent.com/u/583231?v=4",
        url: "https://api.github.com/users/octocat",
        htmlUrl: "https://github.com/octocat",
        location: "San Francisco",
        email: "kangnux@outlook.com",
        bio: "Test bio",
        followers: "10",
        following: "1.0K")
    static var previews: some View {
        UserDetailView(viewModel: .init(container: .preview, userInfo: user))
    }
}
#endif
