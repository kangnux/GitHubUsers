//
//  Int+Extension.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/17.
//

import Foundation

extension Int {
    func formatPoints() -> String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        
        if billion >= 1.0 {
            return "\(round(billion*10)/10)B"
        } else if million >= 1.0 {
            return "\(round(million*10)/10)M"
        } else if thousand >= 1.0 {
            return ("\(round(thousand*10/10))K")
        } else {
            return "\(Int(number))"
        }
    }
}
