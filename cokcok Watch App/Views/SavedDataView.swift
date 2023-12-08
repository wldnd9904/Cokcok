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
        ScrollView{
            VStack {
                HStack{
                    Button(action: {
                        if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            // 파일 경로 설정
                            let fileURL = containerURL.appendingPathComponent("test.txt")
                            
                            do {
                                // 파일에 문자열 쓰기
                                try "ㅎㅇ".write(to: fileURL, atomically: true, encoding: .utf8)
                                print("File 'test.txt' created with content 'ㅎㅇ'")
                                // 생성한 파일의 이름 목록 갱신
                                updateFileNames()
                            } catch {
                                print("Error creating file: \(error)")
                            }
                        }
                    }, label: {
                        Text("파일 생성")
                    })
                    Button(action: {
                        if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                            // 디렉토리 경로 설정
                            let directoryURL = containerURL.appendingPathComponent("testDirectory")
                            
                            do {
                                // 디렉토리 생성
                                try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
                                print("Directory 'testDirectory' created")
                                // 생성한 디렉토리의 이름 목록 갱신
                                updateFileNames()
                            } catch {
                                print("Error creating directory: \(error)")
                            }
                        }
                    }, label: {
                        Text("폴더 생성")
                    })
                }
                
                ForEach(fileNames, id: \.self) { fileName in
                    // 디렉토리와 파일 구분
                    let isDirectory = isDirectoryAtPath(fileName)
                    
                    HStack {
                        // 이름 클릭 시 파일 내용 보여줌
                        if isDirectory {
                            // 디렉토리일 경우 추가 동작 구현
                            NavigationLink(destination: DirectoryContentView(directoryURL: fileName)) {
                                Text(fileName)
                            }
                        } else {
                            // 파일일 경우 추가 동작 구현
                            NavigationLink(destination: FileContentView(fileName: fileName, dir:nil)) {
                                Text(fileName)
                            }
                        }
                        // x 버튼으로 삭제하기(디렉토리일 때도 동작)
                        Button(action: {
                            deleteItemAtPath(fileName)
                        }) {
                            Image(systemName: "xmark.circle")
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(width:30)
                        .buttonStyle(BorderedButtonStyle(tint:.red.opacity(255)))
                    }
                }
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
        .buttonBorderShape(.roundedRectangle)
    }

    // 파일 이름 목록 갱신
    private func updateFileNames() {
        if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let dataDirectoryURL = containerURL
            do {
                let fileURLs = try FileManager.default.contentsOfDirectory(at: dataDirectoryURL, includingPropertiesForKeys: nil, options: [])
                fileNames = fileURLs.map { $0.lastPathComponent }
            } catch {
                print("Error reading directory: \(error)")
            }
        }
    }

    // 경로가 디렉토리인지 확인
    private func isDirectoryAtPath(_ fileName: String) -> Bool {
        if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = containerURL.appendingPathComponent(fileName).path
            var isDirectory: ObjCBool = false
            return FileManager.default.fileExists(atPath: filePath, isDirectory: &isDirectory) && isDirectory.boolValue
        }
        return false
    }

    // 파일 또는 디렉토리 삭제
    private func deleteItemAtPath(_ fileName: String) {
        if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = containerURL.appendingPathComponent(fileName).path
            do {
                try FileManager.default.removeItem(atPath: filePath)
                print("Item deleted: \(fileName)")
                updateFileNames()
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
}
struct DirectoryContentView: View {
    let directoryURL: String

    var body: some View {
        if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        // 디렉토리 경로 설정
        let url = containerURL.appendingPathComponent(directoryURL)
            if let fileURLs = listFiles(inDirectory: url) {
                VStack{
                    List(fileURLs, id: \.self) { fileURL in
                        NavigationLink(destination: FileContentView(fileName: fileURL.lastPathComponent, dir:url)) {
                            Text(fileURL.lastPathComponent)
                        }
                    }
                }
            }
        } else {
            Text("Error reading directory content.")
        }
    }
    // 디렉터리 내의 파일 목록을 가져오는 함수
    func listFiles(inDirectory directoryURL: URL) -> [URL]? {
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: [])
            return fileURLs
        } catch {
            print("Error reading directory: \(error)")
            return nil
        }
    }

}

struct FileContentView: View {
    let fileName: String
    let dir:URL?

    var body: some View {
        if let fileContent = readFileContent(fileName: fileName, dir:dir) {
            ScrollView {
                Text(fileContent)
                    .padding()
            }
            .navigationTitle(fileName)
        } else {
            Text("Error reading file content.")
        }
    }

    // 파일 내용을 읽어오는 함수
    private func readFileContent(fileName: String, dir:URL?) -> String? {
        if let containerURL = dir {
            let fileURL = containerURL.appendingPathComponent(fileName)
            do {
                // 파일 내용을 문자열로 읽어오기
                let fileContent = try String(contentsOf: fileURL)
                return fileContent
            } catch {
                print("Error reading file content: \(error)")
                return nil
            }
        }
        if let containerURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = containerURL.appendingPathComponent(fileName)
            do {
                // 파일 내용을 문자열로 읽어오기
                let fileContent = try String(contentsOf: fileURL)
                return fileContent
            } catch {
                print("Error reading file content: \(error)")
                return nil
            }
        }
        return nil
    }
}
struct SavedDataView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack{
            SavedDataView()}
    }
}
