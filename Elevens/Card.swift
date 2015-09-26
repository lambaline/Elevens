//
//  Card.swift
//  Elevens
//
//  Created by Mike Chu on 8/28/15.
//  Copyright © 2015 Mike Chu. All rights reserved.
//

import Foundation
import UIKit

class Card
{
    var rank: String
    var suit: String
    var pointVal: Int
    var selected: Bool
    
    init(r:String, s:String, p:Int)
    {
        rank = r
        suit = s
        pointVal = p
        selected = false
    }
    
    func getSuit() -> String
    {
        return suit
    }
    
    func getRank() -> String
    {
        return rank
    }
    
    func getPointVal() -> Int
    {
        return pointVal
    }
    
    func matches(a: Card) -> Bool
    {
        if(rank == a.rank && suit == a.rank && pointVal == a.pointVal)
        {
            return true
        }
        return false
    }
    
    func toString() -> String
    {
        return "\(rank) of \(suit) (point value = \(pointVal) )"
    }
}