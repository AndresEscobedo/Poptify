# POPTIFY

This project utilizes the Spotify Web API to search songs and retrieve their features, album cover and track popularity for reference. It also uses a machine learning model (ML CORE from SwitfUI) to predict the popularity of songs based on the features.

## Spotify Web API

The Spotify Web API provides access to a wide range of Spotify's music catalog and user data. With the API, you can retrieve information about tracks, albums, artists, playlists, and more. It also allows you to perform actions like searching for songs, creating playlists, and accessing user-specific data (with the appropriate user authorization).

To use the Spotify Web API, you need to obtain an access token by following the Spotify authentication flow. Once you have the access token, you can make HTTP requests to the API endpoints, including retrieving track information, audio features, and track popularity.
For more information visit [Spotify for developers](https://developer.spotify.com/documentation/web-api).

## Dataset for ML CORE

SwiftUI's ML CORE used in this project, the automatic model is trained on a dataset that contains the songs features for the top 100 popularity tracks of the 80's, 90's, 2000's and 2010's decades and their associated popularity. This dataset is used to train a machine learning model that can predict the popularity of songs based on their audio features.
The data is available in [Kaggle](https://www.kaggle.com/datasets/cnic92/spotify-past-decades-songs-50s10s?select=2010.csv).


To use your own dataset for training an ML model to predict song popularity, ensure that the dataset contains relevant audio features (e.g., danceability, energy, tempo) and corresponding popularity scores. Preprocessing and feature engineering may be necessary to prepare the dataset for training the ML model.

## Getting Started

To use this project, follow these steps:

1. Enter in your spotify account and authorize Poptify via the auth view.
2. Write a song's name. The app will select the first result. For specific songs, write the band/singer name after the song's.
3. Press calculate. 
