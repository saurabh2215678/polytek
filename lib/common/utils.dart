class DataUtils {
  static List<String> staticList = ['Item 1', 'Item 2', 'Item 3'];

  static String BaseUri = 'https://polyteksynergy.tekzini.com/api/v1';

  static Map<String, String> UserData = {
    'username': 'polytek',
    'password': 'synergy@2024'
  };
}

class Exhibition {
  final int id;
  final String title;

  Exhibition({required this.id, required this.title});
}

class Customer {
  final int id;
  final String title;

  Customer({required this.id, required this.title});
}

class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});
}

class ProductSegment {
  final int id;
  final String title;

  ProductSegment({required this.id, required this.title});
}