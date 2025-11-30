//
//  ContentView.swift
//  MalaysionKicker_v1.1
//
//  Created by Илья Моторов on 29/11/2568 BE.
//
import SwiftUI
import SpriteKit

struct ContentView: View {

    var scene: SKScene {
        let s = GameScene(size: CGSize(width: 1536, height: 1024))
        s.scaleMode = .aspectFit
        return s
    }

    var body: some View {
        SpriteView(scene: scene)
            .ignoresSafeArea()
    }
}
