//
//  ViewController.swift
//  HelloPexelsAPI
//
//  Created by Willy Hsu on 2025/2/21.
//

import UIKit
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
    
    
}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularVideoTableViewCell", for: indexPath) as! PopularVideoTableViewCell
        let video = videos[indexPath.row]
        cell.userName.text = video.user.name
        cell.userID.text = "ID: \(video.user.id)"
        cell.duration.text = "時間: \(video.duration) 秒"
        
        if let imageUrl = URL(string: video.image) {
            cell.videoImage.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "placeholder"), completed: { image, error, url, arg  in
                if let error = error {
                    print("Image loading error: \(error.localizedDescription)")
                }
            })
        }
        
        return cell
        
    }
    
    
}
