//
//  PopView.swift
//  poptify
//
//  Created by iOS Lab on 05/05/23.
//

import SwiftUI

struct PopView: View {
    @State var pop: Double
    @State var popAug: Double
    @State var popRef: Int
    @State var imgUrl: String
    @State var songName: String
    
    var body: some View {
        ZStack {
            LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                .ignoresSafeArea()
            VStack {
                
                AsyncImage(url: URL(string: imgUrl), scale: 2){ image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 300)
                .padding()
                
                Text("Reference: \(popRef)")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.bottom, 4)
                
                Text("Calculated: \(String(format: "%.2f", pop))")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.bottom, 4)
                
                Text("Calculated Aug: \(String(format: "%.2f", popAug))")
                    .foregroundColor(.white)
                    .font(.headline)
                
            }
            .padding(16)
            .background(Color.green)
            .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .navigationTitle(songName)
    }
}

