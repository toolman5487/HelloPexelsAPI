import Foundation

// 更新 PexelsPopularVideoData 結構
struct PexelsPopularVideoData: Codable {
    let page: Int
    let perPage: Int
    let totalResults: Int
    let url: String
    let videos: [Video]
    
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case totalResults = "total_results"
        case url
        case videos
    }
}

// 更新 Video 結構，新增 videoPictures
struct Video: Codable {
    let id: Int
    let width: Int
    let height: Int
    let duration: Int
    let url: String
    let image: String
    let user: VideoUser
    let videoFiles: [VideoFile]
    let videoPictures: [VideoPicture]  // 新增的圖片資料
    
    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case duration
        case url
        case image
        case user
        case videoFiles = "video_files"
        case videoPictures = "video_pictures"  // 新增映射
    }
}

// VideoUser 結構保持不變
struct VideoUser: Codable {
    let id: Int
    let name: String
    let url: String
}

// 更新 VideoFile 結構，將 width 和 height 設為可選
struct VideoFile: Codable {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int?
    let height: Int?
    let fps: Double
    let link: String
    let size: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case quality
        case fileType = "file_type"
        case width
        case height
        case fps
        case link
        case size
    }
}

// 新增 VideoPicture 結構，用於處理 video_pictures
struct VideoPicture: Codable {
    let id: Int
    let picture: String
    let nr: Int
}
