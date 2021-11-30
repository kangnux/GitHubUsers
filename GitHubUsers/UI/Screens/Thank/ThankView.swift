//
//  ThankView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import SwiftUI

struct ThankView: View {
    @ObservedObject private(set) var viewModel: ThankViewModel
    
    var body: some View {
        NavigationView{
            Form() {
                Section {
                    Button(action: {
                        openURL(URLConfiguration.gitHubDocPathJP)
                    }, label: {
                        HStack {
                            Spacer()
                            localString.gitHubApiNameJP.text
                                .font(.system(.title3, design: .rounded).bold())
                            Spacer()
                        }
                    })
                }
                
                Section {
                    Button(action: {
                        openURL(URLConfiguration.gitHubDocPathEN)
                    }, label: {
                        HStack {
                            Spacer()
                            localString.gitHubApiNameEN.text
                                .font(.system(.title3, design: .rounded).bold())
                            Spacer()
                        }
                    })
                    
                }
                
                Section {
                    Button(action: {
                        openURL(URLConfiguration.openColorGitHubPath)
                    }, label: {
                        HStack {
                            Spacer()
                            localString.openColorGit.text
                                .font(.system(.title3, design: .rounded).bold())
                            Spacer()
                        }
                    })
                }
                
                Section {
                    Button(action: {
                        openURL(URLConfiguration.openColorHomePage)
                    }, label: {
                        HStack {
                            Spacer()
                            localString.openColorHome.text
                                .font(.system(.title3, design: .rounded).bold())
                            Spacer()
                        }
                    })
                }
                
                Section {
                    Button(action: {
                        openURL(URLConfiguration.icon8HomePage)
                    }, label: {
                        HStack {
                            Spacer()
                            localString.icon8.text
                                .font(.system(.title3, design: .rounded).bold())
                            Spacer()
                        }
                    })
                }
            }
            .navigationBarTitle(localString.thankTitle(), displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

extension ThankView {
    func openURL(_ url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }
}

#if DEBUG
struct ThankView_Previews: PreviewProvider {
    static var previews: some View {
        ThankView(viewModel: .init(container: .preview))
    }
}
#endif
