//
//  moviesCollectionView.swift
//  MoviesApp
//
//  Created by jets on 7/24/1440 AH.
//  Copyright © 1440 AH jets. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

private let reuseIdentifier = "Cell"


class moviesCollectionView: UICollectionViewController {
    var moviesList : Array<MyMovie>=[];
    var imageUrl = "https://image.tmdb.org/t/p/w185/"
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        getTopRatedMovie()
      
        let add = UIBarButtonItem(title: "top rated", style: .plain, target: self, action: #selector(getTopRatedMovie))
        let play = UIBarButtonItem(title: "most popular", style: .plain, target: self, action: #selector(getMostPopularMovie))
        
        navigationItem.rightBarButtonItems = [add, play]
    }
    func getTopRatedMovie(){
        moviesList.removeAll()
        let topRatedUrl = URL(string : "https://api.themoviedb.org/3/movie/top_rated?api_key=1b5062dd05eaace07a10010e59798def")
        Alamofire.request(topRatedUrl!).responseJSON{response in
            switch response.result {
            case .success:
                let responseValue = response.result.value as! [String : Any]?
                let responseMovies = responseValue?["results"] as! [[ String: Any]]?
                for var item in responseMovies! {
                    let movie = MyMovie()
                    movie.setID(id: item["id"] as! Int)
                    movie.setOverView(overview: item["overview"]as! String)
                    movie.setPosterPath(posterPath: item["poster_path"]as! String)
                    movie.setRealeasDate(releaseDate: item["release_date"]as! String)
                    movie.setVoteAverage(voteAverage: item["vote_average"]as! Float)
                    movie.setOriginalTitle(originalTitle: item["title"]as! String)
                    self.moviesList.append(movie)
                    
                }
                self.collectionView?.reloadData()
            case .failure( _):
                print ("failure  in parsing")
            }
        }
    
    }
    func getMostPopularMovie(){
        moviesList.removeAll()
        let topRatedUrl = URL(string : "https://api.themoviedb.org/3/movie/popular?api_key=1b5062dd05eaace07a10010e59798def")
        Alamofire.request(topRatedUrl!).responseJSON{response in
            switch response.result {
            case .success:
                let responseValue = response.result.value as! [String : Any]?
                let responseMovies = responseValue?["results"] as! [[ String: Any]]?
                for var item in responseMovies! {
                    let movie = MyMovie()
                    movie.setID(id: item["id"] as! Int)
                    movie.setOverView(overview: item["overview"]as! String)
                    movie.setPosterPath(posterPath: item["poster_path"]as! String)
                    movie.setRealeasDate(releaseDate: item["release_date"]as! String)
                    movie.setVoteAverage(voteAverage: item["vote_average"]as! Float)
                    movie.setOriginalTitle(originalTitle: item["title"]as! String)
                    self.moviesList.append(movie)
                    
                }
                self.collectionView?.reloadData()
            case .failure(_):
                print ("failure  in parsing")
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
  
    }
  
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "details") as! MovieDetailsViewController
        detailsViewController.movie = moviesList[indexPath.row]
       // self.present(detailsViewController, animated: true, completion: nil)
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MovieCollectionViewCell
        
        cell.imageMovie.sd_setImage(with: URL(string: imageUrl + moviesList[indexPath.row].getPosterPath()), placeholderImage: UIImage(named: "1.jpg"))

        return cell
    }
    
   
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
