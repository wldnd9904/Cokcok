//
//  SavedDataView.swift
//  cokcok Watch App
//
//  Created by 최지웅 on 11/11/23.
//

import SwiftUI

struct SavedDataView: View {
    @State private var fileNames: [String] = []

    var body: some View {
        VStack{
            Button(action: {
                if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    // 파일 경로 설정
                    let fileURL = containerURL.appendingPathComponent("test.txt")

                    do {
                        // 파일에 문자열 쓰기
                        try "ㅎㅇ".write(to: fileURL, atomically: true, encoding: .utf8)
                        print("File 'test.txt' created with content 'ㅎㅇ'")
                    } catch {
                        print("Error creating file: \(error)")
                    }
                }
            }, label: {
                Text("파일하나 생성")
            })
            List(fileNames, id: \.self) { fileName in
                Text(fileName)
            }
        }
        .onAppear {
            // WatchOS 컨테이너 디렉토리 경로 가져오기
            if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                // 파일이 저장된 디렉토리 경로 설정
                let dataDirectoryURL = containerURL

                do {
                    // 디렉토리 내의 파일 목록 가져오기
                    let fileURLs = try FileManager.default.contentsOfDirectory(at: dataDirectoryURL, includingPropertiesForKeys: nil, options: [])

                    // 파일 목록을 배열에 저장
                    fileNames = fileURLs.map { $0.lastPathComponent }
                } catch {
                    print("Error reading directory: \(error)")
                }
            }
        }
    }
}

#Preview {
    SavedDataView()
}
