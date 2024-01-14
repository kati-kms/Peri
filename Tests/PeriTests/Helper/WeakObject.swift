//
//  WeakObject.swift
//  
//
//  Created by 강민석 on 2024/01/14.
//

import Foundation

final class WeakObject<T: AnyObject> {
    
    private(set) weak var value: T!
    
    init(_ v: T!) {
        value = v
    }
}
