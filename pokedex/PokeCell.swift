//
//  PokeCell.swift
//  pokedex
//
//  Created by Admin on 7/26/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 15.0
    }
    
    
    
    func configureCell(pokemon: Pokemon) {
        self.pokemon = pokemon
        
        nameLbl.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId)")
    }
}
