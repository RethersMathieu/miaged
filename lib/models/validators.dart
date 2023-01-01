class Validators {
  static String? name({required String name}) {
    if (name.isEmpty) {
      return 'Name can\'t be empty';
    }

    return null;
  }

  static String? email(String? email) {
    var res = pattern(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")(email);
    if (email == null || email.isEmpty) {
      return 'L\'email ne peut être vide.';
    } else if (res != null) {
      return 'Entrez un email correcte';
    }

    return null;
  }

  static String? password(String? password) {
    if (password == null || password.isEmpty) {
      return 'Le mot de passe ne peut être vide.';
    } else if (password.length < 6) {
      return 'Entrez un mot de passe d\'au moins 6 caractères';
    }
    return null;
  }

  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le champ est obligatoire.';
    }
    return null;
  }

  static String? Function(String? value) min(int min) {
    return (String? value) {
      if (value == null || value.length < min) {
        return 'Longueur de $min minimum.';
      }
      return null;
    };
  }

  static String? Function(String? value) max(int max) {
    return (String? value) {
      if (value == null || value.length > max) {
        return 'Longueur de $max maximum.';
      }
      return null;
    };
  }

  static String? Function(String? value) pattern(String pattern) {
    return regex(RegExp(pattern));
  }

  static String? Function(String? value) regex(RegExp regex) {
    return (String? value) {
      return !regex.hasMatch(value ?? "") ? "\"$value\" ne corresponds pas au paterne." : null;
    };
  }

  static String? httpLink(String? value) {
    var res = pattern(r"https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)")(value);
    return res != null ? "Ce n'est pas lien http/https." : null;
  }
}