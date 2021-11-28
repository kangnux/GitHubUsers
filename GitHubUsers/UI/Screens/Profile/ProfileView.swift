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
        NavigationView {
            GeometryReader { proxy in
                VStack(alignment: .leading) {
                    HStack(alignment: .center) {
                        authorizeContent(width: proxy.size.width/2)
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
                .padding(.horizontal, 8)
            }
            .navigationTitle(localString.profile())
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .alert(isPresented: $viewModel.authInfo.showAlert) {
            Alert(title: Text(viewModel.authInfo.state.title),
                  dismissButton: .default(localString.close.text,
                                          action: {}))
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            viewModel.fetchAccessToken()
        }
    }
}

private extension ProfileView {
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
}

#if DEBUG
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: .init(container: .preview))
    }
}
#endif
