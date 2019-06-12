import UIKit
import  Alamofire
import SDWebImage
import  CoreData
import Foundation
import SystemConfiguration
import Cosmos
class MovieDetailsViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate{
    var imageUrl = "https://image.tmdb.org/t/p/w185/"
    @IBOutlet weak var scrolView: UIScrollView!
    @IBOutlet weak var trailersTableView: UITableView!
    
    @IBOutlet var movieRate: CosmosView!

    
    var trailerList : Array<String>=[];
    var reviewList : Array<String>=[];
    var manager : NSManagedObjectContext!
    
    @IBOutlet weak var lblTitleMovie: UILabel!
    @IBOutlet weak var imgMovie: UIImageView!
    @IBOutlet weak var lblReleaseYear: UILabel!
    
    @IBOutlet weak var txtViewOverviewMovie: UITextView!
    var movie = MyMovie();
   // var favouriteMovies;
    
    let sections = ["Trailers","Reviews"]
    var data :[[String]] = [[],[]]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        trailersTableView.delegate = self
        lblTitleMovie.text = movie.getOriginalTitle()
//        lblUserRating.text = String(movie.getVoteAverage())
        movieRate.rating = Double(movie.getVoteAverage()/2)
        movieRate.text = String(movie.getVoteAverage())
        lblReleaseYear.text = movie.getReleaseDate()
        txtViewOverviewMovie.text = movie.getoverView()
        txtViewOverviewMovie.isEditable = false
        imgMovie.sd_setImage(with: URL(string: imageUrl + movie.getPosterPath()),
                             placeholderImage: UIImage(named: "1.jpg")) ;
        getMovieReviews(id: movie.getId())
        getMovieTrailers(id: movie.getId())
        getFavouriteMovies();
        
    }
    
    func getFavouriteMovies() ->Void{
         //favouriteMovies = Array<Movie>();
        
        let myDelegate = UIApplication.shared.delegate as! AppDelegate
        if #available(iOS 10.0, *) {
            manager = myDelegate.persistentContainer.viewContext
        }
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
            }
        }
        catch{
            
        }
    }
    
    
    @IBAction func addToFavourite(_ sender: Any) {
        if (checkIFFavourites()==true){
        
        let myDelegate = UIApplication.shared.delegate as! AppDelegate
        manager = myDelegate.persistentContainer.viewContext
        let myEntity=NSEntityDescription.entity(forEntityName: "Movie", in: manager)
        let movieEntity = NSManagedObject(entity: myEntity!, insertInto: manager!)
        movieEntity.setValue(movie.getOriginalTitle(), forKey: "title")
        movieEntity.setValue(movie.getId(), forKey: "id")
        movieEntity.setValue(movie.getPosterPath(), forKey: "posterPath")
        movieEntity.setValue(movie.getoverView(), forKey: "overView")
        movieEntity.setValue(movie.getReleaseDate(), forKey: "releaseDate")
        movieEntity.setValue(movie.getVoteAverage(), forKey: "average")
        do{
            try manager.save()
            let alert = UIAlertController(title: "Alert", message: "add to favourite", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        catch{
            print ("error ")
            
        }
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Already add to favourite", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

    }
    
    
    
    func checkIFFavourites() -> Bool {
        let myDelegate = UIApplication.shared.delegate as! AppDelegate
        manager = myDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        request.predicate = NSPredicate(format: "id = %d", movie.getId())
        let result = MyMovie()
        do{
         let movies = try manager.fetch(request)
            for data in movies{
            result.setID(id: data.value(forKey: "id" )as! Int)
            }
        }
        catch{
        
        }
        return result.getId() > 0 ? false: true;
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2;
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        switch section {
        case 0:
            return trailerList.count ;
        case 1 :
           return  reviewList.count

        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let youtubeId = trailerList[indexPath.row]
            var youtubeUrl = NSURL(string:"youtube://\(youtubeId)")!
            youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
            UIApplication.shared.openURL(youtubeUrl as URL)
        default:
            break ;
        }
       
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        switch indexPath.section {
//        case 0:
//               return 40.0;
//        case 1:
//            return 250.0;
//        default:
//          return 50.0;
//        }
        return UITableViewAutomaticDimension
        
    }
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TrailorTableViewCell
        switch indexPath.section {
        case 0:
            cell.txtViewTrailorOrReview.text = "Trailer \(indexPath.row+1 )";
        case 1:
            cell.txtViewTrailorOrReview.text = self.reviewList[indexPath.row]
            
        default: break
            
        }
        return cell ;
    }
    
    
    func getMovieTrailers(id :Int)  {
        let trailerUrl = URL(string : "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=1b5062dd05eaace07a10010e59798def")
                Alamofire.request(trailerUrl!).responseJSON{response in
            switch response.result {
            case .success:
                
                let responseValue = response.result.value as! [String : Any]?
                let responseMovies = responseValue?["results"] as! [[ String: Any]]?
                // print(responseMovies)
                for var item in responseMovies! {
                    //  trails = item["key"] as! String
                let strKey = item["key"]as! String
                    
                    self.trailerList.append(strKey)
                    self.data.append(self.trailerList)
                }
                self.trailersTableView.reloadData()
            case .failure(_):
                print ("failure  in parsing")
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
     return sections[section]
        
    }
    
    
    func getMovieReviews(id :Int) {
        let trailerUrl = URL(string : "https://api.themoviedb.org/3/movie/\(id)/reviews?api_key=1b5062dd05eaace07a10010e59798def")
        Alamofire.request(trailerUrl!).responseJSON{response in
            switch response.result {
            case .success:
                let responseValue = response.result.value as! [String : Any]?
                let responseMovies = responseValue?["results"] as! [[ String: Any]]?
                //print(responseMovies)
                for var item in responseMovies! {
                    let strContent = item["content"]as! String
                    
                    self.reviewList.append(strContent)
                    self.data.append(self.reviewList)
                }
            case .failure( _):
                print ("failure  in parsing")
            }
        }
        
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor=UIColor.white
        
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
