//
//  PokemonDetailVC.swift
//  pokedex
//
//  Created by Admin on 7/28/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLBL: UILabel!
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nameLBL.text = pokemon.name
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
