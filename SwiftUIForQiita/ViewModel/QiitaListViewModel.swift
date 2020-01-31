//
//  QiitaListViewModel.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/30.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

class QiitaListViewModel : ObservableObject {

    @Published var articles: [QiitaStruct] = []
    
    init() {
        QiitaViewModel.fetchArticle { _articles in
            self.articles = _articles
        }
    }
}
