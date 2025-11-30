import SpriteKit

class MenuScene: SKScene {

    private var bg: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    private var pressLabel: SKLabelNode!
    private var enterReady = false

    override func didMove(to view: SKView) {
        setupBackground()
        setupUI()
        fadeIn()
        view.window?.makeFirstResponder(self)
    }

    // -----------------------
    // BACKGROUND (обложка)
    // -----------------------
    private func setupBackground() {
        bg = SKSpriteNode(imageNamed: "menu_cover")
        bg.position = CGPoint(x: size.width/2, y: size.height/2)
        bg.zPosition = -10
        bg.size = size
        bg.alpha = 0.0
        bg.setScale(1.05)
        addChild(bg)

        // лёгкий параллакс
        let move = SKAction.sequence([
            SKAction.moveBy(x: -10, y: -5, duration: 4),
            SKAction.moveBy(x: 10, y: 5, duration: 4)
        ])
        bg.run(SKAction.repeatForever(move))
    }

    // -----------------------
    // TEXT
    // -----------------------
    private func setupUI() {

        // PRESS ENTER
        pressLabel = SKLabelNode(fontNamed: "Avenir-Heavy")
        pressLabel.text = "PRESS ENTER"
        pressLabel.fontSize = 48
        pressLabel.position = CGPoint(x: size.width/2, y: size.height * 0.18)
        pressLabel.alpha = 0
        pressLabel.zPosition = 10
        addChild(pressLabel)

        // мигающий эффект
        let fadeSeq = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.2, duration: 0.8),
            SKAction.fadeAlpha(to: 1.0, duration: 0.8)
        ])
        pressLabel.run(SKAction.repeatForever(fadeSeq))
    }

    // -----------------------
    // FADE-IN MENU
    // -----------------------
    private func fadeIn() {
        let fade = SKAction.fadeIn(withDuration: 1.6)
        bg.run(fade)

        let wait = SKAction.wait(forDuration: 1.2)
        let showText = SKAction.fadeIn(withDuration: 1.0)
        pressLabel.run(SKAction.sequence([wait, showText]))

        // активности меню включаются через 2 секунды
        run(.wait(forDuration: 2.0)) { self.enterReady = true }
    }

    // -----------------------
    // ENTER PRESSED
    // -----------------------
    private func startGame() {

        if !enterReady { return }
        enterReady = false

        // fade-out
        let fade = SKAction.fadeOut(withDuration: 1.0)
        bg.run(fade)
        pressLabel.run(fade)

        run(.wait(forDuration: 1.1)) {
            let game = GameScene(size: self.size)
            game.scaleMode = .aspectFit
            self.view?.presentScene(game, transition: .fade(withDuration: 1.0))
        }
    }

    // -----------------------
    // KEY INPUT
    // -----------------------
    override func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 36, 76:   // Enter / Numpad Enter
            startGame()
        default:
            break
        }
    }
}
