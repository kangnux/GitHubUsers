//
//  Application+Extension.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/17.
//

import Foundation
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
