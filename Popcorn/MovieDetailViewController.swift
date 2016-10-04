//
//  MovieDetailViewController.swift
//  Popcorn
//
//  Created by Alexander on 10/2/16.
//  Copyright © 2016 Alexander. All rights reserved.
//

import UIKit
import AFNetworking

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UITextView!
    @IBOutlet weak var backButton: UIButton!
    
    var movieItem: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageUrlString = movieItem.valueForKey("poster_path") as? String;
        let smallImageRequest = NSURLRequest(URL: NSURL(string: "https://image.tmdb.org/t/p/w45"+imageUrlString!)!);
        let largeImageRequest = NSURLRequest(URL: NSURL(string: "https://image.tmdb.org/t/p/original"+imageUrlString!)!);
        self.movieImage.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                self.movieImage.alpha = 0.0
                self.movieImage.image = smallImage
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.movieImage.alpha = 1.0
                },
                completion: { (success) -> Void in
                    self.movieImage.setImageWithURLRequest(
                        largeImageRequest,
                        placeholderImage: nil,
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            self.movieImage.image = largeImage
                        },
                        failure: { (largeImageRequest, largeImageResponse, error) -> Void in
                            //Do something
                    })
                })
            },
            failure: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                //Do something
        });
        
        movieTitleLabel.text = movieItem.valueForKey("title") as? String;
        movieTitleLabel.numberOfLines = 0;
        movieTitleLabel.adjustsFontSizeToFitWidth = true;
        
        releaseDateLabel.text = movieItem.valueForKey("release_date") as? String;
        
        overviewLabel.text = movieItem.valueForKey("overview") as? String;
        overviewLabel.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
        overviewLabel.textAlignment = NSTextAlignment.Left;
        
        backButton.imageView?.image = backButton.imageView?.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate);
        backButton.imageView?.tintColor = UIColor.lightGrayColor();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func exitPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil);
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
