//
//  ViewController.swift
//  pokedex
//
//  Created by Admin on 7/25/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var bgImage: UIImageView!

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addParallaxToView(vw: bgImage)
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        parsePokemonCSV()
        initAudio()
        
        searchBar.returnKeyType = UIReturnKeyType.done
    }

    func parsePokemonCSV(){
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokId = Int(row["id"]!)!
                let name = row["identifier"]!
                
                let poke = Pokemon(name: name, pokedexId: pokId)
                pokemon.append(poke)
            }
        }catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            let poke: Pokemon
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
            } else {
                poke = pokemon[indexPath.row]
                cell.configureCell(pokemon: poke)
            }
            
            return cell
        } else
        {
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        } else {
            return pokemon.count
        }
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
    
    
    @IBAction func musicBtn(_ sender: Any) {
        if musicPlayer.isPlaying{
            musicPlayer.pause()
        } else { musicPlayer.play() }
    
    }
    
    func initAudio(){
        let path = Bundle.main.path(forResource: "pth", ofType: "mp3")!
        
        do{
        
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.volume = 0.05
            musicPlayer.play()
            
        }
        catch let err as NSError { print(err.debugDescription) }
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercased()
            filteredPokemon = pokemon.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "PokemonDetailVC" {
            if let detailsVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
        
    }
    
    //animations
    func addParallaxToView(vw: UIView) {
        let amount = 20
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
}

