//
//  Block.swift
//  Swift-Blockchain
//
//  Created by Arseni Laputska on 14.10.21.
//

import Foundation
import CryptoSwift

public struct Block: Codable {
  static let defaultHash = String(repeating: "0", count: 64)
  var index: Int
  var nonce: Int
  var previousHash: String
  var dataHash: String
  var difficulty: Int
  var hashValue: String
  var time: TimeInterval = Date.timeIntervalSinceReferenceDate
  private (set) var data: Data?
  
  internal init(lastBlock: Block?, data: Data?, difficulty: Int) {
    let lastIndex = lastBlock?.index
    let lastHash = lastBlock?.hashValue
    let targetIndex = lastIndex != nil ? lastIndex! + 1 : 0
    
    self.data = data
    self.index = targetIndex
    self.previousHash = lastHash ?? Block.defaultHash
    self.difficulty = difficulty
    self.time = Date.timeIntervalSinceReferenceDate
    self.nonce = 0
    self.hashValue = ""
    self.dataHash = ""
  }
  
  var key: String {
    return String(index) + String(nonce) + previousHash + dataHash + String(difficulty)
  }
  
  func computeHash() -> String {
    return key.sha256()
  }
  
  internal mutating func mine(at difficulty: Int) {
    let difficultyPrefix = String(repeating: "0", count: difficulty)
    
    // Compute the hash for the data in this block
    if let data = self.data {
      self.dataHash = data.sha256().toHexString()
    }
    
    // Hash the header values until one fits the current difficulty
    self.hashValue = self.computeHash()
    while !self.hashValue.hasPrefix(difficultyPrefix) {
      self.nonce += 1
      self.hashValue = self.computeHash()
    }
  }
}

extension Block: Equatable {
  public static func == (lhs: Block, rhs: Block) -> Bool {
    return lhs.index == rhs.index &&
      lhs.nonce == rhs.nonce &&
      lhs.previousHash == rhs.previousHash &&
      lhs.dataHash == rhs.dataHash &&
      lhs.difficulty == rhs.difficulty &&
      lhs.hashValue == rhs.hashValue &&
      lhs.time == rhs.time &&
      lhs.data == rhs.data
  }
}
