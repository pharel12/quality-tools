from app import calculer_total, main


def test_calcul_total():
    assert calculer_total(1000, 5) == 5000


def test_quantite_zero():
    assert calculer_total(1000, 0) == 0


def test_prix_zero():
    assert calculer_total(0, 5) == 0


def test_calcul_total_avec_decimales():
    assert calculer_total(1500.5, 2) == 3001.0


def test_main_affiche_total(capsys):
    main()

    resultat = capsys.readouterr()

    assert resultat.out == "5000\n"


# capsys est une fonctionnalité de Pytest qui permet de récupérer ce qu'un programme affiche dans le terminal
