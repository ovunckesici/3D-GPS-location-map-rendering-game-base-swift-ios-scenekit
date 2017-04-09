//
//  NPCView.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//
import Foundation
import UIKit
import SwiftyJSON
import Starscream

class NPCInterface: CardinalInterface {
    private let npc: NPC
    private let occupy: Btn
    private let attack: Btn
    
    init(npc: NPC) {
        occupy = Btn(title: "Occupy", position: CGPoint(x: 50, y: 300))
        attack = Btn(title: "Attack", position: CGPoint(x: 50, y: 300))
        self.npc = npc
        super.init()
        attack.centerInParent()
        occupy.centerInParent()
        occupy.addTarget(self, action: #selector(self.doOccupy), for: .touchDown)
        attack.addTarget(self, action: #selector(self.doAttack), for: .touchDown)
        
        update()
        
        let name = Label(text: npc.name, frame: CGRect(x: 0, y: 20, width: CardinalInterface.subviewWidth, height: 30))
        name.textAlignment = .center
        name.font = name.font.withSize(20)
        addSubview(v: name)
        
        if npc.type == 1 {
            let aug = Btn(title: "aug", position: CGPoint(x: 0, y: 200))
            aug.addTarget(self, action: #selector(augmentedCall), for: .touchDown)
            view.addSubview(aug)
            aug.centerInParent()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(npcUpdateNotification), name: NSNotification.Name(rawValue: "npc-\(npc.id)"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func augmentedCall() {
        let _ = AugmentedViewController()
    }
    
    @objc func npcUpdateNotification(note: NSNotification) {
        //(note.object as! Homebase).placeHomebaseIfOn(mapTile: self)
        update()
    }
    
    func update() {
        if npc.type == 2 {
            DispatchQueue.main.async {
                if self.npc.occupy == nil {
                    self.attack.removeFromSuperview()
                    self.addSubview(v: self.occupy)
                } else {
                    self.addSubview(v: self.attack)
                    self.occupy.removeFromSuperview()
                }
            }
        }
    }
    
    @objc func doOccupy(_ sender: AnyObject?) {
        AppPickingInterface().show(onPickTarget: self, onPick: #selector(appsPicked))
    }

    func appsPicked(apps: [String]) {
        API.post(endpoint: "npc/\(npc.id)/occupy", params: [ "apps": apps ]) { (data) in
        }
    }

    
    func doAttack(_ sender: AnyObject?) {
        NPCBattle().show(npc: npc)

        close()
    }


    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
}
