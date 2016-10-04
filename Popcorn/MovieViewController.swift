//
//  MovieViewController.swift
//  Popcorn
//
//  Created by Alexander on 10/2/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MovieViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorImage: UIImageView!
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var refreshing = false;
    var movieItems: [NSDictionary] = []
    var filteredMovieItems: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setNeedsStatusBarAppearanceUpdate();
        
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.alwaysBounceHorizontal = true;
        
        self.searchBar.delegate = self;
        
        self.errorView.layer.cornerRadius = 5;
        self.errorView.hidden = true;
        
        self.errorImage.image = self.errorImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        self.errorImage.tintColor = UIColor.whiteColor()
        
        self.tapGesture.enabled = false;
        
        self.loadData();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent;
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredMovieItems.count;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: MovieCell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell;
        let movieItem = self.filteredMovieItems[indexPath.row];
        let imageUrlString = movieItem.valueForKey("poster_path") as? String;
        if let imageUrl = NSURL(string: "https://image.tmdb.org/t/p/w342" + imageUrlString!) {
            let imageRequest = NSURLRequest(URL: imageUrl)
            cell.imageView.setImageWithURLRequest(imageRequest,
                placeholderImage: nil,
                success: { (imageRequest, imageResponse, image) -> Void in
                    cell.imageView.alpha = 0.0;
                    cell.imageView.image = image;
                    UIView.animateWithDuration(0.3, animations: { () -> Void in
                        cell.imageView.alpha = 1.0;
                    })
                },
                failure: nil)
        }
        
        return cell;
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let inset = scrollView.contentInset
        
        let offsetLeft: CGFloat = offset.x - inset.left
        let offsetRight: CGFloat = scrollView.contentSize.width - (offset.x + scrollView.bounds.width)
        let reload_distance: CGFloat = -75
        
        if offsetLeft < reload_distance || offsetRight < reload_distance {
            self.loadData({ () -> Void in
                scrollView.bounces = false
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
                    }, completion: { (Bool) -> Void in
                        scrollView.bounces = true
                })
            });
        }
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterMovieItems(searchText);
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.tapGesture.enabled = true;
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.tapGesture.enabled = false;
    }
    
    @IBAction func didTapView(sender: AnyObject) {
        view.endEditing(true);
    }
    
    @IBAction func didTapErrorView(sender: AnyObject) {
        loadData();
    }
    
    func loadData(completion: () -> Void = {}) {
        if(self.refreshing){
            return;
        }
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed";
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)");
        let request = NSURLRequest(URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData,
            timeoutInterval: 10
        );
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        );
        
        self.refreshing = true;
        MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                        
                        self.movieItems = responseDictionary["results"] as! [NSDictionary];
                        self.filterMovieItems();

                        self.errorView.hidden = true;
                        
                        
                        completion();
                    }
                }
                else {
                    if(error != nil){
                        self.errorView.hidden = false;
                    }
                }
                self.refreshing = false;
                MBProgressHUD.hideHUDForView(self.view, animated: true);
        });
        
        task.resume();
    }
    
    func filterMovieItems(filter:String = ""){
        self.filteredMovieItems = [];
        if(filter == ""){
            self.filteredMovieItems = self.movieItems;
        }
        else {
            for movie in movieItems {
                let title = movie.valueForKey("title") as! String;
                if ((title.lowercaseString.containsString(filter.lowercaseString))) {
                    self.filteredMovieItems.append(movie)
                }
            }
        }
        
        self.collectionView.reloadData();
    }
    

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let MDVC = segue.destinationViewController as? MovieDetailViewController
        let indexPath = collectionView.indexPathsForSelectedItems()![0]
        
        MDVC?.movieItem = self.filteredMovieItems[indexPath.row];
    }

}
