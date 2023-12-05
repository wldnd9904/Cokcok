//
//  AuthenticationManager.swift
//  cokcok
//
//  Created by 최지웅 on 11/18/23.
//

import Firebase
import FirebaseAuth
import GoogleSignIn
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import SwiftUI
import CryptoKit

enum AuthType: String, Codable {
    case google = "Google"
    case kakao = "카카오"
    case apple = "Apple"
    var image: Image {
        switch(self){
        case .apple: 
            Image(systemName: "apple.logo")
                .resizable()
        case .google:
            Image("google")
                .resizable()
        case .kakao:
            Image("kakao")
                .resizable()
        }
    }   
    func toAPI() -> String {
        switch(self){
        case .apple: "apple"
        case .google: "google"
        case .kakao: "kakao"
        }
    }
}

class AuthenticationManager: NSObject, ObservableObject {
    @Published var signState: signState = .signOut {
        didSet(oldVal){
            onLogin(uid,email,authType)
        }
    }
    let onLogin: (String?, String?, AuthType?) -> Void
    var uid:String?
    var email:String?
    var authType: AuthType?
    var currentNonce: String?
    var window: UIWindow?
    init(onLogin: @escaping (String?, String?, AuthType?) -> Void, uid: String? = nil, email: String? = nil, authType: AuthType? = nil, currentNonce: String? = nil, window: UIWindow? = nil) {
        self.onLogin = onLogin
        self.uid = uid
        self.email = email
        self.authType = authType
        self.currentNonce = currentNonce
        self.window = window
    }
    //이메일 회원가입
    func emailAuthSignUp(email: String, userName: String, password: String, completion: (() -> Void)?) {
            print("이메일로그인")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("이메일회원가입에러: \(error.localizedDescription)")
            }
            if result != nil {
                _ = Auth.auth().currentUser?.createProfileChangeRequest()
                //changeRequest?.displayName = userName
                print("사용자 이메일: \(String(describing: result?.user.email))")
            }
            
            completion?()
        }
    }
    //이메일 로그인
    func emailAuthSignIn(email: String, password: String) {
        print("이메일로그인")
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("이메일로그인 에러")
                print("error: \(error.localizedDescription)")
                return
            }
            
            if result != nil {
                self.uid = result?.user.uid
                self.email = result?.user.email
                self.authType = .kakao
                self.signState = .signIn
            }
        }
    }
    
    // google 로그인 절차
    func signIn() {
        // 1
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            // 2
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // 3
            let configuration = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = configuration
            
            // 4
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
            
            // 5
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) {[unowned self] result, error in
                guard let result = result else { return }
                authenticateUser(for: result.user, with: error)
            }
        }
    }
    
    // firebase 로그인 절차
    private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
        // 1
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        // 2
        guard let accessToken = user?.accessToken.tokenString, let idToken = user?.idToken?.tokenString else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        // 3
        Auth.auth().signIn(with: credential) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.uid = result?.user.uid
                self.email = result?.user.email
                self.authType = .google
                self.signState = .signIn
            }
        }
    }
    
    // 로그아웃 절차
    func signOut() {
        // 1
        GIDSignIn.sharedInstance.signOut()
        UserApi.shared.logout(completion: { error in
            print(error)
        })
        
        do {
            // 2
            try Auth.auth().signOut()
            self.uid = nil
            self.email = nil
            self.authType = nil
            self.signState = .signOut
        } catch {
            print(error.localizedDescription)
        }
    }
    
}
// MARK: - KakaoAuth SignIn Function
extension AuthenticationManager {
    func kakaoAuthSignIn() {
            print("카카오로그인")
        if AuthApi.hasToken() { // 발급된 토큰이 있는지
            UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
                if let error = error { // 에러가 발생했으면 토큰이 유효하지 않다.
                    self.openKakaoService()
                } else { // 유효한 토큰
                    self.loadingInfoDidKakaoAuth()
                }
            }
        } else { // 만료된 토큰
            self.openKakaoService()
        }
    }
    
    func openKakaoService() {
        print("오픈카카오서비스")
        if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
            UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
                if let error = error { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: ", error.localizedDescription)
                    return
                }
                
                _ = oauthToken // 로그인 성공
                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        } else { // 카카오톡 앱 이용 불가능한 사람
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
                if let error = error { // 로그인 실패 -> 종료
                    print("Kakao Sign In Error: ", error.localizedDescription)
                    return
                }
                _ = oauthToken // 로그인 성공
                self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
            }
        }
    }
    
    func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
        print("사용자정보불러오기")
        UserApi.shared.me { kakaoUser, error in
            if error != nil {
                print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
                
                return
            }
            guard let email = kakaoUser?.kakaoAccount?.email else { return }
            guard let password = kakaoUser?.id else { return }
            //guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
            
            self.emailAuthSignUp(email: email, userName: "", password: "\(password)") {
                self.emailAuthSignIn(email: email, password: "\(password)")
            }
        }
    }
}

//MARK: - Apple
extension AuthenticationManager {
    
    func startAppleLogin(window:UIWindow?) {
            self.window = window
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
extension AuthenticationManager: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            
            //Firebase 작업
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                self.uid = authResult?.user.uid
                self.email = authResult?.user.email
                self.authType = .apple
                self.signState = .signIn
            }
        }
    }
}
extension AuthenticationManager: ASAuthorizationControllerPresentationContextProviding {
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    window!
  }
}
struct WindowKey: EnvironmentKey {
    struct Value {
        weak var value: UIWindow?
    }
    
    static let defaultValue: Value = .init(value: nil)
}

extension EnvironmentValues {
    var window: UIWindow? {
        get {
            return self[WindowKey.self].value
        }
        set {
            self[WindowKey.self] = .init(value: newValue)
        }
    }
}
