import Functor_Base_Macro
import Hylomorphism_Macro
import Testing

@FunctorBase
@Hylomorphism
private indirect enum Tree {
    case leaf(Int)
    case node(Tree, Tree)
}

@Suite
struct `Hylomorphism boundaries` {
    private static func sum(_ range: Range<Int>) -> Int {
        Tree.hylomorphism(
            range,
            coalgebra: { range -> Tree.Base<Range<Int>> in
                range.count <= 1
                    ? .leaf(range.first ?? 0)
                    : .node(range.lowerBound..<range.lowerBound + range.count / 2, range.lowerBound + range.count / 2..<range.upperBound)
            },
            algebra: { (layer: Tree.Base<Int>) -> Int in
                switch layer {
                case let .leaf(value): value
                case let .node(left, right): left + right
                }
            }
        )
    }

    @Test
    func `an empty and a single seed stop at the base case`() {
        #expect(Self.sum(0..<0) == 0)
        #expect(Self.sum(7..<8) == 7)
    }

    @Test
    func `a split seed fuses both halves`() {
        #expect(Self.sum(1..<101) == 5_050)
    }
}
