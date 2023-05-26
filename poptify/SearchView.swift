//
//  SearchView.swift
//  poptify
//
//  Created by iOS Lab on 04/05/23.
//

import Foundation
import SwiftUI
import CoreML

struct SearchView: View {
    @Binding var authToken: String?
    
    @State private var imgUrl = ""
    @State private var showImg = false
    @State private var songName = ""
    @State private var danceability = 0.0
    @State private var energy = 0.0
    @State private var bpm = 0.0
    @State private var val = 0.0
    @State private var acous = 0.0
    @State private var dur = 0.0
    @State private var spch = 0.0
    @State private var popRef = 0
    @State private var popAug = 0.0
    @State private var obtainedSong = false
    
    @State private var pop: Double = 0.0
    
    var body: some View {
        ZStack
        {
            LinearGradient(gradient: Gradient(colors: [Color(red: 0.11, green: 0.16, blue: 0.21), Color(red: 0.23, green: 0.29, blue: 0.35)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                if imgUrl == ""
                {
                    Image("Spoty")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                        .padding()
                }
                else
                {
                    AsyncImage(url: URL(string: imgUrl), scale: 2){ image in
                        image.resizable()
                    } placeholder: {
                        Image("Spoty")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 300)
                            .padding()
                    }
                    .frame(width: 300, height: 300)
                    .padding()
                }
                TextField("Song Name", text: $songName)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5)
                    .padding(.bottom, 20)
                if obtainedSong == false
                {
                    Button(action: {
                        searchSong()
                    }, label: {
                        Text("Search")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.green)
                            .cornerRadius(5)
                            .font(.headline)
                    })
                }
                Text("Danceability: \(String(format: "%.2f", danceability))")
                    .foregroundColor(.white)
                Text("Energy: \(String(format: "%.2f", energy))")
                    .foregroundColor(.white)
                Text("BPM: \(String(format: "%.2f", bpm))")
                    .foregroundColor(.white)
                if obtainedSong
                {
                    HStack{
                        Button(action: {
                                self.resetFeatures()
                            }) {
                                Text("Reset search")
                                    .padding()
                                    .background(Color.red)
                                    .cornerRadius(5)
                                    .foregroundColor(.white)
                                    .font(.headline)
                            }
                        NavigationLink(destination: PopView(pop: self.pop, popAug: self.popAug, popRef: self.popRef, imgUrl: self.imgUrl, songName: self.songName), label: {
                            Text("Get Popularity")
                                .padding()
                                .background(Color.green)
                                .cornerRadius(5)
                                .foregroundColor(.white)
                                .font(.headline)
                        })
                    }
                }
                
            }
            .padding()
            
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Search")
        .onAppear{
            resetFeatures()
        }
    }
    private func resetFeatures(){
        self.popRef = 0
        self.imgUrl = ""
        self.danceability = 0.0
        self.energy = 0.0
        self.bpm = 0.0
        self.val = 0.0
        self.dur = 0.0
        self.acous = 0.0
        self.spch = 0.0
        self.obtainedSong = false
        self.songName = ""
    }
    private func searchSong() {
        guard let encodedSongName = songName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        let urlString = "https://api.spotify.com/v1/search?q=\(encodedSongName)&type=track"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard let data = data else { return }
            
            if httpResponse.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let tracks = json["tracks"] as! [String: Any]
                    let items = tracks["items"] as! [[String: Any]]
                    let firstTrack = items.first!
                    let trackId = firstTrack["id"] as! String
                    
                    self.getAudioFeatures(trackId: trackId)
                    self.getAlbumCoverUrl(trackId: trackId)
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                }
            } else {
                print("Error: HTTP status code \(httpResponse.statusCode)")
            }
        }.resume()
    }
    
    private func getAlbumCoverUrl(trackId: String) {
        let urlString = "https://api.spotify.com/v1/tracks/\(trackId)"
        guard let url = URL(string: urlString) else {
            print("Error: invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print("Error: \(error!.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data else {
                print("Error: invalid response")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                guard let album = json["album"] as? [String: Any],
                      let images = album["images"] as? [[String: Any]],
                      let imgUrl = images.first?["url"] as? String,
                      let popularity = json["popularity"] as? Int
                else {
                    print("Error: invalid JSON structure")
                    return
                }
                self.popRef = popularity
                self.imgUrl = imgUrl
                
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    private func getAudioFeatures(trackId: String) {
        let urlString = "https://api.spotify.com/v1/audio-features/\(trackId)"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(authToken!)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            guard let data = data else { return }
            
            if httpResponse.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    self.danceability = (json["danceability"] as! Double) * 100
                    self.energy = (json["energy"] as! Double) * 100
                    self.bpm = json["tempo"] as! Double
                    self.val = (json["valence"] as! Double) * 100
                    self.dur = json["duration_ms"] as! Double
                    self.dur = self.dur/1000
                    self.acous = (json["acousticness"] as! Double) * 100
                    self.spch = (json["speechiness"] as! Double) * 100
                    self.obtainedSong = true
                    
                    calcPop()
                } catch {
                    print("Error parsing JSON: \(error.localizedDescription)")
                    self.obtainedSong = false
                }
            } else {
                print("Error: HTTP status code \(httpResponse.statusCode)")
                self.obtainedSong = false
            }
        }.resume()
    }
    private func calcPop() {
        do
        {
            let config = MLModelConfiguration()
            let model = try PopPredict(configuration: config)
            let modelAug = try PopPredictAugment(configuration: config)
            
            let prediction = try model.prediction(bpm: self.bpm, nrgy: self.energy, dnce: self.danceability)
            
            let predictionAug = try modelAug.prediction(bpm: self.bpm, nrgy: self.energy, dnce: self.danceability, val: self.val, dur: self.dur, acous: self.acous, spch: self.spch)
            
            self.pop = prediction.pop
            self.popAug = predictionAug.pop
        }
        catch
        {
            print(error.localizedDescription)
        }
        
    }
}

