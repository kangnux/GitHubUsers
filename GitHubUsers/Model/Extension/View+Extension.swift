//
//  View+Extension.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import Foundation
import SwiftUI

extension View {
    func onFirstAppear(perfom: @escaping () -> Void) -> some View {
        modifier(OnFirstAppear(perform: perfom))
    }
}

private struct OnFirstAppear: ViewModifier {
    let perform: () -> Void
    @State private var firstTime = true
    
    func body(content: Content) -> some View {
        content.onAppear {
            if firstTime {
                firstTime.toggle()
                perform()
            }
        }
    }
}

struct ResignKeyboardOnDragGesture: ViewModifier {
    var gesture = DragGesture()
        .onChanged{ _ in
            UIApplication.shared.endEditing()
        }
    
    func body(content: Content) -> some View {
        content.gesture(gesture)
    }
}

extension View {
    func resignKeyboardOnDragGesture() -> some View {
        return modifier(ResignKeyboardOnDragGesture())
    }
}
