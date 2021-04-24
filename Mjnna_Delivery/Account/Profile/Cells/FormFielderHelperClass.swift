//
/**
MobikulOpencartMp
@Category Webkul
@author Webkul <support@webkul.com>
FileName: FormFielderHelperClass.swift
Copyright (c) 2010-2018 Webkul Software Private Limited (https://webkul.com)
@license   https://store.webkul.com/license.html
*/

import Foundation


enum FormFielderType{
    case emailTextField, normalTextField,phonetextField,passwordTextField
}


protocol FormFieldTextValueHandler {
    func getFormFieldValue(val:String,type:String)
    
}
