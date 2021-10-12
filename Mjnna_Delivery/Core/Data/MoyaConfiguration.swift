//
//  MoyaConfiguration.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
import Moya
import Alamofire
import RxSwift

class AppMoyaProvider<T: TargetType>: MoyaProvider<T> {
    init() {
        #if DEBUG
        super.init(session: DefaultAlamofireManager.sharedManager, plugins:
                    [NetworkLoggerPlugin(configuration:
                                            .init(formatter: .init(responseData: JSONResponseDataFormatter),
                                                  logOptions: .verbose))])
        #else
        super.init(session: DefaultAlamofireManager.sharedManager)
        #endif
    }
}

class DefaultAlamofireManager: Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 60 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}


extension Reactive where Base: MoyaProviderType {
    func request(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        if token is AuthApi {
            return getRequest(token, callbackQueue: callbackQueue).filterSuccessfulStatusCodes()
        }
        return getRequest(token, callbackQueue: callbackQueue)
//            .retryWhenTokenExpired()
            .filterSuccessfulStatusCodes()
    }
    
    func getRequest(_ token: Base.Target, callbackQueue: DispatchQueue? = nil) -> Single<Response> {
        return Single.create { [weak base] single in
            let cancellableToken = base?.request(token, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case let .success(response):
                    single(.success(response))
                case let .failure(error):
                    single(.error(error))
                }
            }
            return Disposables.create {
                cancellableToken?.cancel()
            }
        }
    }
}




extension TargetType {
    
    /// The type of validation to perform on the request. Default is `.none`.
    var refershAuthRequierd: Bool {
        return true
    }
}

enum TokenError: Swift.Error {
    case tokenExpired
}

extension Swift.Error {
    var apiError: ApiError? {
        if let json = try? (self as? MoyaError)?.response?.mapJSON() as? [String: Any] {
            if let error = json?["error"] as? String {
                return ApiError(apiCode: (self as? MoyaError)?.response?.statusCode, msg: error)
            }
        } else {
            return ApiError(apiCode: (self as? MoyaError)?.response?.statusCode,
                            msg: "unknown_error".localized)
        }
        return ApiError(apiCode: (self as? MoyaError)?.response?.statusCode,
                        msg: "unknown_error".localized)
    }
    
    func throwError() -> Swift.Error {
        if let err = self as? MoyaError {
            if let apiError = err.apiError {
                #if DEBUG
//                print("->>>>>-", err.apiError?. ?? "")
                #endif
                return apiError
            } else {
                if let underlingError = err.errorUserInfo[NSUnderlyingErrorKey] as? AFError {
                    return getLocalError(err: underlingError)
                } else {
                    return ApiError(apiCode: (self as? MoyaError)?.response?.statusCode, msg: "unknown_error".localized)
                }
            }
        }
        return self
    }

    private func getLocalError(err: AFError) -> ApiError {
        switch err {
        case .sessionTaskFailed(let sessionError):
            if let urlError = sessionError as? URLError {
                if urlError.code == .notConnectedToInternet || urlError.code == .timedOut {
                    return ApiError(msg: "No_Internet".localized)
                } else {
                    #if DEBUG
                    print(urlError.localizedDescription)
                    #endif
                    return ApiError(msg: "unknown_error".localized)
                }
            } else {
                #if DEBUG
                print(sessionError.localizedDescription)
                #endif
                return ApiError(msg: "unknown_error".localized)
            }
        default:
            return ApiError(msg: "unknown_error".localized)
        }
    }


}

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
//    func retryWhenTokenExpired() -> Single<Element> {
//        return flatMap {
//            if $0.statusCode == 401 {
//                throw TokenError.tokenExpired
//            } else {
//                return Single.just($0)
//            }
//        }
//        .retryWhen { (error: Observable<TokenError>) in
//            error.flatMap { err -> Single<Bool> in
//                Single<Bool>.create { observer in
//                    AuthServiceManager.shared.referchToken()
//                        .subscribe(onSuccess: { _ in
//                            observer(.success(true))
//                        }, onError: { err in
//                            UserDefaultsAccess.sharedInstance.clearAllUserData()
//                            NotificationCenter.default.post(name: Notification.Name(rawValue: NotificationNames.NOTIFICATION_NAME_LOGOUT), object: nil, userInfo: nil)
//                            observer(.error(err))
//                        })
//                }
//            }
//        }
//        .retry(1)
//    }
}

