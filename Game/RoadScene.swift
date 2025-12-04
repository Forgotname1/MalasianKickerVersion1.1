//
//  RoadScene.swift
//  MalaysionKicker_v1.1
//
//  Created by Илья Моторов on 4/12/2568 BE.
//
import SpriteKit

class RoadScene: SKScene {

    private var bikeSprite: SKSpriteNode!
    
    var keyboard = KeyboardController()
    var roadLeft: CGFloat = 400
    var roadRight: CGFloat = 1130
    var bikeSpeed: CGFloat = 8
    let maxTilt: CGFloat = 0.25      // максимальный наклон (радианы)
    let tiltSpeed: CGFloat = 0.12    // скорость плавного наклона
    
    private var roadFrames: [SKTexture] = []
    private var roadSprite: SKSpriteNode!

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        view.window?.makeFirstResponder(view)

        backgroundColor = .black

        // ---- 1. Загружаем кадры из атласа ----
        let atlas = SKTextureAtlas(named: "RoadScene")
        let frameNames = atlas.textureNames.sorted()   // сортируем чтобы было 1,2,3...

        roadFrames = frameNames.map { atlas.textureNamed($0) }

        // ---- 2. Создаём спрайт дороги ----
        roadSprite = SKSpriteNode(texture: roadFrames.first!)
        roadSprite.zPosition = 0
        roadSprite.position = CGPoint(x: size.width/2, y: size.height/2)
        roadSprite.size = CGSize(width: 1112, height: 1536)
        addChild(roadSprite)

        // ---- 3. Создаём байк ----
        bikeSprite = SKSpriteNode(imageNamed: "BikeRoadSprite")
        bikeSprite.position = CGPoint(x: size.width/2, y: 260)
        bikeSprite.zPosition = 10
        bikeSprite.setScale(1.7)
        addChild(bikeSprite)
    }
    
    override func keyDown(with event: NSEvent) {
        keyboard.keyDown(event.keyCode, flags: event.modifierFlags)
    }

    override func keyUp(with event: NSEvent) {
        keyboard.keyUp(event.keyCode)
    }
    
    override func update(_ currentTime: TimeInterval) {

        var targetTilt: CGFloat = 0

        // ← движение
        if keyboard.left {
            bikeSprite.position.x -= bikeSpeed
            targetTilt = maxTilt
        }

        // → движение
        if keyboard.right {
            bikeSprite.position.x += bikeSpeed
            targetTilt = -maxTilt
        }

        // ВПЕРЁД — запускаем анимацию дороги!
        if keyboard.up {
            startRoadAnimation()
        } else {
            stopRoadAnimation()
        }

        // ограничение дороги
        if bikeSprite.position.x < roadLeft { bikeSprite.position.x = roadLeft }
        if bikeSprite.position.x > roadRight { bikeSprite.position.x = roadRight }

        // плавный наклон
        let delta = targetTilt - bikeSprite.zRotation
        bikeSprite.zRotation += delta * tiltSpeed
    }
    
    
    func startRoadAnimation() {
        if roadSprite.action(forKey: "roadMove") == nil {
            let animation = SKAction.animate(with: roadFrames, timePerFrame: 0.04)
            let forever = SKAction.repeatForever(animation)
            roadSprite.run(forever, withKey: "roadMove")
        }
    }

    func stopRoadAnimation() {
        roadSprite.removeAction(forKey: "roadMove")
    }
}
