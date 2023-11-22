//
//  MatchDataManager.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/11/23.
//

import Foundation
import CoreMotion

class DataManager {
    static var shared = DataManager()
    
    // JSON 파일에 저장하는 함수
    func saveToJSONFile<T: Encodable>(_ data: T, to filePath: URL) throws {
        do {
            let jsonData = try JSONEncoder().encode(data)
            try jsonData.write(to: filePath)
            print("Data saved to \(filePath)")
        } catch {
            throw error
        }
    }
    // JSON 파일에서 데이터를 읽어오는 함수
    func loadFromJSONFile<T: Decodable>(_ type: T.Type, from filePath: URL) -> T? {
        do {
            let jsonData = try Data(contentsOf: filePath)
            let decodedData = try JSONDecoder().decode(type, from: jsonData)
            print("Data loaded from \(filePath)")
            return decodedData
        } catch {
            print("Error loading data from \(filePath): \(error)")
            return nil
        }
    }
    // CSV로 저장하는 함수
    func saveMotionDataToCSV(_ motionData: [CMDeviceMotion], filePath: URL, xyReversed:Bool = false) throws {
        var csvText = "Timestamp,AccelerationX,AccelerationY,AccelerationZ,Pitch,Yaw,Roll,RRX,RRY,RRZ\n"
        for snapshot in motionData {
            if xyReversed {
                // x, y, pitch, yaw, rotationRate.x, rotationRate.y 등을 반전
                let newLine = "\(snapshot.timestamp),\(-snapshot.userAcceleration.x),\(-snapshot.userAcceleration.y),\(snapshot.userAcceleration.z),\(-snapshot.attitude.pitch),\(-snapshot.attitude.yaw),\(snapshot.attitude.roll),\(-snapshot.rotationRate.x),\(-snapshot.rotationRate.y),\(snapshot.rotationRate.z)\n"
                csvText.append(newLine)
            } else {
                // 반전하지 않음
                let newLine = "\(snapshot.timestamp),\(snapshot.userAcceleration.x),\(snapshot.userAcceleration.y),\(snapshot.userAcceleration.z),\(snapshot.attitude.pitch),\(snapshot.attitude.yaw),\(snapshot.attitude.roll),\(snapshot.rotationRate.x),\(snapshot.rotationRate.y),\(snapshot.rotationRate.z)\n"
                csvText.append(newLine)
            }
        }

        do {
            try csvText.write(to: filePath, atomically: true, encoding: .utf8)
            print("Motion data saved to \(filePath)")
        } catch {
            throw error
        }
    }
}
