//
//  String.swift
//  Wedding App
//
//  Created by Mahesh Yakami on 1/7/20.
//

import Foundation

extension String {
    func toInt64() -> Int64{
        var returnValue:Int64 = 0
        if let num = Int64(self) {
            returnValue = num
        }
        return returnValue
    }
}

