//
//  App.swift
//  FinalProject
//
//  Created by Bien Le Q. on 8/26/19.
//  Copyright © 2019 Asiantech. All rights reserved.
//

import Foundation
import Alamofire

extension ApiManager {

    @discardableResult
    func request(method: HTTPMethod, urlString: URLStringConvertible, parameters: [String: Any]? = nil, encoding: ParameterEncoding = JSONEncoding.default, headers: [String: String]? = nil, completion: Completion<Any>?) -> Request? {
        guard Network.shared.isReachable else {
            completion?(.failure(Api.Error.network))
            return nil
        }

        var header1 = api.authorizationAccessHTTPHeaders
        header1.updateValues(headers)
        
        if urlString.urlString.contains("loginUsers") {
            header1.removeValue(forKey: "Authorization")
        }

        var header2 = api.authorizationRefreshHTTPHeaders
        header2.updateValues(headers)

        var header = api.defaultHTTPHeaders
        header.updateValues(headers)

        let request = Alamofire.request(urlString.urlString,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: header1
        ).responseJSON { (response) in
            // Fix bug AW-4571: Call request one more time when see error 53 or -1_005
            if let error = response.error {
                switch error.code {
                case Api.Error.connectionAbort.code, Api.Error.connectionWasLost.code:
                    header = header1
                case Api.Error.forbidden.code:
                    AuthService.refreshToken { result in
                        switch result {
                        case true:
                            break
                        case false:
//                            completion?(response.result)
//                            DispatchQueue.main.async {
//                                let navi = UINavigationController()
//                                let vc = LoginViewController()
//                                navi.pushViewController(vc, animated: true)
//                            }
                            break
                            completion?(response.result)
                        }
                    }
                default:
                    break
                }
                Alamofire.request(urlString.urlString,
                    method: method,
                    parameters: parameters,
                    encoding: encoding,
                    headers: header
                ).responseJSON { response in
                    completion?(response.result)
                }
            } else {
                completion?(response.result)
            }
//            if let error = response.error,
//                error.code == Api.Error.connectionAbort.code || error.code == Api.Error.connectionWasLost.code {
//                Alamofire.request(urlString.urlString,
//                    method: method,
//                    parameters: parameters,
//                    encoding: encoding,
//                    headers: header2
//                ).responseJSON { response in
//                    completion?(response.result)
//                }
//            } else {
//                completion?(response.result)
//            }
        }
        return request
    }


}
