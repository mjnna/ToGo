//
//  BaseViewController.swift
//  Mjnna_Delivery
//
//  Created by Moneer Khallaf on 12/10/2021.
//  Copyright © 2021 Webkul. All rights reserved.
//
import Foundation
import UIKit
import RxCocoa
import RxSwift
import MaterialComponents.MaterialActivityIndicator

class BaseViewController: UIViewController {
    
    let dispose = DisposeBag()
    let activityIndicator = MDCActivityIndicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindUI()
        bindData()
        bindValidations()
        bindCallbacks()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    /// setup ui like configure header view and ui styling
    func setupUI()  {
        
    }
    
    
    /// any subject related to ui like(Buttons, textfield ...etc)
    func bindUI()  {
        
    }
    
    func bindData()  {
        
    }
    /// any subject related to validation like(isValidPhone ...etc)
    func bindValidations()  {
        
    }
    
    /// any subject related to apis calls like(loading, error, success)
    func bindCallbacks()  {
        
    }
    
    func bindCallbacks(viewModel:BaseViewModel? = nil)  {
        viewModel?.loading.observeOn(MainScheduler.instance).bind {[weak self] loading in
            if let isLoading = loading {
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
        }.disposed(by: dispose)
        
        viewModel?.error.observeOn(MainScheduler.instance).bind{[weak self] (error) in
            if let err = error {
                self?.alert(message: err.error ?? "")
            }
        }.disposed(by: dispose)
    }
}
