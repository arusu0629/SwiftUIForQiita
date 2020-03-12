//
//  QiitaListViewModel.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

class QiitaListViewModel : ObservableObject {

    @Published var articles: [Item] = []
    
    func reloadItems(onCompletion: @escaping () -> Void) {
        fetchGetItems(type: .query(query: "Swift"), page: 1, perPage: 50, onCompletion: onCompletion)
    }
    
    private func fetchGetItems(type: QiitaAPI.Item.ItemsType, page: Int, perPage: Int, onCompletion: @escaping () -> Void) {
        let request = QiitaAPI.Item.GetItemsRequest(type: type, page: page, perPage: perPage)
        APIClient().send(request) { result in
            switch result {
            case .success(let response):
                self.articles = response.objects
                onCompletion()
            case .failure(let error):
                print("failure error = \(error)")
                onCompletion()
            }
        }
    }
}
