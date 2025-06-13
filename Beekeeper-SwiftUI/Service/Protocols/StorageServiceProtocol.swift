//
//  StorageServiceProtocol.swift
//  Beekeeper-SwiftUI
//
//  Created by Paweł Rudnik on 13/06/2025.
//

import Foundation
import UIKit

protocol StorageServiceProtocol {
    func uploadHiveImage(_ image: UIImage, hiveId: String) async throws -> String
    func deleteHiveImage(at url: String) async throws
}
