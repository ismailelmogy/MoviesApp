//
//  FavouritesTVC.swift
//  MoviesApp
//
//  Created by jets on 7/29/1440 AH.
//  Copyright © 1440 AH jets. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class FavouritesTVC: UITableViewController {
    
    var moviesList : Array<MyMovie>=[];
    var imageUrl = "https://image.tmdb.org/t/p/w185/";
    var manager : NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
       // registerTvCell();
  getFavouriteMovies();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func registerTvCell(){
        let imgCell=UINib(nibName: "favourite_cell", bundle: nil)
        self.tableView.register(imgCell, forCellReuseIdentifier: "favourite_cell")
    }
    func getFavouriteMovies() ->Void{
        //favouriteMovies = Array<Movie>();
        
        let myDelegate = UIApplication.shared.delegate as! AppDelegate
        manager = myDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        do{
            let movies = try manager.fetch(fetchRequest)
            for data in movies{
                let movie = MyMovie()
                movie.setID(id: data.value(forKey: "id" )as! Int)
                movie.setPosterPath(posterPath: data.value(forKey: "posterPath") as! String)
                movie.setOriginalTitle(originalTitle: data.value(forKey: "title")as! String)
                movie.setOverView(overview: data.value(forKey: "overView") as! String)
                movie.setVoteAverage(voteAverage: Float(data.value(forKey: "average")as! Float))
                movie.setRealeasDate(releaseDate: data.value(forKey: "releaseDate")as! String)
                self.moviesList.append(movie)
                
            }
                   }
        catch{
            
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favourite_cell", for: indexPath) as! FavouriteTVCell
        
        cell.imgFavouriteMovie.sd_setImage(with: URL(string: imageUrl + moviesList[indexPath.row].getPosterPath()), placeholderImage: UIImage(named: "1.jpg"));

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailsViewController: MovieDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "details") as! MovieDetailsViewController
        
        detailsViewController.movie = moviesList[indexPath.row]
        
        self.navigationController?.pushViewController(detailsViewController, animated : true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "showMovie":
            let detailsViewController = segue.destination as? MovieDetailsViewController
            detailsViewController?.movie = moviesList[(tableView.indexPathForSelectedRow?.row)!]
        default:
            print("hellooooooo")
            
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
