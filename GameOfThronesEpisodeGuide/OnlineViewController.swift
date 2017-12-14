//
//  OnlineViewController.swift
//  GameOfThronesEpisodeGuide
//
//  Created by mobile consulting on 12/8/17.
//  Copyright © 2017 mobile consulting. All rights reserved.
//

import UIKit

class OnlineViewController: UITableViewController {
    var seasons: [Season] = []
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "DownloadViewCell", bundle: nil)
        table.register(nib, forCellReuseIdentifier: "DownloadCell")
        table.rowHeight = CGFloat(80)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        table.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return seasons.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return seasons[section].episodes.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell") as? DownloadViewCell else {
            print("Bad Cell")
            return UITableViewCell()
        }
        
        cell.titleLabel.text = "Season \(section+1)"
        cell.setAsHeader()
        
        cell.backgroundColor = UIColor.black
        cell.titleLabel.textColor = UIColor.white
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DownloadCell", for: indexPath) as? DownloadViewCell else {
            print("Bad Cell")
            return UITableViewCell()
        }
        
        let currentSeason = seasons[indexPath.section]
        
        cell.titleLabel.text = currentSeason.episodes[indexPath.row].title
        cell.ratingLabel.text = "Rating: \(currentSeason.episodes[indexPath.row].imdbRating)"
        cell.episodeNumber.text = "S\(currentSeason.season)E\(currentSeason.episodes[indexPath.row].episode)"
        
        cell.episode = currentSeason.episodes[indexPath.row]
        cell.checkSaveButton()
        
        if(indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor.lightGray
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "OnlineShowDetail", sender: nil)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "OnlineShowDetail") {
            let detailView = segue.destination as? DetailViewController
            let section = table.indexPathForSelectedRow?.section
            let row = table.indexPathForSelectedRow?.row
            detailView?.episode = seasons[section!].episodes[row!]
        }
    }
    

}
