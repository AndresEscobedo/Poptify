//
//  SplashView.swift
//  poptify
//
//  Created by iOS Lab on 05/05/23.
//

import Foundation
import SwiftUI

struct SplashView: View {
    
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            if self.isActive {
                ContentView()
            } else {
                Color.black
                    .ignoresSafeArea()
                VStack
                {
                    Spacer()
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    Spacer()
                    Text("By Andres Escobedo")
                        .foregroundColor(.green)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
        
}
