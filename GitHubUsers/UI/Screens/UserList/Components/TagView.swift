//
//  TagView.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/22.
//

import SwiftUI

struct TagView: View {
    @Binding var tags: [TagEntity]
    @Binding var searchKey: String
    var fontSize: CGFloat = 16
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 10) {
                ForEach(tags) { tag in
                    TagItemView(tag: tag)
                        .padding(.vertical, 4)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .onChange(of: searchKey) { newKey in
            if !newKey.isEmpty {
                if let index = tags.firstIndex(where: { $0.text == newKey }) {
                    if index != tags.startIndex {
                        tags.remove(at: index)
                        tags.insert(TagEntity(text: newKey), at: 0)
                    }
                } else {
                    if tags.count >= Constants.maxSerachHistoryCount {
                        tags.removeLast()
                    }
                    tags.insert(TagEntity(text: newKey), at: 0)
                }
            }
        }
        .onChange(of: tags) { _ in
            AppSettingManager.shared.updateSearchHistory(tags)
            guard let last = tags.last  else {
                return
            }
            
            let font = UIFont.systemFont(ofSize: fontSize)
            let attributes = [NSAttributedString.Key.font: font]
            let size = (last.text as String).size(withAttributes: attributes)
            
            tags[fetchIndex(tag: last)].size = size.width
        }
        .animation(.linear, value: tags)
    }
}

private extension TagView {
    @ViewBuilder
    func TagItemView(tag: TagEntity) -> some View {
        Text(tag.text)
            .font(.system(size: fontSize, weight: .regular, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .foregroundColor(OpenColor.GRAY.color(8))
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(OpenColor.GRAY.color(2))
                    .shadow(radius: 2)
                    
            )
            .contextMenu {
                Button(action: {
                    tags.remove(at: fetchIndex(tag: tag))
                }) {
                    HStack {
                        Text(localString.delete())
                        Image(systemName: "trash.circle.fill")
                        
                    }
                }
                Button(action: {
                    if searchKey != tag.text {
                        searchKey = tag.text
                    }
                }) {
                    HStack {
                        Text(localString.search())
                        Image(systemName: "magnifyingglass.circle")
                        
                    }
                }
            }
            .onTapGesture {
                if searchKey != tag.text {
                    searchKey = tag.text
                }
            }
    }
    
    func fetchIndex(tag: TagEntity) -> Int {
        let index = tags.firstIndex { tag.id == $0.id } ?? 0
        return index
    }
}

#if DEBUG
struct TagView_Previews: PreviewProvider {
    @State static var tags: [TagEntity] = [TagEntity(text: "aaa")]
    static var previews: some View {
        TagView(tags: $tags, searchKey: .constant("ccc"))
    }
}
#endif
