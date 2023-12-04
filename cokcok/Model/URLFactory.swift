//
//  URLFactory.swift
//  cokcok
//
//  Created by 최지웅 on 12/4/23.
//

import Foundation

class URLFactory {
    private static let baseURL = "https://<Server IP>"
    
    // MARK: 1. URL: <Server IP>/accounts/info
    private static let accountsURL = "/accounts/info"
    //(GET) 마이페이지
    //req: token
    public static func getMyPageURLComponents(token: String) -> URLComponents {
        var ret:URLComponents = URLComponents(string: baseURL + accountsURL)!
        let parameters: [String: String] = [
            "token": token
        ]
        ret.queryItems = []
        parameters.forEach{ret.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))}
        return ret
    }
    
    //(POST) 회원가입
    //req: token, sex, years_playing, grade, handedness, email
    public static func getSignUpURLComponents(token: String, sex: Sex, yearsPlaying: Int, grade: Grade, handedness: Hand, email: String) -> URLComponents {
        var ret:URLComponents = URLComponents(string: baseURL + accountsURL)!
        let parameters: [String: String] = [
            "token": token,
            "sex": sex.rawValue,
            "years_playing": "\(yearsPlaying)",
            "grade": grade.rawValue,
            "handedness": handedness.rawValue,
            "email": email,
        ]
        ret.queryItems = []
        parameters.forEach{ret.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))}
        return ret
    }
    
    //(PUT) 개인정보 수정
    //req: POST와 동일
    public static func getEditUserURLComponents(token: String, sex: Sex, yearsPlaying: Int, grade: Grade, handedness: Hand, email: String) -> URLComponents {
        var ret:URLComponents = URLComponents(string: baseURL + accountsURL)!
        let parameters: [String: String] = [
            "token": token,
            "sex": sex.rawValue,
            "years_playing": "\(yearsPlaying)",
            "grade": grade.rawValue,
            "handedness": handedness.rawValue,
            "email": email,
        ]
        ret.queryItems = []
        parameters.forEach{ret.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))}
        return ret
    }
    
    //(DELETE) 회원탈퇴
    //req: token
    public static func getResignComponents(token: String) -> URLComponents {
        var ret:URLComponents = URLComponents(string: baseURL + accountsURL)!
        let parameters: [String: String] = [
            "token": token
        ]
        ret.queryItems = []
        parameters.forEach{ret.queryItems?.append(URLQueryItem(name: $0.key, value: $0.value))}
        return ret
    }
    
    
    
    // MARK: 2. URL: <Server IP>/process/achieve
    //(GET) 업적 조회
    //req: X
    //res: Achievement 테이블 컬럼 전부(ex achieve_id, achieve_nm, ..)
    //
    //(POST) 업적 생성 (관리자용)
    //req: Achievement 테이블 컬럼 전부
    //res: JsonResponse({"message":"업적을 생성하였습니다."})
    //
    //(DELETE) 업적 삭제
    //미구현
    //
    //3. URL: <Server IP>/process/achieve/player
    //(GET) 진행 중인 업적 조회 & 최근 달성 업적 조회
    //(진행 중인 업적 조회) req: token, "clear":0으로 설정해서 전달
    //              res: Player_Achievement 컬럼 전부 전달
    //(최근 달성 업적 조회) req: token, "clear":1로 설정해서 전달
    //              res: Player_Achievement 날짜순 정렬 상위 5개 전달
    //
    //
    //4. URL: <Server IP>/process/match
    //(GET) 경기기록 조회
    //
    //(전부 조회) req: token
    //        res: { "next": <Server IP>/process/match?limit=10&offset=10
    //         "result": offset 0번부터 9번까지의 Match_Record 테이블
    //          컬럼 전부, }
    //이때 Match_Record 튜플이 8개만 존재해서 offset=10 이상을 조회하는 next
    //URL이 의미가 없으면 "next": null로 전달
    //
    //(하나 조회) req: token, match_id
    //        res: 해당하는 Match_Record의 튜플 반환(match_id, score ..)
    //
    //(POST) 경기기록 생성 (구현 중 - 송고리즘 필요)
    //req: token, watch_file명으로 csv파일
    //res: JsonResponse({'start_date':2023-12-04 20:04:02, 'score_history':..})
    //와 같이 Match_Record 테이블의 컬럼에 대한 정보 전부 전달
    //(start_date, end_date, duration total_distance, total_energy_burned,
    //average_heart_rage, my_score, opponent_score, score_history, 12개의 스트로크
    //, watch_url, player_token)
    //
    //(DELETE) 경기기록 삭제
    //(하나 삭제) req: token, match_id
    //        res: JsonResponse({"message":"삭제하였습니다."})
    //
    //(초기화)    req: token
    //        res: JsonResponse({"message":"초기화하였습니다."})
    //
    //5. URL: <Server IP>/process/motion
    //(GET) 스윙 분석 데이터 전부 조회 & 하나 조회
    //(전부 조회) req: token
    //        res:  "next": <Server IP>/process/motion?limit=5&offset=5
    //        "result": Motion 테이블의 스키마에 대한 튜플 5개 전달
    //스윙 분석 데이터가 5개 이하면 offset=5인 URL은 필요없으니 "next":null 전달
    //
    //(하나 조회) req: token, motion_id
    //        res: motion_id에 해당하는 Motion 테이블 튜플 1개 전달
    //        ex) {"video_url": ,"watch_url", "pose_strength": , ..}
    //token이 존재하지않으면 {"message":"회원가입을 해주세요."}
    //
    //(POST) 스윙 분석 데이터 생성
    //req: token, video_file명으로 mp4파일, watch_file명으로 csv파일
    //res: {"video_url": ,"watch_url", "pose_strength": , ..}와 같은 형식으로
    //Motion 테이블 스키마 형식에 맞게 분석결과를 담아 정보 전달
    //(예외) mp4파일, csv파일 둘다 업로드를 안 했을 시에
    //       JsonResponse({"message":"회원가입을 해주세요."}) 전달
    //
    //(DELETE) 스윙 분석 데이터 삭제&초기화
    //(하나 삭제) req: token, motion_id
    //        res: JsonResponse({"message":"삭제하였습니다."})
    //(초기화)    req: token
    //        res: JsonResponse({"message":"초기화하였습니다."})
    //
}
