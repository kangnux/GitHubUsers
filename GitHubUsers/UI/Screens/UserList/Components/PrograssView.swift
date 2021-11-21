//
//  PrograssView.swift
//  GitHubUsers
//
//  Created by 康 建斌 on 2021/11/18.
//

import SwiftUI

struct PrograssView: View {
    @Binding var isShowIndicator: Bool
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: proxy.size.width, height: 1)
                    .foregroundColor(OpenColor.BLUE.fetchColor(10).opacity(0.2))
                Rectangle().frame(
                    width: proxy.size.width  * CGFloat(pageNumer) /  CGFloat(upperLimit) ,
                    height: 2)
                    .foregroundColor(OpenColor.BLUE.fetchColor(10).opacity(1))
                    .animation(.linear)

            }
            .frame(height: 2)
        }
    }
}

struct PrograssView_Previews: PreviewProvider {
    static var previews: some View {
        PrograssView(pageNumer: .constant(1), upperLimit: .constant(10))
    }
}
