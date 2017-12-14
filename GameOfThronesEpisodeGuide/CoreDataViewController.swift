//
//  CoreDataViewController.swift
//  GameOfThronesEpisodeGuide
//
//  Created by mobile consulting on 12/9/17.
//  Copyright © 2017 mobile consulting. All rights reserved.
//

import UIKit
import CoreData

class CoreDataViewController: UITableViewController {
    
    var episodes: [Episode] = []
    var deletionArr: [Int] = []
    @IBOutlet weak var table: UITableView!
    var moc: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DownloadViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "DownloadCell")
        table.rowHeight = CGFloat(80)
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        moc = appDelegate?.persistentContainer.viewContext
        loadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadData() {
        let fetch = NSFetchRequest<CDepisode>(entityName: "CDepisode")
        
        var fetchedEpisodes: [CDepisode] = []
        
        do {
            fetchedEpisodes = try moc!.fetch(fetch)
        } catch {
            print("Fetch error - \(error)")
            return
        }
        
        episodes = []
        for (_,e) in fetchedEpisodes.enumerated() {
            episodes.append(Episode(obj: e))
        }
        
        episodes.sort(by: {($0.season*100 + $0.episode) < ($1.season*100 + $1.episode)})
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell", for: indexPath) as? DownloadViewCell else {
            print("Bad Cell")
            return UITableViewCell()
        }
        
        let currentEpisode = episodes[indexPath.row]
        
        cell.titleLabel.text = currentEpisode.title
        cell.ratingLabel.text = "Rating: \(currentEpisode.imdbRating)"
        cell.episodeNumber.text = "S\(currentEpisode.season)E\(currentEpisode.episode)"
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.lightGray
        }
        
        cell.hideSaveButton()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(!table.isEditing) {
            performSegue(withIdentifier: "DataShowDetail", sender: nil)
        } else {
            deletionArr.append(indexPath.row)
        }
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle(rawValue: 3)!
    }
    
    @IBAction func toggleEditing(_ sender: Any) {
        if(!table.isEditing) {
            let btn = sender as? UIBarButtonItem
            btn?.title = "Delete"
            btn?.tintColor = UIColor.red
        } else {
            deleteSelectedData()
            let btn = sender as? UIBarButtonItem
            btn?.title = "Edit"
            btn?.tintColor = UIColor.blue
        }
        table.setEditing(!table.isEditing, animated: true)
    }
    
    func deleteSelectedData() {
        if(deletionArr.count == 0) {
            return
        }
        
        deletionArr.sort(by: {$1 < $0})
        
        for (_,e) in deletionArr.enumerated() {
            deleteCoreData(title: episodes[e].title)
            episodes.remove(at: e)
        }
        
        deletionArr = []
        table.reloadData()
    }
    
    func deleteCoreData(title: String) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let moc = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CDepisode")
        fetchRequest.predicate = NSPredicate(format: "title = %@", title)
        
        var fetchedCharacters: [NSManagedObject] = []
        
        do {
            fetchedCharacters = try moc!.fetch(fetchRequest)
        } catch {
            print("Fetch error - \(error)")
        }
        
        moc!.delete(fetchedCharacters.first!)
        do {
            try moc!.save()
        } catch {
            print("Save error - \(error)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "DataShowDetail") {
            let detailView = segue.destination as? DetailViewController
            let row = table.indexPathForSelectedRow?.row
            detailView?.episode = episodes[row!]
        }
    }

}
