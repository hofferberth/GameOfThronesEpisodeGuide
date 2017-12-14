//
//  NetworkManager.swift
//  GameOfThronesEpisodeGuide
//
//  Created by mobile consulting on 12/11/17.
//  Copyright © 2017 mobile consulting. All rights reserved.
//

import Foundation
import UIKit

class NetworkManager {
    private static let dispatchGroup = DispatchGroup()
    private static var seasons: [Season] = []
    
    static func initLoad(completion: @escaping([Season])->()) {
        loadShowInfo() {
            seasons = Array.init(repeating: Season(), count: Season.totalSeasons)
            self.loadSeasons() {
                completion(self.seasons)
            }
        }
    }
    
    private static func loadShowInfo(completion: @escaping()->()) {
        let session = URLSession(configuration: .default)
        let url = "http://www.omdbapi.com/?apikey=6bfb4e66&i=tt0944947"
        guard let link = URL(string: url) else {
            print("Bad URL: \(url)")
            completion()
            return
        }
        
        let task = session.dataTask(with: link) { (data, response, error) in
            if(error != nil) {
                print("\(error!.localizedDescription)")
                completion()
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                let title = json!["Title"] as? String,
                let totalSeasons = json!["totalSeasons"] as? String
                
                else {
                    print("\(url) parse error")
                    return
            }
            
            Season.title = title
            Season.totalSeasons = Int(totalSeasons)!
            
            DispatchQueue.main.async() {
                completion()
            }
        }
        task.resume()
    }
    
    
    private static func loadSeasons(completion: @escaping()->()) {
        let session = URLSession.shared
        for (i,_) in seasons.enumerated() {
            var tempSeason = Season()
            let url = "http://www.omdbapi.com/?apikey=6bfb4e66&i=tt0944947&season=\(i+1)"
            guard let link = URL(string: url) else {
                print("Bad URL: \(url)")
                return
            }
            
            dispatchGroup.enter()
            let task = session.dataTask(with: link) { (data, response, error) in
                if(error != nil) {
                    print("\(error!.localizedDescription)")
                    return
                }
                
                guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                    let season = json!["Season"] as? String,
                    let episodes = json!["Episodes"] as? [[String : Any]]
                    
                    else {
                        print("\(url) parse error")
                        return
                }
                
                tempSeason.season = Int(season)!
                print("S\(tempSeason.season) has \(episodes.count) episodes")
                
                for (_,e) in episodes.enumerated() {
                    self.loadEpisode(episodeDict: e) { episode in
                        tempSeason.episodes.append(episode!)
                        if(tempSeason.episodes.count == episodes.count) {
                            seasons[tempSeason.season-1] = tempSeason
                            self.dispatchGroup.leave()
                        }
                    }
                }
            }
            task.resume()
        }
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    private static func loadEpisode(episodeDict: [String : Any], completion: @escaping(Episode?)->()) {
        var tempEpisode = Episode()
        let id = episodeDict["imdbID"] as? String
        let session = URLSession(configuration: .default)
        let url = "http://www.omdbapi.com/?apikey=6bfb4e66&i=\(id!)"
        guard let link = URL(string: url) else {
            print("Bad URL: \(url)")
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: link) { (data, response, error) in
            if(error != nil) {
                print("\(error!.localizedDescription)")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                let title = json!["Title"] as? String,
                let year = json!["Year"] as? String,
                let rated = json!["Rated"] as? String,
                let released = json!["Released"] as? String,
                let season = json!["Season"] as? String,
                let episode = json!["Episode"] as? String,
                let runtime = json!["Runtime"] as? String,
                let genre = json!["Genre"] as? String,
                let director = json!["Director"] as? String,
                let writer = json!["Writer"] as? String,
                let actors = json!["Actors"] as? String,
                let plot = json!["Plot"] as? String,
                let language = json!["Language"] as? String,
                let country = json!["Country"] as? String,
                // let posterURL = json!["Poster"] as? String,
                let poster = json!["Poster"] as? String,
                let imdbRating = json!["imdbRating"] as? String,
                let imdbVotes = json!["imdbVotes"] as? String,
                let response = json!["Response"] as? String
                
                else {
                    print("\(url) episode parse error")
                    return
            }
            
            tempEpisode.title = title
            tempEpisode.year = Int(year)!
            tempEpisode.tvRating = rated
            tempEpisode.released = released
            tempEpisode.season = Int(season)!
            tempEpisode.episode = Int(episode)!
            tempEpisode.runtime = runtime
            tempEpisode.genre = genre
            tempEpisode.director = director
            tempEpisode.writer = writer
            tempEpisode.actors = actors
            tempEpisode.plot = plot
            tempEpisode.language = language
            tempEpisode.country = country
/*          dispatchGroup.enter()
            NetworkManager.loadImage(url: posterURL) {data in
                tempEpisode.poster = data
                dispatchGroup.leave()
            }
 */
            tempEpisode.poster = poster
            tempEpisode.imdbRating = imdbRating
            tempEpisode.imdbVotes = imdbVotes
            
            DispatchQueue.main.async {
                if(Bool(response.lowercased())!) {
                    completion(tempEpisode)
                }
            }
        }
        task.resume()
    }
    
    static func loadImage(url: String, completion: @escaping (UIImage) -> ()) {
        let session = URLSession(configuration: .default)
        let link = URL(string: url)
        
        let downloadPicTask = session.dataTask(with: link!) { (data, response, error) in
            if let e = error {
                print("Error downloading cat picture: \(e)")
            } else {
                if let res = response as? HTTPURLResponse {
                    // print("Downloaded poster with response code \(res.statusCode)")
                    if let imageData = data {
                        DispatchQueue.main.async {
                            completion(UIImage(data: imageData)!)
                        }
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                } else {
                    print("Couldn't get response code for some reason")
                }
            }
        }
        downloadPicTask.resume()
    }
    
}
