//
//  DetailViewController.swift
//  GameOfThronesEpisodeGuide
//
//  Created by mobile consulting on 12/9/17.
//  Copyright © 2017 mobile consulting. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var episode = Episode()
    
    @IBOutlet weak var poster: UIImageView!
    
    @IBOutlet weak var seasonEpisode: UILabel!
    @IBOutlet weak var episodeTitle: UILabel!
    @IBOutlet weak var released: UILabel!
    @IBOutlet weak var tvRating: UILabel!
    @IBOutlet weak var runtime: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var director: UILabel!
    @IBOutlet weak var writer: UILabel!
    @IBOutlet weak var actors: UILabel!
    @IBOutlet weak var plot: UILabel!
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var country: UILabel!
    @IBOutlet weak var awards: UILabel!
    @IBOutlet weak var ratings: UILabel!
    @IBOutlet weak var metascore: UILabel!
    @IBOutlet weak var imdbRating: UILabel!
    @IBOutlet weak var imdbVotes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // poster.image = episode.poster
        NetworkManager.loadImage(url: episode.poster) {data in
            self.poster.image = data
        }
        seasonEpisode.text = "S\(episode.season)E\(episode.episode)"
        episodeTitle.text = "\(episode.title)"
        released.text = "Released: \(episode.released)"
        tvRating.text = "\(episode.tvRating)"
        runtime.text = "\(episode.runtime)"
        genre.text = "\(episode.genre)"
        director.text = "Director: \(episode.director)"
        writer.text = "Writer(s): \(episode.writer)"
        actors.text = "Actors: \(episode.actors)"
        plot.text = episode.plot
        language.text = "Language(s): \(episode.language)"
        country.text = "Made in: \(episode.country)"
        imdbRating.text = "IMDB: \(episode.imdbRating)/10"
        imdbVotes.text = "\(episode.imdbVotes) votes"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
