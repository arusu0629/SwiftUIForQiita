//
//  QiitaViewModel.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

class QiitaViewModel {
    static func fetchArticle(completion: @escaping ([QiitaStruct]) -> Swift.Void) {

        let url = "https://qiita.com/api/v2/items"

        guard var urlComponents = URLComponents(string: url) else {
            return
        }

        urlComponents.queryItems = [
            URLQueryItem(name: "per_page", value: "50"),
            URLQueryItem(name: "query", value: "swift"),
            URLQueryItem(name: "Authorization: Bearer", value: "29eb20d87bb3227eda87f9ea744d1ff452621459")
        ]

        let task = URLSession.shared.dataTask(with: urlComponents.url!) { data, response, error in

            guard let jsonData = data else {
                return
            }

            do {
                let articles = try JSONDecoder().decode([QiitaStruct].self, from: jsonData)
                DispatchQueue.main.async {
                    completion(articles)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
