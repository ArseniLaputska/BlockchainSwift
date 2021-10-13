//
//  Chain.swift
//  Chain
//
//  Created by Arseni Laputska on 12.10.21.
//

import Foundation

struct Block: Codable {
  var index: Int64
  var timestamp: Date
  var transactions: [Transactions]
  var proof: Int64
  var previous_hash: String
}

struct Transaction: Codable {
  var sender: String
  var recipient: String
  var amount: Int64
}

protocol Chain: class {
  
  var chain: [Block] {get}
  var current_transaction: [Transaction] {get}
  var nodes: Set<String> {get}
 
  /**
   # Создаем новый блок и добавляем его в цепь.
   
   - Parameter  proof: <int> Подтверждение, получаемое с алгоритма Proof of Work
   - Parameter  previous_hash: (Optional) <str> Хэш предыдущего блока
   - returns: _dict_ Новый блок
   */
  func newBlock(previous_hash: String?, proof: Int64) -> Block

  /**
   Создает новую транзакцию для перехода в следующий добытый блок.
   
   - Parameter sender: Адрес отправителя
   - Parameter recipient: Адрес получателя
   - Parameter amount: Количество
   - returns: Индекс блока, в котором будет храниться данная транзакция.
   */
  func newTransaction(sender: String, recipient: String, amount: Int64) -> Int64
  
  /**
   Возвращает последний блок в цепи
  */
  var last_block: Block {get}
  
  /**
   Создает SHA-256 хэш блока.
   
   - Parameter block: <dict> Блок
   - returns: Строка
   */
  func hash(block: Block) -> String
  
}
