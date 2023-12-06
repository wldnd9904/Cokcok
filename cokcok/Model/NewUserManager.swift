//
//  NewUserManager.swift
//  cokcok
//
//  Created by 최지웅 on 11/29/23.
//

import Foundation
import SwiftUI

enum Question: Int {
    case greeting=0, greeting2, gender, year ,grade, hand, done
    var message: String {
        switch(self){
        case .greeting:"반갑습니다."
        case .greeting2:"시작하기 전에 간단한 질문을 드리겠습니다."
        case .gender:"당신의 성별은 무엇인가요?"
        case .year:"배드민턴을 얼마나 치셨나요?"
        case .grade:"배드민턴 등급이 있나요?"
        case .hand:"배드민턴 라켓은 어느 손으로 잡으시나요?"
        case .done:"이제 시작해 봅시다."
        }
    }
    func next() -> Question {
        return Question(rawValue:self.rawValue + 1)!
    }
    func prev() -> Question {
        return Question(rawValue:self.rawValue - 1)!
    }
}

class NewUserManager: ObservableObject {
    @Published var question: Question = .greeting
    @Published var showMessage: Bool = false
    @Published var showSelection: Bool = false
    @Published var selectable: Bool = true
    let onDone: (User) -> Void
    let id: String
    let email: String
    var authType: AuthType
    var hand: Hand?
    var sex: Sex?
    var grade: Grade?
    var years: Int?
    init(id: String, email:String, authType:AuthType, onDone:@escaping (User) -> Void){
        self.id = id
        self.email = email
        self.authType = authType
        self.onDone = onDone
    }
    func done() {
        onDone(makeUser())
    }
    func start() {
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showMessage = true
                // Hide greeting message after 1 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.showMessage = false
                    // Hide selection after 1 second
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.question = self.question.next()
                        self.showMessage = true
                        // Show the next question message after 1 second
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.showMessage = false
                            // Hide the next question message after 1 second
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.showMessage = true
                                self.question = self.question.next()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                    self.showSelection = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    func next(action: () -> ()) {
        if !selectable {return}
        self.selectable = false
        action()
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showMessage = false
                self.showSelection = false
                self.question = self.question.next()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showSelection = true
                        self.selectable = true
                    }
                }
            }
        }
    }
    func prev() {
        if !selectable {return}
        self.selectable = false
        withAnimation {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showMessage = false
                self.showSelection = false
                self.question = self.question.prev()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.showSelection = true
                        self.selectable = true
                    }
                }
            }
        }
    }
    func makeUser() -> User {
        User(id: id, email: email, authType: authType, hand: hand!, sex: sex!, grade: grade!, years: years!)
    }
}
