import SpriteKit

class GameScene: SKScene {
    
    var player: SKSpriteNode!
    var walkAnimation: SKAction!
    var idleTexture: SKTexture!
    let playerCategory: UInt32 = 0x1 << 0
   
  
    
    let backgroundNames = [
        "backgroundScene1.1",
        "backgroundScene1.2",
        "backgroundScene1.3"
    ]
    
    
    let roadMinY: CGFloat = 120  // нижняя граница дороги
    let roadMaxY: CGFloat = 350   // верхняя граница дороги

    var currentBGIndex = 0
    var backgroundNode: SKSpriteNode!
    
    
    var moveLeft = false
    var moveRight = false
    let moveSpeed: CGFloat = 4.0   // скорость (можно менять)
    
    
    
    override func didMove(to view: SKView) {
        self.size = CGSize(width: 1536, height: 1024)
        self.scaleMode = .aspectFit
        backgroundColor = .black
        
        setupBackground()
        setupPlayer()
        
        view.window?.makeFirstResponder(self)
    }
    
    func setupBackground() {
        let name = backgroundNames[currentBGIndex]
        backgroundNode = SKSpriteNode(imageNamed: name)
        backgroundNode.anchorPoint = CGPoint(x: 0, y: 0)
        backgroundNode.position = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = -10
        backgroundNode.size = backgroundNode.texture!.size()
        addChild(backgroundNode)
    }
    
    func setupPlayer() {
        let atlas = SKTextureAtlas(named: "Player")

        // сортировка кадров
        let frames = atlas.textureNames
            .sorted { a, b in
                let na = Int(a.replacingOccurrences(of: "walk_", with: "").replacingOccurrences(of: ".png", with: "")) ?? 0
                let nb = Int(b.replacingOccurrences(of: "walk_", with: "").replacingOccurrences(of: ".png", with: "")) ?? 0
                return na < nb
            }
            .map { atlas.textureNamed($0) }

        guard let firstFrame = frames.first else { return }

        idleTexture = firstFrame

        // создаём ТОЛЬКО ОДИН спрайт
        player = SKSpriteNode(texture: idleTexture)
        player.position = CGPoint(x: 400, y: 200)
        player.zPosition = 10
        player.setScale(0.25)     // уменьшаем в 4 раза
        addChild(player)

        // анимация
        walkAnimation = SKAction.repeatForever(
            SKAction.animate(with: frames, timePerFrame: 0.12)
        )
    }
    
    override func keyDown(with event: NSEvent) {
        let move: CGFloat = 20
        
        // запуск анимации если её нет
        if player.action(forKey: "walk") == nil {
            player.run(walkAnimation, withKey: "walk")
        }
        
        switch event.keyCode {
        case 123: // ← left
                moveLeft = true
                moveRight = false
                player.xScale = -abs(player.xScale)
                startWalkAnimation()
            
//               player.xScale = -abs(player.xScale)
//               player.position.x -= move
//
//               // если персонаж ушёл за левый край сцены
//               if player.position.x < 0 {
//                   goToPreviousBackgroundFromLeft()
//               }
            
        case 124: // →
            moveRight = true
                   moveLeft = false
                   player.xScale = abs(player.xScale)
                   startWalkAnimation()
//            player.xScale = abs(player.xScale)
//            player.position.x += move
//
//            // если персонаж ушёл за правый край
//            if player.position.x > self.size.width {
//                goToNextBackgroundFromRight()
//            }
            
        case 125:
               if player.position.y - move >= roadMinY {
                   player.position.y -= move
               }

           // ↑ UP — но только пока не достиг roadMaxY
           case 126:
               if player.position.y + move <= roadMaxY {
                   player.position.y += move
               }
        case 49: // Space
            changeBackground()
            
        default: break
        }
    }
    override func keyUp(with event: NSEvent) {
           moveLeft = false
           moveRight = false
           stopWalkAnimation()
//        player.removeAction(forKey: "walk")
//        player.texture = idleTexture      // ⬅️ вернуть спрайт, чтобы не исчезал
    }
    func changeBackground() {
        currentBGIndex = (currentBGIndex + 1) % backgroundNames.count

        let newTexture = SKTexture(imageNamed: backgroundNames[currentBGIndex])
        newTexture.filteringMode = .nearest
        backgroundNode.texture = newTexture
        backgroundNode.size = newTexture.size()
    }
    func goToNextBackgroundFromRight() {
        // переключаем фон
        currentBGIndex = (currentBGIndex + 1) % backgroundNames.count

        let newTexture = SKTexture(imageNamed: backgroundNames[currentBGIndex])
        newTexture.filteringMode = .nearest
        backgroundNode.texture = newTexture
        backgroundNode.size = newTexture.size()

        // появляется немного слева за экраном
        player.position.x = -50
    }
    func goToPreviousBackgroundFromLeft() {
        currentBGIndex -= 1
        if currentBGIndex < 0 {
            currentBGIndex = backgroundNames.count - 1
        }

        let newTex = SKTexture(imageNamed: backgroundNames[currentBGIndex])
        newTex.filteringMode = .nearest
        backgroundNode.texture = newTex
        backgroundNode.size = newTex.size()

        // появляемся справа за экраном
        player.position.x = self.size.width + 50
    }
//    func startWalkAnimation() {
//        if player.action(forKey: "walk") == nil {
//            player.run(walkAnimation, withKey: "walk")
//        }
//    }
//
//    func stopWalkAnimation() {
//        player.removeAction(forKey: "walk")
//        player.texture = idleTexture
//    }
    func startWalkAnimation() {
        if player.action(forKey: "walk") == nil {
            player.run(walkAnimation, withKey: "walk")
        }
    }

    func stopWalkAnimation() {
        player.removeAction(forKey: "walk")
        player.texture = idleTexture
    }
    override func update(_ currentTime: TimeInterval) {
        if moveLeft {
            player.position.x -= moveSpeed
        }
        if moveRight {
            player.position.x += moveSpeed
        }
    }
}
