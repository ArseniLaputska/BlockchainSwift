//
//  Blockchain.swift
//  Swift-Blockchain
//
//  Created by Arseni Laputska on 14.10.21.
//

import Foundation

open class Blockchain: Codable {
  static var blockTime = 3.0
  public var blocks: [Block] = []
  public var length: Int { return blocks.count }
  public var lastBlock: Block { return blocks.last! }
  public var currentDifficulty: Int {
    let now = Date.timeIntervalSinceReferenceDate
    let lastDifficulty = lastBlock.difficulty
    let lastBlockTime = lastBlock.time
    let maxTime = lastBlockTime + Blockchain.blockTime
    let newDifficulty = maxTime >= now ? lastDifficulty + 1 : lastDifficulty - 1
    
    return newDifficulty > 0 ? newDifficulty : 0
  }
  
  internal lazy var genesisBlock: Block = {
    var block = Block(lastBlock: nil, data: nil, difficulty: 0)
    block.mine(at: 0)
    return block
  }()
  
  public init(data: Data) {
    var genesisBlock = Block(lastBlock: nil, data: data, difficulty: currentDifficulty)
    genesisBlock.mine(at: currentDifficulty)
    blocks.append(genesisBlock)
  }
  
  public init() {
    blocks.append(genesisBlock)
  }
  
  public func addBlock(data: Data) -> Block {
    var block = Block(lastBlock: lastBlock, data: data, difficulty: currentDifficulty)
    block.mine(at: currentDifficulty)
    blocks.append(block)
    return block
  }
}

extension Blockchain: Comparable {
  public static func < (lhs: Blockchain, rhs: Blockchain) -> Bool {
    return lhs.blocks.count < rhs.blocks.count
  }
  
  public static func == (lhs: Blockchain, rhs: Blockchain) -> Bool {
    return lhs.blocks == rhs.blocks && lhs.currentDifficulty == rhs.currentDifficulty
  }
}
