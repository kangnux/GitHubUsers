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
            NavigationLink(
                destination: LoginWebView(viewModel: .init(container: viewModel.container))
            ){
                localString.authorize.text
            }
        }
        .onAppear {
            
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
