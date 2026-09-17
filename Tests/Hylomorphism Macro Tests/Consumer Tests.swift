import Hylomorphism_Macro
import Testing

@Hylomorphism
private indirect enum Natural {
    case zero
    case successor(Natural)
}

@Test
func `hylomorphism fuses unfold and fold`() {
    let count = Natural.hylomorphism(
        3,
        coalgebra: { seed -> Natural.Base<Int> in
            seed == 0 ? .zero : .successor(seed - 1)
        },
        algebra: { (layer: Natural.Base<Int>) -> Int in
            switch layer {
            case .zero: 0
            case let .successor(child): child + 1
            }
        }
    )
    #expect(count == 3)
}
