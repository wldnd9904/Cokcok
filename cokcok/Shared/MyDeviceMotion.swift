//
//  MyDeviceMotion.swift
//  cokcok
//
//  Created by 최지웅 on 11/7/23.
//


import Foundation

//임시
struct MyDeviceMotion: Encodable {
    var timestamp: TimeInterval
    var attitude: MyAttitude
    var userAcceleration: MyAcceleration

    struct MyAttitude: Encodable {
        var pitch: String
        var yaw: String
        var roll: String
    }
    struct MyAcceleration: Encodable {
        var x: String
        var y: String
        var z: String
    }
}
