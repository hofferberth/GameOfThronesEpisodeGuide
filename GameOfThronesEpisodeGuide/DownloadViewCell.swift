//
//  DownloadViewCell.swift
//  GameOfThronesEpisodeGuide
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 mobile consulting. All rights reserved.
//

import UIKit
import CoreData

class DownloadViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var episodeNumber: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    var moc: NSManagedObjectContext?
    var header = false
    
    var episode = Episode()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        moc = appDelegate?.persistentContainer.viewContext
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setAsHeader() {
        ratingLabel.text = ""
        episodeNumber.text = ""
        header = true
        hideSaveButton()
    }
    
    func hideSaveButton() {
        saveButton.isHidden = true
    }
    
    func checkSaveButton() {
        if(coreDataExists(title: episode.title)) {
            saveButton.isEnabled = false
        } else {
            saveButton.isEnabled = true
        }
    }
    
    func toggleSaveButton() {
        saveButton.isEnabled = !saveButton.isEnabled
    }
    
    @IBAction func saveToCoreData() {
        save()
    }
    
    func coreDataExists(title: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDepisode")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        
        var fetchedCharacters: [NSManagedObject] = []
        
        do {
            fetchedCharacters = try moc!.fetch(fetchRequest)
        } catch {
            print("Fetch error - \(error)")
        }
        
        return fetchedCharacters.count > 0
    }
    
    func save() {
        if(coreDataExists(title: episode.title)) {
            return
        }
        
        let entity =
            NSEntityDescription.entity(forEntityName: "CDepisode", in: moc!)!
        
        let ep = NSManagedObject(entity: entity, insertInto: moc!)
        
        ep.setValue(episode.title, forKeyPath: "title")
        ep.setValue(episode.year, forKeyPath: "year")
        ep.setValue(episode.tvRating, forKeyPath: "tvRating")
        ep.setValue(episode.released, forKeyPath: "released")
        ep.setValue(episode.season, forKeyPath: "season")
        ep.setValue(episode.episode, forKeyPath: "episode")
        ep.setValue(episode.runtime, forKeyPath: "runtime")
        ep.setValue(episode.genre, forKeyPath: "genre")
        ep.setValue(episode.director, forKeyPath: "director")
        ep.setValue(episode.writer, forKeyPath: "writer")
        ep.setValue(episode.actors, forKeyPath: "actors")
        ep.setValue(episode.plot, forKeyPath: "plot")
        ep.setValue(episode.language, forKeyPath: "language")
        ep.setValue(episode.country, forKeyPath: "country")
        ep.setValue(episode.plot, forKeyPath: "plot")
        ep.setValue(episode.poster, forKeyPath: "poster")
        ep.setValue(episode.plot, forKeyPath: "plot")
        ep.setValue(episode.imdbRating, forKeyPath: "imdbRating")
        ep.setValue(episode.imdbVotes, forKeyPath: "imdbVotes")
        
        do {
            try moc!.save()
            toggleSaveButton()
        } catch {
            print("Failed to save: \(error)")
        }
    }
    
}
