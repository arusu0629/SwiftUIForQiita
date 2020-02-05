//
//  AuthManager.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation
import WebKit
import UIKit
import SwiftUI

/**
OAuthを行うWebViewの種類

- UIWebView
- WKWebView
*/

public enum AuthWebViewType {
    case uiWebView
    case wkWebView
}

/**
Qiitaの認証を管理するクラス
*/
public final class AuthManager : ObservableObject {
    /* ====================================================================== */
    // MARK: - Types
    /* ====================================================================== */
    
    public typealias AuthCompletionHandler = (_ result: Result<Bool, QiitaKitError>) -> Void
    
    internal typealias AuthInfo = (state: String, redirectURL: URL, completion: AuthCompletionHandler)
    
    private struct KeychainKey {
        static let accessToken = "accessToken"
        static let teamDomain  = "teamDomain"
    }
    
    /* ====================================================================== */
       // MARK: - Properties
       /* ====================================================================== */
    
    @ObservedObject public static var sharedManager = AuthManager()

    // アクセストークン
    public internal(set) var accessToken: String? {
        get {
            return try? keychain.read(withKey: KeychainKey.accessToken)
        }
        set {
            guard let newValue = newValue else {
                let _ = try? keychain.deleteItem(withKey: KeychainKey.accessToken)
                authorized = false
                return
            }
            let _ = try? keychain.save(newValue, forKey: KeychainKey.accessToken)
            authorized = true
        }
    }
    
    // QiitaTeamのドメイン
    public internal(set) var teamDomain: String? {
        get {
            return try? keychain.read(withKey: KeychainKey.teamDomain)
        }
        set {
            guard let newValue = newValue else {
                let _ = try? keychain.deleteItem(withKey: KeychainKey.teamDomain)
                return
            }
            let _ = try? keychain.save(newValue, forKey: KeychainKey.teamDomain)
        }
    }
    
    // Qiitaで認証済みかどうかを返す
    @Published var authorized: Bool = false

    public private(set) var clientID: String!
    
    public private(set) var clientSecret: String!
    
    public private(set) var keychainConfiguration: KeychainConfiguration!
    
    private var keychain: KeychainWrapper {
        return KeychainWrapper(config: keychainConfiguration)
    }
    
    private init() {}
    
    /* ====================================================================== */
    // MARK: - Public Method
    /* ====================================================================== */
    
    /**
    Qiitaの認証に関する初期設定を行う
    
    AppDelegateのdidFinishLaunchingWithOptionなどで設定してください
    
    - parameter clientID:              登録アプリケーションのClientID
    - parameter clientSecret:          登録アプリケーションのClientSecret
    - parameter teamDomain:            QiitaTeamのドメイン(Optional)
    - parameter keychainConfiguration: accessToken等を保存するKeychainの設定(Optional)
     */
    
    public func setup(clientID: String,
                      clientSecret: String,
                      teamDomain: String? = nil,
                      keychainConfiguration:
        KeychainConfiguration = KeychainConfiguration()) {
        
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.keychainConfiguration = keychainConfiguration
        if let teamDomain = teamDomain {
            self.teamDomain = teamDomain
        }
        self.authorized = accessToken != nil
    }
    
    /**
    QiitaのOAuth認証を行う
    
    - parameter scopes:      アプリで利用可能なスコープ
    - parameter redirectURL: 登録アプリケーションで設定したリダイレクト先のURL
    - parameter webViewType: OAuth認証を行うWebViewの種類
    - parameter completion:  認証後に呼ばれるハンドラ
    */
    
    public func authorize(withScopes scopes: Set<Scope>,
                          redirectURL: URL,
                          webViewType: AuthWebViewType,
                          completion: @escaping AuthCompletionHandler) {
        let authInfo = (state: UUID().uuidString, redirectURL: redirectURL, completion: completion)
        
        let request = QiitaAPI.Authorization.AuthorizeRequest.init(clientID: clientID, scopes: scopes, state: authInfo.state)
        
        // TODO: 認証画面を表示する
        /*
         AuthWebViewController.show(
         withRequest: request.asURLRequest(),
         authInfo: authInfo,
         webViewType: webViewType)
         */
    }
    
    public func authorizeRequest(withScopes scopes: Set<Scope>, state: String) -> URLRequest {
        let request = QiitaAPI.Authorization.AuthorizeRequest.init(clientID: clientID, scopes: scopes, state: state)
        return request.asURLRequest()
    }
    
    /**
        Keychainに保存してあるアクセストークン、WebViewのCookie等を削除する
        
        - throws: ErrorType
    */
    
    public func logout() throws {
        if (try? deleteToken()) != nil {
            accessToken = nil
        }
        try removeWKWebViewCache()
        removeUIWebViewCaches()
    }
    
    /**
    Keychainに保存してあるアクセストークンを削除します
    
    - throws: KeychainError
    */
    
    public func deleteToken() throws {
        try keychain.deleteItem(withKey: KeychainKey.accessToken)
    }
    
    /* ====================================================================== */
    // MARK: Private
    /* ====================================================================== */
    
    private func removeWKWebViewCache() throws {
        if #available(iOS 9.0, *) {
            let websiteDataTypes: Set<String> = [
                WKWebsiteDataTypeDiskCache,
                WKWebsiteDataTypeMemoryCache,
                WKWebsiteDataTypeCookies
            ]
            let date = Date(timeIntervalSince1970: 0)
            
            WKWebsiteDataStore
                .default()
                .removeData(ofTypes: websiteDataTypes,
                            modifiedSince: date
                ) {}
        } else {
            var libraryPath =
                NSSearchPathForDirectoriesInDomains(
                .libraryDirectory,
                .userDomainMask,
                false).first!
            
            libraryPath += "/Cookies"
            
            try FileManager.default.removeItem(atPath: libraryPath)
            
        }
        URLCache.shared.removeAllCachedResponses()
    }
    
    private func removeUIWebViewCaches() {
        let cookieStorage = HTTPCookieStorage.shared
        cookieStorage.cookies?.forEach {
            cookieStorage.deleteCookie($0)
        }
        URLCache.shared.removeAllCachedResponses()
    }
}
