//
//  QiitaAPI.swift
//  SwiftUIForQiita
//
//  Created by Toru Nakandakari on 2020/02/01.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation

/**
QiitaのAPIクラス

Extensinoで各エンドポイント用のリクエストが実装されています
*/

public struct QiitaAPI {

    // 認証に関するリクエスト
    public struct Authorization {}
    
    // 投稿に関するリクエスト
    public struct Item {}
    
    // TODO: 必要な機能を随時追加していく
}

public struct APIClient<Request: QiitaRequest> {
    
    let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    @discardableResult
    public func send(_ request: Request, completion: @escaping(Result<Request.Response, QiitaKitError>) -> Void) -> URLSessionDataTask {
        let task = urlSession.dataTask(with: request.asURLRequest()) {
            (data, urlResponse, error) in
            func execCompletionOnMainThread(_ result: Result<Request.Response, QiitaKitError>) {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                execCompletionOnMainThread(.failure(.urlSessionError(error)))
                return
            }
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                execCompletionOnMainThread(.failure(.unknown))
                return
            }
            
            switch httpResponse.statusCode {
            case 200, 201, 204:
                do {
                    let response = try Request.Response(response: httpResponse, json: data ?? Data())
                    execCompletionOnMainThread(.success(response))
                } catch let decodeError {
                    execCompletionOnMainThread(.failure(.invalidJSON(decodeError)))
                }
            default:
                let error = QiitaKitError(object: data ?? Data())
                execCompletionOnMainThread(.failure(error))
            }
        }
        
        task.resume()
        
        return task
    }
}
