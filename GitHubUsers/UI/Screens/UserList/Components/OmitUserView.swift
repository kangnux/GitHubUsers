//
//  OmitUserView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import SwiftUI

struct OmitUserView: View {
    @ObservedObject var viewModel: OmitUserViewModel
    @State var image: UIImage = UIImage()
    
    init(viewModel: OmitUserViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            imageContent
            Spacer().frame(width: 16)
            VStack(alignment: .leading, spacing: 4) {
                nameContent
                Divider()
                    .background(OpenColor.CYAN.color(9))
                if !viewModel.userInfo.bio.isEmpty {
                    bioContent
                } else if !viewModel.userInfo.location.isEmpty {
                    locationContent
                } else if !viewModel.userInfo.email.isEmpty {
                    mailContent
                } else {
                    emptyContent
                }
                followContent
            }
            Spacer()
        }
        .ignoresSafeArea()
    }
}

private extension OmitUserView {
    var imageContent: some View {
        AsyncImage(url: URL(string: viewModel.userInfo.avatarUrl)) { image in
            image.resizable()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 48, height: 48)
        .clipShape(Circle())
        .shadow(radius: 3)
        .aspectRatio(contentMode: .fit)
    }
    
    var nameContent: some View {
        HStack(alignment: .center, spacing: 8) {
            if viewModel.isPin {
                Image(systemName: "pin.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12)
                    .foregroundColor(OpenColor.RED.color(5))
                Text(viewModel.userInfo.login)
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(OpenColor.RED.color(9))
            } else {
                Text(viewModel.userInfo.login)
                    .font(.system(.title2, design: .rounded))
                    .foregroundColor(OpenColor.BLUE.color(8))
            }
        }
    }
    
    var mailContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "envelope.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundColor(OpenColor.CYAN.color(7))
            Text(viewModel.userInfo.email)
                .font(.caption2).fontWeight(.light)
        }
    }
    
    var locationContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "location.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundColor(OpenColor.CYAN.color(7))
            Text(viewModel.userInfo.location)
                .font(.caption2).fontWeight(.light)
        }
    }
    
    var bioContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.wave.2")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundColor(OpenColor.RED.color(7))
            Text(viewModel.userInfo.bio)
                .font(.caption2).fontWeight(.light)
        }
    }
    
    var emptyContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "eye.slash.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundColor(OpenColor.GRAY.color(6))
            localString.empty.text
                .font(.caption2).fontWeight(.light)
        }
    }
    
    var followContent: some View {
        HStack(alignment: .center) {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 12)
                .foregroundColor(OpenColor.ORANGE.color(7))
            Text(localString.follwers(viewModel.userInfo.followers, viewModel.userInfo.following))
                .font(.system(.caption2, design: .rounded).bold())
                .fontWeight(.light)
        }
    }
}

#if DEBUG
struct OmitUserView_Previews: PreviewProvider {
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
        OmitUserView(viewModel: .init(container: .preview, user))
    }
}
#endif
