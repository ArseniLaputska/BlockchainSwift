//
//  Blockchain.swift
//  Blockchain
//
//  Created by Arseni Laputska on 12.10.21.
//

import Foundation
import KituraKit
import KituraContracts
import KituraNet
import CryptoSwift
import SwiftyRequest
import Logging

class Blockchain: Chain {
  
  //Properties
  var chain: [Block]
  var current_transaction: [Transaction]
  var nodes: Set<String>
  
  //Initializers
  init() {
    chain = []
    current_transaction = []
    nodes = Set()
    
    //Create the genesis block
    self.newBlock(previous_hash: "1", proof: 100)
  }
  
  func newBlock(previous_hash: String?, proof: Int64) -> Block {
    let block = Block(index: Int64(self.chain.count + 1),
                      timestamp: Date(),
                      transactions: self.current_transaction,
                      proof: proof,
                      previous_hash: previous_hash ?? self.hash(block: self.last_block)
    )
    
    //Сбрасываем текущий список транзакций
    self.current_transaction = []
    self.chain.append(block)
    
    return block
  }
  
  func newTransaction(sender: String, recipient: String, amount: Int64) -> Int64 {
    let transaction = Transaction(sender: sender, recipient: recipient, amount: amount)
    self.current_transaction.append(transaction)
    
    return self.last_block.index + 1
  }
  
  var last_block: Block {
    return self.chain[self.chain.count - 1]
  }
  
  func hash(block: Block) -> String {
    let encoder = JSONEncoder()
    // Мы должны убедиться, что словарь упорядочен, иначе у нас будут противоречивые хэши.
    if #available(OSX 10.13, *) {
      encoder.outputFormatting = .sortedKeys
    }
    
    let str = try! String(data: encoder.encode(block), encoding: .utf8)!
    return str.sha256()
  }
  
  /**
   Простой Proof of Work алгоритм:
   
   - Найти число p' такое, что hash(pp') содержит 4 ведущих нуля, где p - предыдущее p'
   - p - предыдущее доказательство, а p' - новое доказательство.
   - Parameter: last_proof: Int64
   - returns: Int64
   */
  func proofOfWork(last_proof: Int64) -> Int64 {
    var proof: Int64 = 0
    while !self.validProof(last_proof: last_proof, proof: proof) {
      proof += 1
    }
    
    return proof
  }
  
  /**
   Проверяет доказательство: Содержит ли hash(last_proof, proof) 4 ведущих нуля?
   
   - Parameter last_proof: <int> Предыдущее доказательство
   - Parameter proof: <int> Текущее доказательство
   - returns: True, если верно, False, если нет.
   */
  func validProof(last_proof: Int64, proof: Int64) -> Bool {
    let guess = "\(last_proof)\(proof)"
    let guess_hash = guess.sha256()
    return guess_hash.suffix(4) == "0000"
  }
  
  // Генерируем глобально уникальный адрес для этого узла
  var node_identifier: String {
    return ProcessInfo().globallyUniqueString.replacingOccurrences(of: "-", with: "")
  }
  
  /**
  Добавляем новый узел в список всех узлов
  
  - Parameter address: Адрес узла. Например: 'http://192.168.0.5:5000'
  */
  func registerNode(address: String) -> Bool {
    let options = ClientRequest.
  }
}
