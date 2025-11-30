import SpriteKit

class GameScene: SKScene {
    
    let playerCategory: UInt32 = 0x1 << 0
    var player: Player!
    var bgManager: BackgroundManager!
    var keyboard = KeyboardController()
    
    
    
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
        bgManager = BackgroundManager()
        // фиксированный размер под фон
        self.size = CGSize(width: 1536, height: 1024)
        self.scaleMode = .aspectFit
        backgroundColor = .black

        // загружаем фоны
        bgManager.loadBackgrounds(
            names: ["backgroundScene1.1", "backgroundScene1.2", "backgroundScene1.3"],
            into: self
        )

        // создаём игрока
        setupPlayer()

        // включаем обработку клавиш
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
        player = Player()
        player.position = CGPoint(x: 400, y: 200)
        addChild(player)
    }
    
    override func keyDown(with event: NSEvent) {
        keyboard.keyDown(event.keyCode, flags: event.modifierFlags)
    }
    
    override func keyUp(with event: NSEvent) {
        keyboard.keyUp(event.keyCode)
        player.stopWalkAnimation()
        player.currentSpeed = player.walkSpeed
    }
    
    override func update(_ currentTime: TimeInterval) {

        // Границы перехода между фонами
        let rightSwitchX: CGFloat = 1450
        let leftSwitchX: CGFloat = 50

        // Границы дороги
        let minY: CGFloat = 180
        let maxY: CGFloat = 280

        // Если нажата хоть одна стрелка — стартуем walk/run
        if keyboard.left || keyboard.right || keyboard.up || keyboard.down {
            if keyboard.shift {
                player.currentSpeed = player.runSpeed   // бег
                player.startRunAnimation()
            } else {
                player.currentSpeed = player.walkSpeed  // шаг
                player.startWalkAnimation()
            }
        }

        // ← движение влево
        if keyboard.left {
            player.moveLeft()

            // переход на предыдущий фон
            if player.position.x < leftSwitchX {
                bgManager.previousBackground()
                player.position.x = 1500   // появляемся справа
            }
        }

        // → движение вправо
        if keyboard.right {
            player.moveRight()

            // переход на следующий фон
            if player.position.x > rightSwitchX {
                bgManager.nextBackground()
                player.position.x = 80     // появляемся слева
            }
        }

        // ↓ движение вниз (ограничено дорогой)
        if keyboard.down {
            player.moveDown()
            if player.position.y < minY { player.position.y = minY }
        }

        // ↑ движение вверх (ограничено дорогой)
        if keyboard.up {
            player.moveUp()
            if player.position.y > maxY { player.position.y = maxY }
        }
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

}
