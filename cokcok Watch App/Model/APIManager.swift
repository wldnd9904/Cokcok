//
//  APIManager.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 12/8/23.
//

import SwiftUI

class APIManager {
    static let shared = APIManager()
    func uploadMatch(token: String, metaDataURL: URL, motionDataURL: URL, onDone: @escaping () -> Void, onError: @escaping () -> Void) throws {
        let url = URL(string:"http://118.32.109.123:8000/process/match")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        // Video File
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"metadata_file\"; filename=\"metadata.json\"\r\n")
        body.append("Content-Type: text/json\r\n\r\n")
        body.append(try! Data(contentsOf: metaDataURL))
        body.append("\r\n")
        
        // Watch File
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"watch_file\"; filename=\"watch.csv\"\r\n")
        body.append("Content-Type: text/csv\r\n\r\n")
        body.append(try! Data(contentsOf: motionDataURL))
        body.append("\r\n")
        
        body.append("--\(boundary)--\r\n")
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error{
                print(error.localizedDescription)
                onError()
            }else {
                onDone()
            }
        }
        task.resume()
    }
}
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
