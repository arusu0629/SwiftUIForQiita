//
//  SwiftUIView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/01/31.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI
import WebKit

struct SafariView: UIViewRepresentable {

    var url: URL?
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url!))
    }
}

struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://qiita.com/arusu0629/items/b0f4da429dde972b9463")!)
    }
}
