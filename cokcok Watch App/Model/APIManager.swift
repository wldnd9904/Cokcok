//
//  APIManager.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 12/8/23.
//

import SwiftUI
struct MessageResponse: Codable {
   let message: String
}
enum APIResponse<T: Codable> {
   case message(String)
   case codable(T)
}
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
                do{
                    let response:APIResponse<MessageResponse> = try self.decodeResponse(data: data!)
                    switch(response){
                    case .codable( let messagevalue):
                        print(messagevalue.message)
                        if messagevalue.message == "경기 기록이 성공적으로 업로드 되었습니다." {
                            onDone()
                        } else {
                            onError()}
                    case .message(let messagevalue):
                        print(messagevalue)
                        if messagevalue == "경기 기록이 성공적으로 업로드 되었습니다." {
                            onDone()
                        } else {
                            onError()}
                    }
                } catch {
                    onError()
                }
            }
        }
        task.resume()
    }
    
    func decodeResponse<T: Decodable>(data: Data) throws -> APIResponse<T> {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        print(data)
        print(String(data:data, encoding: .utf8)!)
        do {
            // 시도해보고 성공하면 Codable 타입으로 처리
            let result = try decoder.decode(T.self, from: data)
            return .codable(result)
        } catch {
            // 실패하면 String으로 처리
            do{
                let messageResponse = try decoder.decode(MessageResponse.self, from: data)
                return .message(messageResponse.message)
            } catch {
                //또 실패하면 그냥 string
                let messageResponse = try decoder.decode(String.self, from: data)
                return .message(messageResponse)
            }
        }
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
