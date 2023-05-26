//
//  ContentView.swift
//  poptify
//
//  Created by iOS Lab on 04/05/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthorized = false
    @State private var authToken: String?
    let clientId = "55fe2950ee8e4048910ed80594f3b7fa"
    let redirectUri = "poptify://callback"
    let clientSecret = "39ccd3042be1404580ad4d04d143d93f"
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.11, green: 0.16, blue: 0.21), Color(red: 0.23, green: 0.29, blue: 0.35)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                VStack {
                    Image("logo")
                    Text("Authorize Spotify")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Button(action: {
                        let authUrl = "https://accounts.spotify.com/authorize?client_id=\(clientId)&response_type=code&redirect_uri=\(redirectUri)"
                        if let url = URL(string: authUrl) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }) {
                        Text("Authorize")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8)
                    }
                    NavigationLink(destination: tabView(authToken: self.$authToken), isActive: self.$isAuthorized) {
                        EmptyView()
                    }
                }
            }
        }
        .accentColor(.green)
        .onOpenURL { url in
            guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                  let code = components.queryItems?.first(where: { $0.name == "code" })?.value else {
                return
            }
            // exchange the authorization code for an access token
            let tokenUrl = "https://accounts.spotify.com/api/token"
            let parameters = ["grant_type": "authorization_code", "code": code, "redirect_uri": redirectUri]
            var request = URLRequest(url: URL(string: tokenUrl)!)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Basic " + (clientId + ":" + clientSecret).data(using: .utf8)!.base64EncodedString(), forHTTPHeaderField: "Authorization")
            let requestBody = parameters.map { key, value in
                return "\(key)=\(value)"
            }.joined(separator: "&").data(using: .utf8)
            request.httpBody = requestBody
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                    print(error?.localizedDescription ?? "Unknown error")
                    return
                }
                
                guard response.statusCode == 200 else {
                    print("HTTP status code \(response.statusCode)")
                    return
                }
                
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let accessToken = json["access_token"] as! String
                self.authToken = accessToken
                self.isAuthorized = true
            }
            task.resume()
            
        }
    }
    
}

