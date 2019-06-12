//
//  Movie.swift
//  MoviesApp
//
//  Created by jets on 7/26/1440 AH.
//  Copyright © 1440 AH jets. All rights reserved.
//

import Foundation
class MyMovie{
    
    private var  posterPath:String = ""
    private var overview:String="";
    
    private var releaseDate:String="";
    
    private var originalTitle:String="";
    
    private var id:Int=0;
    
    private var voteAverage:Float=0;
    public func setPosterPath(posterPath:String){
        self.posterPath=posterPath;
    }
    public func getPosterPath()->String{
        return posterPath;
    }
    public func setOverView(overview:String){
        self.overview=overview;
    }
    public func getoverView()->String{
        return overview;
    }
    public func setRealeasDate(releaseDate:String){
        self.releaseDate=releaseDate;
    }
    public func getReleaseDate()->String{
        return releaseDate;
    }
    public func setOriginalTitle(originalTitle:String){
        self.originalTitle=originalTitle;
    }
    
    public func getOriginalTitle()->String{
        return originalTitle;
    }
    public func setID(id:Int){
        self.id=id;
    }
    public func getId ()-> Int{
        return id ;
        
    }
    public func setVoteAverage(voteAverage:Float){
        self.voteAverage=voteAverage;
    }
    public func getVoteAverage()->Float{
        return voteAverage;
    }
}
