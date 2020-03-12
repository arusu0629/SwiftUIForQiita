//
//  QiitaItemStoreManager.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/09.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation
import SwiftUI

final class QiitaItemStoreManager: ObservableObject {
    
    @ObservedObject public static var sharedManager = QiitaItemStoreManager()
    
    private let recentlyItemsKey = "recentlyItemsKey"
    private let favoriteItemsKey = "favoriteItemsKey"
    
    private let canStoreCount = 50
    
    @Published private(set) var recentlyItems: [Item] = []
    @Published private(set) var favoriteItems: [Item] = []
    
    init() {
        setup()
    }
    
    private func setup() {
        // 最近見た
        UserDefaultManager.sharedManager.get(object: [Item].self, forKey: recentlyItemsKey) { (items) in
            self.recentlyItems = items ?? []
        }
        // お気に入り
        UserDefaultManager.sharedManager.get(object: [Item].self, forKey: favoriteItemsKey) { (items) in
            self.favoriteItems = items ?? []
        }
    }
    
    func addRecentlyItem(targetItem: Item) {
        self.recentlyItems = createItems(targetItem: targetItem, inList: self.recentlyItems, key: recentlyItemsKey)
    }
    
    func addFavoriteItem(targetItem: Item) {
        self.favoriteItems = createItems(targetItem: targetItem, inList: self.favoriteItems, key: favoriteItemsKey)
    }
    
    private func createItems(targetItem: Item, inList: [Item], key: String) -> [Item] {
        var targetList = inList
        // すでに存在している場合
        if let hasIndex = targetList.firstIndex(where: { (item) in item.id == targetItem.id }) {
            // 先頭に詰め直す
            targetList.remove(at: hasIndex)
            targetList.insert(targetItem, at: 0)
        } else {
            // リストにまだ余裕があればそのまま先頭に詰める
            if (targetList.count < canStoreCount) {
                targetList.insert(targetItem, at: 0)
            } else {
                // 1番古いのを消す
                targetList.removeLast()
                targetList.insert(targetItem, at: 0)
            }
        }
        do {
            try save(targetList: targetList, key: key)
        } catch (let error) {
            print("addItem error = \(error) targetItem = \(targetItem) forKey = \(key)")
        }
        
        return targetList
    }
    
    func removeFavoriteItem(targetItem: Item) {
        guard let hasIndex = favoriteItems.firstIndex(where: { (item) in item.id == targetItem.id }) else {
            return
        }
        self.favoriteItems.remove(at: hasIndex)
        do {
            try save(targetList: self.favoriteItems, key: self.favoriteItemsKey)
        } catch (let error) {
            print("removeFavoriteItem error = \(error) targetItems = \(self.favoriteItems) forKey = \(self.favoriteItemsKey)")
        }
    }
    
    private func save(targetList: [Item], key: String) throws {
        // 保存する
        try UserDefaultManager.sharedManager.save(object: targetList, forKey: key) { (hasSuccess) in
            print("key = \(key) save hasSuccess = \(hasSuccess)")
            print("save articles count = \(self.recentlyItems.count)")
            print("save favarite articles count = \(self.favoriteItems.count)")
        }
    }
}
