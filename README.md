# swift-hylomorphism

Use this package to compute a result from a seed by unfolding the seed into a recursive shape and folding that shape back down, without ever building the recursive value in between. For example, you might split a `Range<Int>` into a tree of halves and sum the leaves. Start from the `@Hylomorphism` macro. Attach it to an `indirect enum` together with `@FunctorBase` from swift-functor, which supplies the nested `Base` and its `map`. If you only need to unfold, use swift-anamorphism. If you only need to fold, use swift-catamorphism. If one enum needs several recursion schemes, use swift-recursion.

## Laws

- `hylomorphism(seed, coalgebra:, algebra:)` equals `algebra(coalgebra(seed).map { hylomorphism($0, coalgebra:, algebra:) })`. It produces the same result as unfolding with the coalgebra and then folding with the algebra, but it never constructs a value of the enum itself. Each layer is consumed as soon as it is produced.
- Recursion stops only when the coalgebra returns a layer with no recursive positions, such as `.leaf` or `.zero`. A coalgebra that never reaches one does not terminate.
- The expansion recurses once per layer on the call stack, with no tail-call or heap-allocated trampoline, so recursion depth equals the depth of the unfolded shape.
- Nothing is cached or shared: a seed that the coalgebra produces twice is unfolded and folded twice.
- The generated function is `public` only when the enum is `public`. Otherwise it has default access.
