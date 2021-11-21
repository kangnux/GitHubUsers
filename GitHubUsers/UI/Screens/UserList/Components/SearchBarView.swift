//
//  SearchBarView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/17.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchKey: String
    @Binding var isShowCancel: Bool
    @State var editSearch: String = localString.empty()
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField(
                    NSLocalizedString(localString.search(), comment: "").stringValue,
                    text: $editSearch,
                    onEditingChanged: { isEditing in
                        withAnimation {
                            isShowCancel = true
                        }
                    }, onCommit: {
                        searchKey = editSearch
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .shadow(color: isShowCancel ? OpenColor.CYAN.color(5) : .clear, radius: 3)
                    .submitLabel(.search)
                
                Button(action: {
                    editSearch = localString.empty()
                    searchKey = localString.empty()
                }) {
                    Image(systemName: "xmark.circle.fill").opacity( editSearch.isEmpty ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 6, bottom: 8, trailing: 6))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
            
            if isShowCancel  {
                Button(localString.cancel()) {
                    UIApplication.shared.endEditing()
                    withAnimation {
                        isShowCancel = false
                    }
                }
                .foregroundColor(Color(.systemBlue))
            }
        }
        .padding(.horizontal)
    }
}
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchKey: .constant(""), isShowCancel: .constant(false))
    }
}
