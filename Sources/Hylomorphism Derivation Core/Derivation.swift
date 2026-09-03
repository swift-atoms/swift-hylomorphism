import Base_Functor_Derivation_Core
public import SwiftSyntax
import SwiftSyntaxBuilder

public enum Derivation {
    public static func expansion(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        Base_Functor_Derivation_Core.Derivation.base(of: declaration)
            + operation(of: declaration)
    }

    public static func operation(of declaration: EnumDeclSyntax) -> [DeclSyntax] {
        let access = declaration.modifiers.contains { $0.name.tokenKind == .keyword(.public) }
            ? "public " : ""
        return ["""
            \(raw: access)static func hylomorphism<Seed, Result>(
                _ seed: Seed,
                coalgebra: (Seed) -> Base<Seed>,
                algebra: (Base<Result>) -> Result
            ) -> Result {
                algebra(coalgebra(seed).map {
                    hylomorphism($0, coalgebra: coalgebra, algebra: algebra)
                })
            }
            """]
    }
}
