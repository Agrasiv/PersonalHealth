//
//  BaseViewModel.swift
//  PersonalizeApp
//
//  Created by Pyae Phyo Oo on 12/10/2024.
//

import Foundation
import Combine

class BaseViewModel {
    
    var bindings = Set<AnyCancellable>()
    let isDecodeError = PassthroughSubject<String,Never>()
}
