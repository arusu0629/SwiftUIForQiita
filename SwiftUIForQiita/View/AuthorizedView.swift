//
//  AuthorizedView.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import SwiftUI
import WebKit

class WebViewModel: ObservableObject {
    @Published var observation: NSKeyValueObservation?
}

var state: String = UUID().uuidString
struct AuthorizedView: UIViewRepresentable {
        
    var request: URLRequest
    @ObservedObject var observe = WebViewModel()
    @Environment(\.presentationMode) var presentation

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        observe.observation = uiView.observe(\WKWebView.url, options: .new) { view, change in
            if let url = uiView.url {
                self.parse(redirectURL: url)
            }
        }
        uiView.load(request)
    }
    
    fileprivate func parse(redirectURL url: URL) {
        guard let _state = url.fragments["state"],
            let code = url.fragments["code"], _state == state else {
                return
        }
        
        let accessTokenRequest = QiitaAPI.Authorization.AccessTokenRequest(clientID: AuthManager.sharedManager.clientID, clientSecret:  AuthManager.sharedManager.clientSecret, code: code)
        
        APIClient().send(accessTokenRequest) { result in
            switch result {
            case .success(let accessTokenResponse):
                AuthManager.sharedManager.accessToken = accessTokenResponse.token
                self.presentation.wrappedValue.dismiss()
            case .failure(let error):
                print("[accessTokenRequest] failure error = \(error)")
                break
            }
        }
    }
}

struct AuthorizedView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorizedView(request: TestAuthrizedRequest())
    }
    
    static func TestAuthrizedRequest() -> URLRequest {
        let scopes: Set<Scope> = [.readQiita]
        return AuthManager.sharedManager.authorizeRequest(withScopes: scopes, state: state)
    }
}
