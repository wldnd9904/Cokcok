//
//  MyDeviceMotion.swift
//  cokcok
//
//  Created by 최지웅 on 11/7/23.
//

import Foundation
import CoreMotion

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

//1프레임 모션데이터
struct MotionDataSnapshot: Codable {
    let timestamp: TimeInterval
    let accelerationX: Double
    let accelerationY: Double
    let accelerationZ: Double
    let pitch: Double
    let yaw: Double
    let roll: Double
}

//전체 모션데이터
struct MotionData: Codable {
    let motionDataSnapshots: [MotionDataChunk]
}

//모션데이터 청크
struct MotionDataChunk: Codable {
    let date: Date
    let data: [MotionDataSnapshot]
    let seqNo: Int
    public static var counter: Int = 0
    
    init(date: Date, motiondata: [CMDeviceMotion]) {
        self.date = date
        let motiondata = motiondata.map { data in
            MotionDataSnapshot(timestamp: data.timestamp, accelerationX: data.userAcceleration.x, accelerationY: data.userAcceleration.y, accelerationZ: data.userAcceleration.z, pitch:data.attitude.pitch, yaw: data.attitude.yaw, roll:data.attitude.roll)
        }
        self.data = motiondata
        self.seqNo = MotionDataChunk.counter
        MotionDataChunk.counter += 1
    }
    
    static func clearCounter() {
        counter = 0
    }
    
    func encodeIt() -> Data {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self) {
            return encoded
        }
        
        return Data()
    }
    
    static func decodeIt(_ data: Data) -> MotionDataChunk {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(MotionDataChunk.self, from: data) {
            return decoded
        }
        
        return MotionDataChunk(date: Date(), motiondata: [])
    }
    
    func createMotionDataCSV() -> String {
        data.reduce("") { partialResult, snapshot in
            partialResult + "\(snapshot.timestamp),\(snapshot.accelerationX),\(snapshot.accelerationY),\(snapshot.accelerationZ),\(snapshot.pitch),\(snapshot.yaw),\(snapshot.roll)\n"
        }
    }
}
