//
//  tabView.swift
//  poptify
//
//  Created by iOS Lab on 09/05/23.
//

import SwiftUI

struct tabView: View {
    @Binding var authToken: String?
    var body: some View {
        TabView{
            Group{
                SearchView(authToken: $authToken)
                    .tabItem{
                        Image(systemName: "magnifyingglass.circle")
                        Text("Search")
                    }
                InfoView()
                    .tabItem{
                        Image(systemName: "info.circle")
                        Text("Info")
                    }
            }.toolbarColorScheme(.dark, for: .tabBar)
        }.navigationBarBackButtonHidden(true)
        

    }
}
