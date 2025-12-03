//
//  Bike.swift
//  MalaysionKicker_v1.1
//
//  Created by Илья Моторов on 2/12/2568 BE.
//

import SpriteKit

class Bike: SKSpriteNode {

    private var driveFrames: [SKTexture] = []
    private var idleTexture: SKTexture!

    var isRiding = false

    init() {
        // начальная текстура (байк стоит)
        let idle = SKTexture(imageNamed: "bike_idle")
        idleTexture = idle

        super.init(texture: idle, color: .clear, size: idle.size())

        self.zPosition = 50
        self.name = "bike"
        self.setScale(0.15)
        loadDriveAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadDriveAnimation() {
        let atlas = SKTextureAtlas(named: "Bike")
        let names = atlas.textureNames.sorted()

        for name in names {
            let tex = atlas.textureNamed(name)
            tex.filteringMode = .nearest
            driveFrames.append(tex)
        }
    }

    func startDriveAnimation() {
        guard !isRiding else { return }
        isRiding = true

        let action = SKAction.repeatForever(
            SKAction.animate(with: driveFrames, timePerFrame: 0.10)
        )
        run(action, withKey: "drive")
    }

    func stopDriveAnimation() {
        isRiding = false
        removeAction(forKey: "drive")
        texture = idleTexture
    }

    func driveOffScreen(completion: @escaping () -> Void = {}) {
        let move = SKAction.moveBy(x: 2000, y: 0, duration: 3.0)
        let done = SKAction.run(completion)
        let seq = SKAction.sequence([move, done])
        run(seq)
    }
}
