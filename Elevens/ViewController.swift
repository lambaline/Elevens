//
//  ViewController.swift
//  Elevens
//
//  Created by Mike Chu on 8/27/15.
//  Copyright © 2015 Mike Chu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var img0:UIImageView!
    @IBOutlet var img1:UIImageView!
    @IBOutlet var img2:UIImageView!
    @IBOutlet var img3:UIImageView!
    @IBOutlet var img4:UIImageView!
    @IBOutlet var img5:UIImageView!
    @IBOutlet var img6:UIImageView!
    @IBOutlet var img7:UIImageView!
    @IBOutlet var img8:UIImageView!
    @IBOutlet var img9:UIImageView!
    @IBOutlet var img10:UIImageView!
    @IBOutlet var replaceButton:UIButton!
    
    @IBOutlet var progress:UIProgressView!
    @IBOutlet var reset : UIButton!
    @IBOutlet var cardsRemaining : UILabel!
    @IBOutlet var winLabel : UILabel!
    //var isPlayable = false
    
    var debug = false
    var ranks = ["ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king"]
    var suits = ["spades", "hearts", "diamonds", "clubs"]
    var point_values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 0, 0, 0]
    var deck = [Card]()
    var cards = [Card]()
    var imgViews = [UIImageView]()
    var cardsLength=0// = cards.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupArray()
        cardsLength = cards.count
        updateUI()
        selected = [:]
        replaceButton.enabled = true
        cardsRemaining.text = "\(cardsLength) cards left"
        winLabel.text = ""
        //winLabel.alpha = 0
        anotherPlayIsPossible()
    }
    
    @IBAction func imgTapped(sender: UIButton)
    {
        setSelected(sender.tag)
    }
    
    func setupArray()
    {
        imgViews = [img0 ,img1, img2, img3, img4, img5
        , img6, img7, img8, img9, img10]
    }
    
    var selected:[Int:Card] = [0:Card(r: "a", s: "a", p: 0)]
    
    func setSelected(a: Int)
    {
        let name = "\(deck[a].rank)\(deck[a].suit)"
        if(!(deck[a].rank=="done"))
        {
            if(!deck[a].selected)
            {
                imgViews[a].image = UIImage(named: "\(name)S")
                deck[a].selected = true
                //name.hash
                selected[a] = deck[a]
            }
            else
            {
                imgViews[a].image = UIImage(named: name)
                deck[a].selected = false
                selected.removeValueForKey(a)
            }
        }
        
    }
    
    func checkWin() -> Bool
    {
        //var hasWon = true
        for a in 0...deck.count
        {
            if((deck[a].rank != "done"))
            {
                return false
            }
        }
        return true
    }
    
    func anotherPlayIsPossible() ->Bool
    {
        
            for a in 0...deck.count - 2
            {
                for b in a+1...deck.count - 1
                {
                    if(deck[a].pointVal + deck[b].pointVal == 11)
                    {
                        return true
                    }
                }
            }
            var cJ = false
            var cQ = false
            var cK = false
            for a in 0...deck.count - 2
            {
                if(deck[a].rank == "jack")
                {
                    cJ = true
                }
                if(deck[a].rank == "queen")
                {
                    cQ = true
                }
                if(deck[a].rank == "king")
                {
                    cK = true
                }
            }
            if(cJ && cQ && cK)
            {
                return true
            }
        
        return false
    }
    
    @IBAction func replaceCards(sender:UIButton)
    {
        if(!debug)
        {
            if(selected.count == 2)
            {
                if(checksum11())
                {
                    replaceCard()
                    //sleep(1)
                    if(!anotherPlayIsPossible() && !checkWin())
                    {
                        winLabel.text = "You loose"
                        winLabel.textColor = UIColor.redColor()
                        sender.enabled = false
                    }
                    else if(checkWin())
                    {
                        winLabel.text = "You win"
                        winLabel.textColor = UIColor.greenColor()
                        sender.enabled = false
                    }
                }
            }
            else if(selected.count == 3)
            {
                if(checkJKQ())
                {
                    replaceCard()
                    if(!anotherPlayIsPossible() && !checkWin())
                    {
                        winLabel.text = "You loose"
                        winLabel.textColor = UIColor.redColor()
                        sender.enabled = false
                    }
                    else if(checkWin())
                    {
                        winLabel.text = "You win"
                        winLabel.textColor = UIColor.greenColor()
                        sender.enabled = false
                    }
                }
            }
            else
            {
                replaceCard()
            }
        }
        else
        {
            replaceCard()
        }
    }
    
    func checksum11() -> Bool
    {
        var sum=0
        for aCard in selected
        {
            sum = sum + aCard.1.pointVal
        }
        if(sum == 11)
        {
            return true
        }
        return false
    }
    
    func checkJKQ() -> Bool
    {
        var containsJ = false
        var containsK = false
        var containsQ = false
        for a in selected
        {
            
            if(a.1.rank == "jack")
            {
                containsJ = true
            }
            else if(a.1.rank == "king")
            {
                containsK = true
            }
            else if(a.1.rank == "queen")
            {
                containsQ = true
            }
        }
        return containsJ && containsK && containsQ
    }
    
    @IBAction func toggleDebug(sender: UIButton)
    {
        if(debug)
        {
            debug = false
            self.view.backgroundColor = UIColor.whiteColor()
            sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        }
        else
        {
            debug = true
            self.view.backgroundColor = UIColor.redColor()
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func reset(sender: UIButton)
    {
        deck = []
        cards = []
        viewDidLoad()
    }
    
    func updateUI()
    {
        progress.alpha = 100
        progress.setProgress(0, animated: false)
        makeCards()
        
        progress.setProgress(0.25, animated: true)
        randomize()
        
        progress.setProgress(0.50, animated: true)
        populate()
        
        progress.setProgress(0.75, animated: true)
        placeImages()
        
        
        progress.setProgress(1, animated: true)
        // sleep(1)
        //progress.alpha = 0
    }

    func makeCards()
    {
        for index in 0...12
        {
            for i in suits
            {
                cards.append(Card(r: ranks[index], s: i, p: point_values[index]))
            }
        }
    }
    
    func replaceCard()
    {
        var a = 0
        var name = ""
        for aCard in selected
        {
            if(cardsLength > 0)
            {
                a = aCard.0
                name = "\(cards[cardsLength].rank)\(cards[cardsLength].suit)"
                imgViews[a].image = UIImage(named: name)
                deck[a]=cards[cardsLength]
                cardsLength = cardsLength - 1
            }
            else
            {
                a = aCard.0
                name = "back1"
                imgViews[a].image = UIImage(named: name)
                aCard.1.rank = "done"
                //cardsLength = cardsLength - 1
            }
        }
        cardsRemaining.text = "\(cardsLength) cards left"
        selected = [:]
    }
    
    func randomize()
    {
        var r = 0
        var temp : Card
        
        //let b = UInt32(a)
        for index in 0...cards.count-1
        {
            r = Int(arc4random_uniform(UInt32(cards.count)))
            temp = cards[index]
            cards[index] = cards[r]
            cards[r] = temp
        }
    }
    
    func populate()
    {
        var max = cards.count
        var index = 0
        repeat
        {
            deck.append(cards[index])
            index++
            max--
        }while(index<=10)
        cardsLength = max
    }
    
    
    func placeImages()
    {
        var name = ""
        var crdNames = [String]()
        
        for a in 0...deck.count-1
        {
            name = "\(deck[a].rank)\(deck[a].suit)" //acespades
            crdNames.append(name)
        }
        
        for num in 0...10
        {
            imgViews[num].image = UIImage(named: crdNames[num])
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
