//
//  ThinkListController.swift
//  Reverie
//
//  Created by 이예인 on 9/30/23.
//

import SwiftUI

struct ThinkListController: View {
    var body: some View {
        List {
            Text("ㅋㅋ")
            Text("ㅇㅇ")
            Text("ㅇㅇ")
            Text("ㅇㅇ")
        }
        .scrollContentBackground(.hidden)
        .overlay(alignment: .bottom) {
            Button {
                
            } label: {
                HStack {
                    Image(systemName: "pencil.and.outline")
                        .bold()
                    Text("Write")
                        .bold()
                }
                .foregroundStyle(.black)
            }
            .padding(10)
            .padding(.horizontal, 15)
            .background(
                Capsule(style: .continuous)
                    .strokeBorder(Color(red: 180/255, green: 180/255, blue: 180/255), lineWidth: 1.5)
                    .background(Capsule().fill(Color(red: 240/255, green: 241/255, blue: 242/255)))
            )
            .offset(y: -20)
//            Button(action: {
//                print("Button tapped!")
//            }) {
//                HStack {
//                    Image(systemName: "pencil.and.outline")
//                        .foregroundColor(.yellow)
//                    Text("Label")
//                        .fontWeight(.bold)
//                        .font(.title)
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//            }
        }
    }
}

#Preview {
    ThinkListController()
}
