import SpriteKit

class GameScene: SKScene {

    // MARK: - Core
    var player: Player!
    var bgManager: BackgroundManager!
    var keyboard = KeyboardController()

    // Байк
    var parkedBike: SKSpriteNode?   // статичный байк на фоне
    var bike: Bike?
    var isOnBike = false
    // анимированный байк с игроком
    let bikeSpawnIndex = 2      // байк появляется на третьем фоне

    // Подсказка
    var hint: InteractionHint?

    // Границы переходов
    let rightSwitchX: CGFloat = 1450
    let leftSwitchX: CGFloat = 50

    // Границы дороги
    let minY: CGFloat = 180
    let maxY: CGFloat = 280


    // MARK: - Scene Init
    override func didMove(to view: SKView) {

        bgManager = BackgroundManager()
        size = CGSize(width: 1536, height: 1024)
        scaleMode = .aspectFit
        backgroundColor = .black

        bgManager.loadBackgrounds(
            names: ["backgroundScene1.1", "backgroundScene1.2", "backgroundScene1.3"],
            into: self
        )

        setupPlayer()

        // включаем клавиши
        view.window?.makeFirstResponder(self)
    }


    // MARK: - Player
    func setupPlayer() {
        player = Player()
        player.position = CGPoint(x: 400, y: 200)
        addChild(player)
    }


    // MARK: - Bike spawn
    func spawnParkedBike() {
        guard parkedBike == nil else { return }
        guard !isOnBike else { return }   // ← если уже на байке, НИЧЕГО не создаём

        let tex = SKTexture(imageNamed: "bike_idle")
        let bikeNode = SKSpriteNode(texture: tex)
        bikeNode.position = CGPoint(x: 500, y: 250)
        bikeNode.zPosition = 40
        bikeNode.setScale(0.15)

        addChild(bikeNode)
        parkedBike = bikeNode
    }
    



    // MARK: - Interaction logic
    func checkBikeInteraction() {
        guard !isOnBike else { return }       // ← защитный ранний выход
        guard let parkedBike else { return }

        let dist = abs(player.position.x - parkedBike.position.x)

        if dist < 120 {
            showHint(text: "Press  E")
            if keyboard.ePressed {
                keyboard.ePressed = false
                hideHint()
                enterBike()
            }
        } else {
            hideHint()
        }
    }

    func enterBike() {

        guard let parked = parkedBike else { return }
        let bikePosition = parked.position

        parked.removeFromParent()
        parkedBike = nil

        player.isHidden = true
        isOnBike = true          // ← теперь считаем, что игрок уже на байке

        let ridingBike = Bike()
        ridingBike.position = bikePosition
        ridingBike.zPosition = 60
        addChild(ridingBike)
        self.bike = ridingBike

        ridingBike.startDriveAnimation()
        ridingBike.driveOffScreen {
            print("🏁 Байк уехал")
            // здесь потом будем грузить новую сцену, если надо
        }
    }


    // MARK: - Interaction hint
    func showHint(text: String) {
        if hint == nil {
            hint = InteractionHint()
            hint!.position = CGPoint(x: frame.midX, y: 300)
            addChild(hint!)
        }
        hint?.setText(text)
        hint?.isHidden = false
    }

    func hideHint() {
        hint?.isHidden = true
    }


    // MARK: - Keyboard
    override func keyDown(with event: NSEvent) {
        keyboard.keyDown(event.keyCode, flags: event.modifierFlags)
    }

    override func keyUp(with event: NSEvent) {
        keyboard.keyUp(event.keyCode)
        player.stopWalkAnimation()
        player.currentSpeed = player.walkSpeed
    }


    // MARK: - Update
    override func update(_ currentTime: TimeInterval) {

        if bgManager.currentIndex == bikeSpawnIndex && !isOnBike {
            spawnParkedBike()
            checkBikeInteraction()
        }

        if !player.isHidden {
            handlePlayerMovement()
        }
    }


    // MARK: - Player Movements
    func handlePlayerMovement() {

        if keyboard.left || keyboard.right || keyboard.up || keyboard.down {

            if keyboard.shift {
                player.currentSpeed = player.runSpeed
                player.startRunAnimation()
            } else {
                player.currentSpeed = player.walkSpeed
                player.startWalkAnimation()
            }
        }

        // ←
        if keyboard.left {
            player.moveLeft()
            if player.position.x < leftSwitchX {
                bgManager.previousBackground()
                player.position.x = 1500
                hideHint()
            }
        }

        // →
        if keyboard.right {
            player.moveRight()

            if player.position.x > rightSwitchX {
                bgManager.nextBackground()
                player.position.x = 80
                hideHint()
            }
        }

        // ↓
        if keyboard.down {
            player.moveDown()
            if player.position.y < minY { player.position.y = minY }
        }

        // ↑
        if keyboard.up {
            player.moveUp()
            if player.position.y > maxY { player.position.y = maxY }
        }
    }
}
