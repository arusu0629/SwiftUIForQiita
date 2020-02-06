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
    
    func fetchGetItems(type: QiitaAPI.Item.ItemsType, page: Int, perPage: Int) {
        let request = QiitaAPI.Item.GetItemsRequest(type: type, page: page, perPage: perPage)
        print("url = \(request.asURLRequest())")
        APIClient().send(request) { result in
            switch result {
            case .success(let response):
                self.articles = response.objects
            case .failure(let error):
                print("failure error = \(error)")
            }
        }
    }
}
