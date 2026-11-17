def calculer_total(prix: float, quantite: int) -> float:
    """Calcule le montant total."""
    return prix * quantite


def main() -> None:
    """Point d'entrée du programme."""
    print(calculer_total(1000, 5))


if __name__ == "__main__":
    main()


def verifier_prix(prix: float) -> bool:
    """
    Vérifie qu'un prix est valide.

    Un prix doit être positif ou égal à zéro.
    """
    return prix >= 0
