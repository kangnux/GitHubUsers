//
//  UIColor+Extension.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/16.
//

import SwiftUI
import UIKit

enum OpenColor: Int {
    case GRAY = 0
    case RED
    case PINK
    case GRAPE
    case VIOLET
    case INDIGO
    case BLUE
    case CYAN
    case TEAL
    case GREEN
    case LIME
    case YELLOW
    case ORANGE
    
    func color(_ number: Int) -> Color {
        if  Array( 0 ... 9 ) .contains(number) {
            return UIColor.hexStringToUIColor(hex: UIColor.ColorList[self.rawValue][number])
        }
        
        return Color.clear
    }
}

enum GradientColor: Int {
    case lighBlue = 0
    case darkBlue
    
    var gradient: LinearGradient {
        switch self {
        case .lighBlue:
            return LinearGradient(
                gradient: Gradient(colors: [OpenColor.BLUE.color(4), OpenColor.BLUE.color(2)]),
                startPoint: .leading,
                endPoint: .trailing)
        case .darkBlue:
            return LinearGradient(
                gradient: Gradient(colors: [OpenColor.BLUE.color(8), OpenColor.BLUE.color(6)]),
                startPoint: .leading,
                endPoint: .trailing)
        }
    }
}

extension UIColor {
    var color: Color {
        return Color(self)
    }
}

extension UIColor {
    static var ColorList = [
        [ "#f8f9fa", "#f1f3f5", "#e9ecef", "#dee2e6", "#ced4da", "#adb5bd", "#868e96", "#495057", "#343a40", "#212529"],
        [ "#fff5f5", "#ffe3e3", "#ffc9c9", "#ffa8a8", "#ff8787", "#ff6b6b", "#fa5252", "#f03e3e", "#e03131", "#c92a2a"],
        [ "#fff0f6", "#ffdeeb", "#fcc2d7", "#faa2c1", "#f783ac", "#f06595", "#e64980", "#d6336c", "#c2255c", "#a61e4d"],
        [ "#f8f0fc", "#f3d9fa", "#eebefa", "#e599f7", "#da77f2", "#cc5de8", "#be4bdb", "#ae3ec9", "#9c36b5", "#862e9c"],
        [ "#f3f0ff", "#e5dbff", "#d0bfff", "#b197fc", "#9775fa", "#845ef7", "#7950f2", "#7048e8", "#6741d9", "#5f3dc4"],
        [ "#edf2ff", "#dbe4ff", "#bac8ff", "#91a7ff", "#748ffc", "#5c7cfa", "#4c6ef5", "#4263eb", "#3b5bdb", "#364fc7"],
        [ "#e7f5ff", "#d0ebff", "#a5d8ff", "#74c0fc", "#4dabf7", "#339af0", "#228be6", "#1c7ed6", "#1971c2", "#1864ab"],
        [ "#e3fafc", "#c5f6fa", "#99e9f2", "#66d9e8", "#3bc9db", "#22b8cf", "#15aabf", "#1098ad", "#0c8599", "#0b7285"],
        [ "#e6fcf5", "#c3fae8", "#96f2d7", "#63e6be", "#38d9a9", "#20c997", "#12b886", "#0ca678", "#099268", "#087f5b"],
        [ "#ebfbee", "#d3f9d8", "#b2f2bb", "#8ce99a", "#69db7c", "#51cf66", "#40c057", "#37b24d", "#2f9e44", "#2b8a3e"],
        [ "#f4fce3", "#e9fac8", "#d8f5a2", "#c0eb75", "#a9e34b", "#94d82d", "#82c91e", "#74b816", "#66a80f", "#5c940d"],
        [ "#fff9db", "#fff3bf", "#ffec99", "#ffe066", "#ffd43b", "#fcc419", "#fab005", "#f59f00", "#f08c00", "#e67700"],
        [ "#fff4e6", "#ffe8cc", "#ffd8a8", "#ffc078", "#ffa94d", "#ff922b", "#fd7e14", "#f76707", "#e8590c", "#d9480f"]]
    
    static func hexStringToUIColor (hex:String) -> Color {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return Color(UIColor.gray)
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        let uiColor =  UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
        
        return Color(uiColor)
    }
}
