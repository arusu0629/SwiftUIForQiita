//
//  QiitaHistoryItemViewModel.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/08.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation
import SwiftUI

// 最近見たQiita記事を扱うクラス
final class QiitaHistoryManager : ObservableObject {
    
    private let HistoryItemsKey = "QiitaHistoryListItemsKey"
    private let HistoryCount = 50 // 50件まで保存しておく
    
    public static let sharedManager = QiitaHistoryManager()
    
    @Published var recentlyQiitaListItems: [Item] = []
    
    init() {
        UserDefaults.standard.get(object: [Item].self, for: HistoryItemsKey) { (items) in
            self.recentlyQiitaListItems = items ?? []
        }
    }
    
    private func save() {
        do {
            try UserDefaults.standard.set(object: recentlyQiitaListItems, for: HistoryItemsKey) { (hasSuccess) in print("hasSuccess = \(hasSuccess)") }
        }
        catch (let error) {
            print("failed to encode error = \(error)")
        }
    }
    
    func read(readArticle: Item) {
        guard let hasItemIndex = recentlyQiitaListItems.firstIndex(where: { item in item.id == readArticle.id}) else {
            // 履歴に存在しない場合
            // 件数が50件以上なら古い記事を消す
            if (recentlyQiitaListItems.count >= HistoryCount) {
                recentlyQiitaListItems.removeLast()
            }
            // 先頭に入れる
            recentlyQiitaListItems.insert(readArticle, at: 0)
            save()
            return
        }
        
        // すでに履歴に存在する場合は先頭に入れる
        recentlyQiitaListItems.remove(at: hasItemIndex)
        recentlyQiitaListItems.insert(readArticle, at: 0)
        save()
    }
}

extension JSONDecoder {
       func decode<T: Decodable>(from data: Data?) -> T? {
           guard let data = data else {
               return nil
           }
           return try? self.decode(T.self, from: data)
       }
       func decodeInBackground<T: Decodable>(from data: Data?, onDecode: @escaping (T?) -> Void) {
           DispatchQueue.global().async {
               let decoded: T? = self.decode(from: data)

               DispatchQueue.main.async {
                   onDecode(decoded)
               }
           }
       }
}

// MARK: - JSONEncoder extensions

public extension JSONEncoder {
    func encode<T: Encodable>(from value: T?) -> Data? {
        guard let value = value else {
            return nil
        }
        return try? self.encode(value)
    }
    func encodeInBackground<T: Encodable>(from encodableObject: T?, onEncode: @escaping (Data?) -> Void) {
        DispatchQueue.global().async {
            let encode = self.encode(from: encodableObject)

            DispatchQueue.main.async {
                onEncode(encode)
            }
        }
    }
}

// MARK: - NSUserDefaults extensions

public extension UserDefaults {
    func set<T: Encodable>(object type: T, for key: String, onEncode: @escaping (Bool) -> Void) throws {

        JSONEncoder().encodeInBackground(from: type) { [weak self] (data) in
            guard let data = data, let `self` = self else {
                onEncode(false)
                return
            }
            self.set(data, forKey: key)
            onEncode(true)
        }
    }
    func get<T: Decodable>(object type: T.Type, for key: String, onDecode: @escaping (T?) -> Void) {
        let data = value(forKey: key) as? Data
        JSONDecoder().decodeInBackground(from: data, onDecode: onDecode)
    }
}
