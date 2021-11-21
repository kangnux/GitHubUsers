//
//  ApiAlertBag.swift
//  GitHubUsers
//
//  Created by kangnux on 2021/11/20.
//

import Combine
import SwiftUI

final class ApiAlertBag: ObservableObject {
    @Published var isPresented: Bool = false
    @Published var alert: AlertItem = AlertItem()
    @Published private var alertList: [AlertItem] = []
    
    private let cancelBag = CancelBag()
    
    init() {
        cancelBag.collect {
            $alertList
                .removeDuplicates()
                .sink { [weak self] list in
                    self?.alert = list.last ?? AlertItem()
                    self?.isPresented = list.count > 0
                }
        }
    }
    
    private func addAlert(_ item: AlertItem) {
        alertList.append(item)
    }
    
    private func removeAlert() {
        alertList.removeLast()
    }
    
    private func removeAllAlert() {
        alertList.removeAll()
    }
}

extension ApiAlertBag {
    func addAlertItem(error: Error) {
        if let error = error as? ApiError {
            let alert = Alert(title: Text(error.status.title),
                              message: Text(error.status.message),
                              dismissButton: .default(localString.close.text))
            let item = AlertItem(alert)
            addAlert(item)
        }
    }
}
