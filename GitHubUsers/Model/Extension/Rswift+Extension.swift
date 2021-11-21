//
//  Rswift+Extension.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/19.
//

import Rswift
import SwiftUI

typealias localString = R.string.localizable
typealias localColor = R.color

extension FontResource {
    func font(size: CGFloat) -> Font {
        Font.custom(fontName, size: size)
    }
}

extension ColorResource {
    var color: Color {
        Color(name)
    }
}

extension StringResource {
    var localizedStringKey: LocalizedStringKey {
        LocalizedStringKey(key)
    }
    
    var text: Text {
        Text(localizedStringKey)
    }
}

extension ImageResource {
    var image: Image {
        Image(name)
    }
}
