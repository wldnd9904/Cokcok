//
//  Data+String.swift
//  cokcok
//
//  Created by 최지웅 on 12/4/23.
//

import Foundation

public extension Data {

    mutating func append(
        _ string: String,
        encoding: String.Encoding = .utf8
    ) {
        guard let data = string.data(using: encoding) else {
            return
        }
        append(data)
    }
}
