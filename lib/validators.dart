class Validators {
  static String? name({required String name}) {
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? email({required String email}) {
    RegExp emailRegExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    if (email.isEmpty) {
      return 'L\'email ne peut être vide.';
    } else if (!emailRegExp.hasMatch(email)) {
      return 'Entrez un email correcte';
    }

    return null;
  }

  static String? password({required String password}) {
    if (password.isEmpty) {
      return 'Le mot de passe ne peut être vide.';
    } else if (password.length < 6) {
      return 'Entrez un mot de passe d\'au moins 6 caractères';
    }
    return null;
  }
}