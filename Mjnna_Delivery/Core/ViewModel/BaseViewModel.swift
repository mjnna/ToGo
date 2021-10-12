//
//  BaseViewModel.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    let error = PublishSubject<ApiError?>()
    let loading = PublishSubject<Bool?>()
    let success = PublishSubject<Bool?>()
    var pop = PublishSubject<Void>()
    let dispose = DisposeBag()
    
}
