//
//  Date.swift
//  cokcok
//
//  Created by 최지웅 on 11/8/23.
//

import Foundation

func formatDateString(for date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd" // 입력된 날짜 포맷
    
    // 한글 로케일 설정
    dateFormatter.locale = Locale(identifier: "ko_KR")
    
    // 현재 날짜와 시간을 얻음
    let currentDate = Date()
    
    let calendar = Calendar.current
    let dateComponents = calendar.dateComponents([.day], from: date, to: currentDate)
    
    if calendar.isDateInToday(date) {
        return "오늘"
    }
    else if calendar.isDateInYesterday(date) {
        return "어제"
    }
    else if dateComponents.day ?? 0 < 7 {
        dateFormatter.dateFormat = "EEEE" // 요일 표시
        return dateFormatter.string(from: date)
    }
    else if dateComponents.day ?? 0 < 365 {
        dateFormatter.dateFormat = "MM월 dd일"
        return dateFormatter.string(from: date)
    }
    else {
        dateFormatter.dateFormat = "yyyy년 MM월"
        return dateFormatter.string(from: date)
    }
}

func formatDateWithDay(_ date: Date) -> String {
    let calendar = Calendar.current
    let currentYear = calendar.component(.year, from: Date())
    let year = calendar.component(.year, from: date)
    
    let dateFormatter = DateFormatter()
    // 한글 로케일 설정
    dateFormatter.locale = Locale(identifier: "ko_KR")
    if currentYear == year {
        // 올해인 경우
        dateFormatter.dateFormat = "M월 d일 (EEEE)"
        return dateFormatter.string(from: date)
    } else {
        // 올해가 아닌 경우
        dateFormatter.dateFormat = "y년 M월 d일 (EEEE)"
        return dateFormatter.string(from: date)
    }
}

func formatTimeIntervalDuration(_ duration: TimeInterval, showseconds:Bool = false) -> String {
    let timeInSeconds = Int(duration)
    let hours = timeInSeconds / 3600
    let minutes = (timeInSeconds % 3600) / 60
    let seconds = timeInSeconds % 60

    if showseconds {
        return String(format: "\(hours):%02d:%02d", minutes, seconds)
    } else {
        return String(format: "\(hours):%02d", minutes)
    }
}
