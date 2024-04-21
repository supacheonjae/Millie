//
//  ImageLoader.swift
//  Millie
//
//  Created by Yun Ha on 2024/04/21.
//

import Foundation
import UIKit

final class ImageLoader {
    
    static let shared = ImageLoader()
    
    
    private init () { }
    
    /// 뉴스 섬네일 이미지를 로컬에 저장
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - newsURLString: 파일 이름으로 사용되는 뉴스 URL 문자열(urlToImage 아님)
    func saveImage(image: UIImage, newsURLString: String) {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else { return }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return
        }
        
        let fileName = self.convertFileName(from: newsURLString)
        
        do {
            try data.write(to: directory.appendingPathComponent(fileName)!)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    /// 로컬에 저장된 뉴스 섬네일 이미지를 불러옴
    /// - Parameter newsURLString: 파일 이름으로 사용되는 뉴스 URL 문자열(urlToImage 아님)
    /// - Returns: 만약 저장된 이미지가 있으면 해당 이미지를 반환하고, 이미지가 없다면 nil을 반환
    func getLocalImage(newsURLString: String) -> UIImage? {
        let fileName = self.convertFileName(from: newsURLString)
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(fileName).path)
        } else {
            return nil
        }
    }
    
    func convertFileName(from urlString: String) -> String {
        return urlString.components(separatedBy: .punctuationCharacters).joined()
    }
}
