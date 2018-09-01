//
//  ViewController.swift
//  Worm
//
//  Created by Administrator on 27/03/2018.
//  Copyright © 2018 mahesh lad. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    // let cards: [CardViewModel] = (UIApplication.shared.delegate as! AppDelegate).cards
    var cards: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let nib = UINib(nibName: "CardTableViewCell", bundle: nil);
        tableView.register(nib, forCellReuseIdentifier: "cardCell")
        self.tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadData()
        
    }
    
    func loadData() {
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Card")
        
        //3
        do {
            cards = try managedContext.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //    let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as! CardTableViewCell
        let card = cards[indexPath.row]
        
        cell.likeButton.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
        
        let cardViewModel = cards[indexPath.row]
        
        cell.tag = indexPath.row
        print(indexPath.row)
        cell.nameTextLabel.text = cardViewModel.value(forKeyPath: "name") as? String
        cell.camptionTextLabel.text = cardViewModel.value(forKeyPath: "caption") as? String
        let url = URL(string: (cardViewModel.value(forKeyPath: "videoUrl") as? String)!)
        let avPlayer = AVPlayer(url:url!)
        cell.playerView?.playerLayer.player = avPlayer;
        // cell.Toggle = cardViewModel.getLiked()
        //
        if cardViewModel.value(forKeyPath: "liked") as? Bool == false{
            
            cell.likeButton.setImage(UIImage(), for: UIControlState.normal)
        } else {
            cell.likeButton.setImage(UIImage(named:"ICON Like ON"), for: UIControlState.normal)
        }
        //
        return cell
    }
    
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = (cell as? CardTableViewCell) else { return };
        let visibleCells = tableView.visibleCells;
        let minIndex = visibleCells.startIndex;
        //   if tableView.visibleCells.index(of: cell) == minIndex {
        videoCell.playerView.player?.play();
        //    }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let videoCell = cell as? CardTableViewCell else { return };
        
        videoCell.playerView.player?.pause();
        videoCell.playerView.player = nil;
    }
    
    //    //The target function
    
    
    @objc func pressButton(_ sender: UIButton){ //<- needs `@objc`
        
        //    let cell = sender.superview as! CardTableViewCell
        //    let indexPath = tableView.indexPath(for: cell)
        //     let index = indexPath!.row
        
        let index  =  sender.tag      //use above insted
        
        
        let cardViewModel = cards[index]
        
        // Define server side script URL
        var Url = ""
        //        if cardViewModel.getLiked() == false {
        let id = cardViewModel.value(forKeyPath: "id") as? String
        if cardViewModel.value(forKeyPath: "liked") as? Bool == false{
            Url = "https://api.wormapp.co/public/api/video/12345/like"
            DataManager.sharedInstance.updateLiked(id: id!, liked: true)
            // cardViewModel.setValue(true, forKey: "liked")
            cards[index].setValue(true, forKey: "liked")
        } else {
            Url = "https://api.wormapp.co/public/api/video/12345/unlike"
            DataManager.sharedInstance.updateLiked(id: id!, liked: false)
            //  cardViewModel.setValue(false, forKey: "liked")
            cards[index].setValue(false, forKey: "liked")
        }
        let myUrl = URL(string: Url);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(url:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(responseString)")
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    if    let liked = convertedJsonIntoDict["liked"] as? Bool {
                        print(liked)
                        //  self.Toggle  = likedToggle
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
        
        updateLikedCellButton(sender)
        // self.loadData()
        
        
        
    }
    
    
    //    func test() {
    //        if var currentCell = sender as? UIView   { //ExploreViewController
    //            while (true) {
    //                currentCell = currentCell.superview!
    //                if let cell  =  currentCell as? DiscoverCell {
    //                    if let creatorImage = cell.CreatorImage {
    //                        //  let btnImage = UIImage(named: "explore_like_a_icon")
    //                        creatorImage.layer.borderColor =  LGOLightGrayBoarder.cgColor
    //                        creatorImage.layer.borderWidth = 1
    //                        break;
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    
    
    
    func updateLikedCellButton(_ sender: UIButton) {
        //        //
        if var currentCell = sender as? UIView   { //ExploreViewController
            while (true) {
                currentCell = currentCell.superview!
                if let cell  =  currentCell as? CardTableViewCell {
                    
                    if let likedButton =  cell.likeButton {
                        if likedButton.image(for: UIControlState.normal) != UIImage(named:"ICON Like ON") {
                            
                            
                            likedButton.setImage(UIImage(named:"ICON Like ON"), for: UIControlState.normal)
                            //   cardViewModel.setValue(true, forKey: "liked")
                               break;
                        } else {
                            likedButton.setImage(UIImage(), for: UIControlState.normal)
                            //   cardViewModel.setValue(false, forKey: "liked")
                              break;
                        }
                        
                    }
                    
                }
                
            }
        }
    }
    
}

