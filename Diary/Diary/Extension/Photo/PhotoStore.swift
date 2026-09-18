//
//  PhotoStore.swift
//  Diary
//
//  Created by Valentine Grieda Sahuburua on 14/09/26.
//
import Foundation
import UIKit

enum PhotoStore {
    static var folder: URL {
        let url = URL.documentsDirectory.appending(path: "DiaryPhotos")
        if !FileManager.default.fileExists(atPath: url.path()) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        }
        return url
    }

    /// Simpan data, kembalikan nama filenya
    static func save(_ data: Data) -> String? {
        let name = "\(UUID().uuidString).jpeg"
        do {
            try data.write(to: folder.appending(path: name), options: .atomic)
            return name
        } catch {
            print("Gagal simpan foto:", error)
            return nil
        }
    }

    static func load(_ name: String) -> UIImage? {
        UIImage(contentsOfFile: folder.appending(path: name).path())
    }

    static func delete(_ names: [String]) {
        for name in names {
            try? FileManager.default.removeItem(at: folder.appending(path: name))
        }
    }
    
    static func thumbnail(_ name: String, maxPixel: CGFloat = 200) -> UIImage? {
        let url = folder.appending(path: name)
        guard let src = CGImageSourceCreateWithURL(url as CFURL, nil) else { return nil }
        let opts: [CFString: Any] = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxPixel
        ]
        guard let cg = CGImageSourceCreateThumbnailAtIndex(src, 0, opts as CFDictionary) else { return nil }
        return UIImage(cgImage: cg)
    }
    
    static func downscale(_ data: Data, maxSide: CGFloat = 1200) -> Data? {
            guard let ui = UIImage(data: data) else { return nil }
            let scale = min(1, maxSide / max(ui.size.width, ui.size.height))
            let size = CGSize(width: ui.size.width * scale, height: ui.size.height * scale)
            let renderer = UIGraphicsImageRenderer(size: size)
            let out = renderer.image { _ in ui.draw(in: CGRect(origin: .zero, size: size)) }
            return out.jpegData(compressionQuality: 0.8)
        }
    
    static func saveCompressed(_ data: Data, maxSide: CGFloat = 1200) -> String? {
            guard let small = downscale(data, maxSide: maxSide) else { return nil }
            return save(small)
        }
}
