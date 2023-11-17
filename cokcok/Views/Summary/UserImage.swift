//
//  CircleImage.swift
//  Landmarks
//
//  Created by 최지웅 on 2022/09/16.
//

import SwiftUI

struct UserImage: View {
    var user:User
    var width:CGFloat?
    var height:CGFloat?
    var body: some View {
        if(user.image != nil){
            AsyncImage(url: user.image){$0.resizable()} placeholder: {ProgressView()}
                .aspectRatio(contentMode: .fill)
                .frame(width:width,height:height)
                .clipShape(Circle())
                .overlay{
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 1)
        } else {
            Image("default").resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:width,height:height)
                .clipShape(Circle())
                .overlay{
                    Circle().stroke(.white, lineWidth: 4)
                }
                .shadow(radius: 1)
        }
    }
}

#Preview{
    VStack{
        UserImage(user: User.demo, width:100, height:100)
    }
}
