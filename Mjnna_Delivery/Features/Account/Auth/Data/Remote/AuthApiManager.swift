//
//  AuthApiManager.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Moya
import RxSwift


protocol AuthApiService {
    func login(request: LoginRequest) -> Single<LoginResponse?>
}

class AuthApiDataManager: AuthApiService {
    
    let provider = AppMoyaProvider<AuthApi>()
    
    func login(request: LoginRequest) -> Single<LoginResponse?> {
        return provider.rx
            .request(.login(request: request))
            .map(LoginResponse?.self)
            .catchError { error in
                throw error.throwError()
            }
    }
    
}
