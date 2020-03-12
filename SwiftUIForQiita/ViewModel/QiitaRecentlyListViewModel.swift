//
//  QiitaRecentlyListViewModel.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/08.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

class QiitaRecentltyListViewModel: ObservableObject {
    
    private let canStoreCount = 50
    private let key = "QiitaRecentltyListItemsKey"
    
    @Published var articles: [Item] = []
    
    init() {
        UserDefaultManager.sharedManager.get(object: [Item].self, forKey: key) { (items) in
            self.articles = items ?? []
        }
    }
    
    func add(object: Item) {
        // すでに履歴に存在している場合
        if let hasIndex = self.articles.firstIndex(where: { (item) in item.id == object.id }) {
            // 先頭に入れ直す
            self.articles.remove(at: hasIndex)
            self.articles.insert(object, at: 0)
        } else {
            // 50件未満なら
            if (self.articles.count < canStoreCount) {
                // 先頭に追加
                self.articles.insert(object, at: 0)
            } else {
                // 1番古いやつを消して先頭に追加
                self.articles.removeLast()
                self.articles.insert(object, at: 0)
            }
        }
        // 保存する
        do {
            try UserDefaultManager.sharedManager.save(object: self.articles, forKey: key) { (hasSuccess) in
                print("[QiitaRecentltyListViewModel add] hasSuccess = \(hasSuccess)")
            }
        } catch (let error) {
            print("[QiitaRecentltyListViewModel add] error = \(error)")
        }
    }
}
