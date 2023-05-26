import SwiftUI

struct InfoView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.11, green: 0.16, blue: 0.21), Color(red: 0.23, green: 0.29, blue: 0.35)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(alignment: .leading) {
                Group {
                    Text("About the prediction")
                        .font(.title)
                        .foregroundColor(.green)
                        .fontWeight(.bold)
                    Text("For the popularity prediction we use song's features provided by the Spotify API:")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.bottom, 8)

                    Text("• Acousticness: Confidence of whether a song is acoustic")
                    Text("• Danceability: How suitable a song is for dancing")
                    Text("• Duration: Duration of the song in seconds")
                    Text("• Energy: Measure of intensity and activity")
                    Text("• Speechiness: Detects the presence of spoken words")
                    Text("• Valence: Describe the positiveness conveyed by a track")
                    Text("• Tempo: Estimated tempo of a track in beats per minute")
                }
                .foregroundColor(.white)
                .padding(.bottom, 17)
                Spacer()
                Text("This app was developed by Andres Escobedo")
                    .font(.footnote)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .navigationTitle("Info")
    }
}
