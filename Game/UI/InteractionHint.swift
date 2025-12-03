import SpriteKit

class InteractionHint: SKNode {

    private let label: SKLabelNode

    override init() {
        label = SKLabelNode(fontNamed: "Helvetica-Bold")
        super.init()

        label.fontSize = 42
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center

        addChild(label)

        // чуть затемнить фон (по желанию)
        let bg = SKSpriteNode(color: .black.withAlphaComponent(0.4),
                              size: CGSize(width: 480, height: 90))
        bg.zPosition = -1
        bg.position = .zero
        addChild(bg)
    }

    func setText(_ text: String) {
        label.text = text
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
