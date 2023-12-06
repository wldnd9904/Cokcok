//
//  TransportManager.swift
//  cokcok
//
//  Created by 최지웅 on 12/4/23.
//

import Foundation

public enum APIError: Error {
    case invalidURL
    case invalidRequest
    case requestFailed
    case invalidData
    case decodingError
    case timeOut
}

public struct MessageResponse: Codable {
    let message: String
}

public enum APIResponse<T: Codable> {
    case message(String)
    case codable(T)
}

public class APIManager {
    public static let shared = APIManager()
    private let baseURL = "http://118.32.109.123:8000"
    
    // MARK: - 1. URL: <Server IP>/accounts/info
    private let accountsURL = "/accounts/info"
    
    //(GET) 마이페이지
    //req: token
    //res: token에 따른 Player(선수)의 정보
    public func getMyPageInfo(token: String) async throws -> APIResponse<PlayerAPI> {
        let url = try makeURL(endpoint: accountsURL)
        let data = try await request(url, token, nil, "GET")
        return try decodeResponse(data: data)
    }
    
    //(POST) 회원가입
    //req: token, sex, years_playing, grade, handedness, email, sns
    //res: APIResponse({"message":"회원가입이 완료되었습니다."})
    func signUp(token: String, sex: Sex, yearsPlaying: Int, grade: Grade, handedness: Hand, email: String, authType: AuthType) async throws -> APIResponse<String> {
         let url = try makeURL(endpoint: accountsURL)
         let params: [String: Any] = [
             "sex": sex.toAPI(),
             "years_playing": yearsPlaying,
             "grade": grade.toAPI(),
             "handedness": handedness.toAPI(),
             "email": email,
             "sns": authType.toAPI()
         ]
        let data = try await request(url, token, params, "POST")
        return try decodeResponse(data: data)
     }
    
    //(PUT) 개인정보 수정
    //req: POST와 동일
    //res: APIResponse({"message":"개인정보 수정이 완료되었습니다."})
    func updateUserInfo(token: String, sex: Sex, yearsPlaying: Int, grade: Grade, handedness: Hand, email: String, authType: AuthType) async throws -> APIResponse<String> {
        let url = try makeURL(endpoint: accountsURL)
        let params: [String: Any] = [
            "sex": sex.toAPI(),
            "years_playing": yearsPlaying,
            "grade": grade.toAPI(),
            "handedness": handedness.toAPI(),
            "email": email,
            "sns": authType.toAPI()
        ]
        let data = try await request(url, token, params, "PUT")
        return try decodeResponse(data: data)
    }
     
    //(DELETE) 회원탈퇴
    //req: token
    //res: APIResponse({"message":"회원탈퇴 되었습니다."})
    //없는 token이면? : APIResponse({"message":"회원가입을 해주세요."})
    func withdraw(token: String) async throws -> APIResponse<String> {
        let url = try makeURL(endpoint: accountsURL)
        let data = try await request(url, token, nil, "DELETE")
        return try decodeResponse(data: data)
    }
    
    // MARK: - 2. URL: <Server IP>/process/achieve
    private let achieveTypeURL = "/process/achieve/"
    //(GET) 업적 조회
    //req: X
    //res: Achievement 테이블 컬럼 전부(ex achieve_id, achieve_nm, ..)
    func getAllAchievementTypes(token:String) async throws -> APIResponse<[AchievementAPI]> {
        let url = try makeURL(endpoint: achieveTypeURL)
        let data = try await request(url, token, nil, "GET")
        return try decodeResponse(data: data)
    }
    
    //(POST) 업적 생성 (관리자용)
    //req: Achievement 테이블 컬럼 전부
    //res: APIResponse({"message":"업적을 생성하였습니다."})
    //(DELETE) 업적 삭제
    //미구현
    
    
    // MARK: - 3. URL: <Server IP>/process/achieve/player
    private let achieveURL = "/process/achieve/player"
    //(GET) 진행 중인 업적 조회 & 최근 달성 업적 조회
    //(진행 중인 업적 조회) req: token, "clear":0으로 설정해서 전달
    //              res: Player_Achievement 컬럼 전부 전달
    func getAllAchievements(token: String) async throws -> APIResponse<[PlayerAchievementAPI]> {
        let url = try makeURL(endpoint: achieveURL+"?clear=0")
        let data = try await request(url, token, nil, "GET")
        return try decodeResponse(data: data)
    }
    
    //(최근 달성 업적 조회) req: token, "clear":1로 설정해서 전달
    //              res: Player_Achievement 날짜순 정렬 상위 5개 전달
    func getRecentAchievements(token: String) async throws -> APIResponse<[PlayerAchievementAPI]> {
        let url = try makeURL(endpoint: achieveURL+"?clear=1")
        let data = try await request(url,token, nil, "GET")
        return try decodeResponse(data: data)
    }
    
    // MARK: - 4. URL: <Server IP>/process/match
    private let matchURL = "/process/match"
    //(GET) 경기기록 조회
    //(전부 조회) req: token
    //        res: { "next": <Server IP>/process/match?limit=10&offset=10
    //         "result": offset 0번부터 9번까지의 Match_Record 테이블
    //          컬럼 전부, }
    //이때 Match_Record 튜플이 8개만 존재해서 offset=10 이상을 조회하는 next
    //URL이 의미가 없으면 "next": null로 전달
    func getMatches(token: String, limit:Int, offset:Int) async throws -> APIResponse<[MatchAPI]> {
        let url = try makeURL(endpoint: matchURL)
        let params: [String: Any] = [
            "limit": limit,
            "offset": offset
        ]
        let data = try await request(url,token, params, "GET")
        return try decodeResponse(data: data)
    }
    
    //(하나 조회) req: token, match_id
    //        res: 해당하는 Match_Record의 튜플 반환(match_id, score ..)
    //
    func getMatch(token: String, matchID: String) async throws -> APIResponse<MatchAPI> {
        let url = try makeURL(endpoint: matchURL)
        let params: [String: Any] = [
            "match_id": matchID
        ]
        let data = try await request(url,token, params, "GET")
        return try decodeResponse(data: data)
    }
    
    //(POST) 경기기록 생성 (구현 중 - 송고리즘 필요)
    //req: token, watch_file명으로 csv파일
    //res: APIResponse({'start_date':2023-12-04 20:04:02, 'score_history':..})
    //와 같이 Match_Record 테이블의 컬럼에 대한 정보 전부 전달
    //(start_date, end_date, duration total_distance, total_energy_burned,
    //average_heart_rage, my_score, opponent_score, score_history, 12개의 스트로크
    //, watch_url, player_token)
    //
    //(DELETE) 경기기록 삭제
    //(하나 삭제) req: token, match_id
    //        res: APIResponse({"message":"삭제하였습니다."})
    func deleteMatch(token: String, matchID: String) async throws -> APIResponse<String> {
        let url = try makeURL(endpoint: matchURL)
        let params: [String: Any] = [
            "match_id": matchID
        ]
        let data = try await request(url, token,params, "DELETE")
        return try decodeResponse(data: data)
    }
    //(초기화)    req: token
    //        res: APIResponse({"message":"초기화하였습니다."})
    //
    func deleteAllMatches(token: String) async throws -> APIResponse<String> {
        let url = try makeURL(endpoint: matchURL)
        let data = try await request(url, token,nil, "DELETE")
        return try decodeResponse(data: data)
    }
    
    
    // MARK: - 5. URL: <Server IP>/process/motion
    private let motionURL = "/process/motion"
    //(GET) 스윙 분석 데이터 전부 조회 & 하나 조회
    //(전부 조회) req: token
    //        res:  "next": <Server IP>/process/motion?limit=5&offset=5
    //        "result": Motion 테이블의 스키마에 대한 튜플 5개 전달
    //스윙 분석 데이터가 5개 이하면 offset=5인 URL은 필요없으니 "next":null 전달
    func getSwingAnalyzes(token: String, limit:Int, offset:Int) async throws -> APIResponse<[MotionAPI]> {
        let url = try makeURL(endpoint: motionURL)
        let params: [String: Any] = [
            "limit": limit,
            "offset": offset
        ]
        let data = try await request(url,token, params, "GET")
        return try decodeResponse(data: data)
    }
    
    //(하나 조회) req: token, motion_id
    //        res: motion_id에 해당하는 Motion 테이블 튜플 1개 전달
    //        ex) {"video_url": ,"watch_url", "pose_strength": , ..}
    //token이 존재하지않으면 {"message":"회원가입을 해주세요."}
    func getSwingAnalyze(token: String) async throws -> APIResponse<MotionAPI> {
        let url = try makeURL(endpoint: motionURL)
        let data = try await request(url, token, nil, "GET")
        return try decodeResponse(data: data)
    }
    
    //TODO: (POST) 스윙 분석 데이터 생성
    //req: token, video_file명으로 mp4파일, watch_file명으로 csv파일
    //res: {"video_url": ,"watch_url", "pose_strength": , ..}와 같은 형식으로
    //Motion 테이블 스키마 형식에 맞게 분석결과를 담아 정보 전달
    //(예외) mp4파일, csv파일 둘다 업로드를 안 했을 시에
    //       APIResponse({"message":"회원가입을 해주세요."}) 전달
    //
    func uploadSwing(token: String, videoURL: URL, motionDataURL: URL, onDone: @escaping (APIResponse<MotionAPI>) -> Void) throws {
        let url = try makeURL(endpoint: motionURL)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        // Video File
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"video_file\"; filename=\"video.mp4\"\r\n")
        body.append("Content-Type: video/mp4\r\n\r\n")
        body.append(try! Data(contentsOf: videoURL))
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
            if let error = error {
                onDone(.message("에러"))
            } else if let data = data {
                do{
                    let response:APIResponse<MotionAPI> = try self.decodeResponse(data: data)
                    onDone(response)
                } catch {
                    onDone(.message("에러"))
                }
            }
        }
        task.resume()
    }
    //(DELETE) 스윙 분석 데이터 삭제&초기화
    //(하나 삭제) req: token, motion_id
    //        res: APIResponse({"message":"삭제하였습니다."})
    func deleteSwing(token: String, swingID: String) async throws -> APIResponse<String> {
        let url = try makeURL(endpoint: motionURL)
        let params: [String: Any] = [
            "motion_id": swingID
        ]
        let data = try await request(url,token ,params, "DELETE")
        return try decodeResponse(data: data)
    }
    //(초기화)    req: token
    //        res: APIResponse({"message":"초기화하였습니다."})
    //
    func deleteAllSwings(token: String) async throws -> APIResponse<String> {
        let url = try makeURL(endpoint: motionURL)
        let data = try await request(url, token, nil, "DELETE")
        return try decodeResponse(data: data)
    }
}

// MARK: - Helper public Functions

extension APIManager {
    public func request(_ url: URL, _ authToken: String, _ parameters: [String: Any]?, _ type:String) async throws -> Data {
        print(type + " 요청 시도")
        print(url)
        print(authToken)
        print(parameters)
        var requestURL = URLRequest(url:url)
        requestURL.httpMethod = type
        requestURL.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        if let parameters = parameters {
            // Content-Type을 application/json으로 설정
            requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type")
            // 딕셔너리를 JSON 데이터로 변환
            let jsonData = try JSONSerialization.data(withJSONObject: parameters)
            // JSON 데이터를 httpBody에 추가
            requestURL.httpBody = jsonData
        }
        let (data, response) = try await URLSession.shared.data(for: requestURL)
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200..<300).contains(statusCode) else {
            throw APIError.invalidRequest
        }
        return data
    }
     public func makeURL(endpoint: String) throws -> URL {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        return url
    }
    
     public func decodeResponse<T: Decodable>(data: Data) throws -> APIResponse<T> {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        do {
            // 시도해보고 성공하면 Codable 타입으로 처리
            let result = try? decoder.decode(T.self, from: data)
            return .codable(result!)
        } catch {
            // 실패하면 String으로 처리
            let messageResponse = try decoder.decode(MessageResponse.self, from: data)
            return .message(messageResponse.message)
        }
    }
}
