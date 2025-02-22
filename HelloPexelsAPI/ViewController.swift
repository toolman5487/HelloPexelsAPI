//
//  ViewController.swift
//  HelloPexelsAPI
//
//  Created by Willy Hsu on 2025/2/21.
//

import UIKit
import AVFoundation
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var videoView: UIView!
    var videos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theTableView.dataSource = self
        theTableView.delegate = self
        fetchData()

        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        let popularURLString = "https://api.pexels.com/videos/popular"
        let apiKey = "mGD1QkMKbuGvGnW2995s9BJsveczABkZioWnf96KMYhFYabeTQWNMZP6"
        if let popularURL = URL(string: popularURLString){
            var request = URLRequest(url: popularURL)
            request.setValue(apiKey, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: request){ data, response, error in
                if let error = error{
                    print("Error: \(error.localizedDescription)")
                }
                if let data = data{
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response JSON: \(jsonString)")
                    }
                    do {
                        let decoder = JSONDecoder()
                        let popularVideo = try decoder.decode(PexelsPopularVideoData.self, from: data)
                        self.videos = popularVideo.videos
                        print("data ok")
                        DispatchQueue.main.async {
                            self.theTableView.reloadData()
                            self.playRandomVideo()
                        }
                        
                    } catch {
                        print("data out")
                        print("\(error.localizedDescription)")
                    }
                }
                if let response = response as? HTTPURLResponse {
                    print("Response status code: \(response.statusCode)")
                }
                
            }.resume()
        }
        
    }
    func playRandomVideo(){
        print("played ok")
        if videos.isEmpty{
            print("no video")
            return
        }
        if let randomVideo = videos.randomElement(){
            print("random video: \(randomVideo)")
          if let videoFiles = randomVideo.videoFiles.first {
              if let randomVideoURL = URL(string: videoFiles.link){
                  let player = AVPlayer(url: randomVideoURL)
                  let playerLayer = AVPlayerLayer(player: player)
                  playerLayer.frame = videoView.bounds
                  playerLayer.videoGravity = .resizeAspectFill
                  videoView.layer.sublayers?.filter{$0 is AVPlayerLayer}.forEach{$0.removeFromSuperlayer()}
                  videoView.layer.addSublayer(playerLayer)
                  player.play()
              }
            }
            
        }else{
            print("no video")
        }
        
    }
    
    
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "熱門影片"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularVideoTableViewCell", for: indexPath) as! PopularVideoTableViewCell
        let video = videos[indexPath.row]
        cell.userName.text = "\(video.user.name)"
        cell.userID.text = "ID：\(video.user.id)"
        cell.duration.text = "時間：\(video.duration) 秒"
        
        if let imageUrl = URL(string: video.image) {
            cell.videoImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"), completed: { image, error, url, arg  in
                if let error = error {
                    print("Image loading error: \(error.localizedDescription)")
                }
            })
            cell.videoImage.contentMode = .scaleAspectFill
            cell.videoImage.clipsToBounds = true
            cell.videoImage.layer.cornerRadius = 20
        }
        
        return cell
        
    }
    
    
}
