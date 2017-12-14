//
//  SplashViewController.swift
//  GameOfThronesEpisodeGuide
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 mobile consulting. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    var seasons: [Season] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.initLoad() { data in
            self.seasons = data
            self.performSegue(withIdentifier: "SplashEnd", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SplashEnd") {
            let tabDest = segue.destination as? UITabBarController
            let navDest = tabDest?.childViewControllers.first as? UINavigationController
            let dest = navDest?.childViewControllers.first as? OnlineViewController
            
            for (i,e) in seasons.enumerated() {
                seasons[i].episodes = e.episodes.sorted(by: {$0.episode < $1.episode})
                print("Season \(i+1) finally loaded \(seasons[i].episodes.count) episodes")
            }
            
            dest?.seasons = self.seasons
        }
    }
}

struct Season {
    static var title = ""
    static var totalSeasons: Int = 0
    var season: Int = 0
    var episodes: [Episode] = []
}

struct Episode {
    var title = ""
    var year = 0
    var tvRating = ""
    var released = ""
    var season = 0
    var episode = 0
    var runtime = ""
    var genre = ""
    var director = ""
    var writer = ""
    var actors = ""
    var plot = ""
    var language = ""
    var country = ""
    // var poster = UIImage()
    var poster = ""
    var imdbRating = ""
    var imdbVotes = ""
    
    init() {
        
    }
    
    init(obj: CDepisode) {
        title = obj.title!
        year = Int(obj.year)
        tvRating = obj.tvRating!
        released = obj.released!
        season = Int(obj.season)
        episode = Int(obj.episode)
        runtime = obj.runtime!
        genre = obj.genre!
        director = obj.director!
        writer = obj.writer!
        actors = obj.actors!
        plot = obj.plot!
        language = obj.language!
        country = obj.country!
        // poster = UIImage(data: obj.poster!)!
        poster = obj.poster!
        imdbRating = obj.imdbRating!
        imdbVotes = obj.imdbVotes!
    }
}
