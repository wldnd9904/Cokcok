//
//  User.swift
//	  cokcok
//
//  Created by 최지웅 on 11/14/23.
//

import Foundation
public struct User:Identifiable {
    public var id: UUID
    var name: String
    var image: URL?
    static var demo:User = User(
        id:UUID(),
        name:"최지웅",
        image:nil)
}
