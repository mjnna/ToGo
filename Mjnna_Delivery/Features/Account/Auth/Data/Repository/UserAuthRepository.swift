//
//  UserRepository.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
import Moya
import RxSwift

protocol UserAuthRepository {
    func login(request: LoginRequest)-> Single<LoginResponse?>
}


class UserAuthDataRepository : UserAuthRepository {
    
    let disbose = DisposeBag()
    var remoteService: AuthApiService!
    
    init(remoteService: AuthApiService) {
        self.remoteService = remoteService
    }
    
    func login(request: LoginRequest) -> Single<LoginResponse?> {
        return Single<LoginResponse?>.create {[weak self] observer in
            guard let self = self else {
                return Disposables.create()
            }
            self.remoteService.login(request: request)
                .subscribe(onSuccess: { res in
                    if let res = res {
                        UserDefaultsAccess.shared.saveData(key: DefaultsConstantKeys.token, value: res.token)
                        UserDefaultsAccess.shared.saveData(key: DefaultsConstantKeys.user, value: res.user.toString() ?? "")
                    }
                    observer(.success(res))
                }, onError: { err in
                    observer(.error(err))
                }).disposed(by: self.disbose)
            
            return Disposables.create()
        }

    }
    

}
