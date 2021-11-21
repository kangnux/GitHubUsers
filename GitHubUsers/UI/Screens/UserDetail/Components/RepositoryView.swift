//
//  RepositoryView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/19.
//

import SwiftUI

struct RepositoryView: View {
    @ObservedObject private(set) var viewModel: RepositoryViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            titleContent
            descriptionContent
            statusContent
            languageContent
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(GitHubColors.fetchColor(viewModel.repository.lanuage), lineWidth: 1.5)
        )
        .padding([.leading, .trailing], 8)
        
    }
}

private extension RepositoryView {
    var titleContent: some View {
        HStack {
            Text(viewModel.repository.name)
                .font(.system(.title, design: .rounded)).fontWeight(.medium)
                .minimumScaleFactor(0.5)
                .foregroundColor(OpenColor.BLUE.color(9))
                .lineLimit(2)
                .frame(alignment: .leading)
            
            Spacer()
            
            Text(viewModel.repository.isPrivate ?
                 localString.showPrivate() : localString.showPublic())
                .font(.system(.title3, design: .rounded))
                .foregroundColor(OpenColor.GRAY.color(7))
                .padding([.leading, .trailing], 16)
                .padding([.top, .bottom], 2)
                .overlay(
                    Capsule(style: .circular).stroke(OpenColor.GRAY.color(5), lineWidth: 1))
            
        }
    }
    
    var descriptionContent: some View {
        Text(viewModel.repository.description)
            .font(.system(.body, design: .rounded)).fontWeight(.regular)
            .foregroundColor(OpenColor.GRAY.color(8))
    }
    
    var statusContent: some View {
        HStack(alignment: .bottom, spacing: 36) {
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(OpenColor.GRAY.color(7))
                
                Text(viewModel.repository.watchers)
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.light)
                    .foregroundColor(OpenColor.GRAY.color(8))
            }
            
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "eye.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(OpenColor.GRAY.color(7))
                
                Text(viewModel.repository.stargazers)
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.light)
                    .foregroundColor(OpenColor.GRAY.color(8))
            }
            
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "tuningfork")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundColor(OpenColor.GRAY.color(7))
                
                Text(viewModel.repository.forks)
                    .font(.system(.callout, design: .rounded))
                    .fontWeight(.light)
                    .foregroundColor(OpenColor.GRAY.color(8))
            }
        }
    }
    
    var languageContent: some View {
        HStack{
            if !viewModel.repository.lanuage.isEmpty {
                Circle()
                    .frame(width: 16, height: 16)
                    .foregroundColor(GitHubColors.fetchColor(viewModel.repository.lanuage))
                Text(viewModel.repository.lanuage)
                    .font(.system(.title3, design: .rounded)).fontWeight(.medium)
                    .foregroundColor(GitHubColors.fetchColor(viewModel.repository.lanuage))
                Spacer()
            }
            Spacer()
            
            pinContent
        }
    }
    
    var pinContent: some View {
        Button (action: {
            withAnimation {
                viewModel.updatePinRepositoryStatus(!viewModel.isRepositoryPin)
            }
        }) {
            Image(systemName: viewModel.isRepositoryPin ? "pin" : "pin.slash")
                .frame(width: 24, height: 24)
                .background(OpenColor.BLUE.color(5))
                .foregroundColor(
                    OpenColor.PINK.color(1).opacity(viewModel.isRepositoryPin ? 1.0 : 0.5))
                .clipShape(Circle())
                .opacity(viewModel.isRepositoryPin ? 1 : 0.3)
                .shadow(radius:  viewModel.isRepositoryPin ? 3 : 0)
            
        }
    }
}

struct RepositoryView_Previews: PreviewProvider {
    static let repository = RepositoryEntity(
        name: "linguist linguist linguist linguist linguist",
        isPrivate: false,
        htmlUrl: "https://github.com/octocat/linguist",
        description:  "Language Savant. ",
        fork: true,
        url: "https://api.github.com/repos/octocat/linguist",
        stargazers: localString.zero(),
        watchers: localString.zero(),
        forks: localString.zero(),
        lanuage: "Ruby",
        allow_forking: false)
    static var previews: some View {
        RepositoryView(viewModel: .init(container: .preview, repository: repository))
    }
}
