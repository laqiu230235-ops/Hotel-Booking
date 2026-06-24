class Hotel {
  final int id;
  final String name;
  final String location;
  final double rating;
  final int price;
  final String imagePath;
  final String description;
  final List<String> features;

  Hotel({
    required this.id,
    required this.name,
    required this.location,
    required this.rating,
    required this.price,
    required this.imagePath,
    required this.description,
    required this.features,
  });

  // Converts the Hotel object into a Map for storage
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'location': location,
    'rating': rating,
    'price': price,
    'imagePath': imagePath,
    'description': description,
    'features': features,
  };

  // Creates a Hotel object from a Map
  factory Hotel.fromJson(Map<String, dynamic> json) => Hotel(
    id: json['id'],
    name: json['name'],
    location: json['location'],
    // Use 'num' to safely handle both int and double from JSON
    rating: (json['rating'] as num).toDouble(),
    price: json['price'],
    imagePath: json['imagePath'],
    description: json['description'],
    features: List<String>.from(json['features']),
  );

  // Static list of hotels
  static List<Hotel> getHotels() {
    return [
      Hotel(
        id: 1,
        name: 'Titanic Hotel & Spa',
        location: 'Goizha, Malik Mahmoud Circle, Sulaymaniyah',
        rating: 4.3,
        price: 94,
        imagePath: 'assets/images/taitanic.jpg',
        description: 'Luxury spa hotel in the heart of Sulaymaniyah',
        features: ['Pool', 'Spa', 'Restaurant'],
      ),
      Hotel(
        id: 2,
        name: 'Ramada by Wyndham sulaymaniyah',
        location: 'Salim Street, Sulaymaniyah, Sulaymaniyah Governorate, 46010',
        rating: 4.3,
        price: 95,
        imagePath: 'assets/images/ramada.jpg',
        description: 'city view with spa',
        features: ['Spa', 'Restaurant'],
      ),
      Hotel(
        id: 3,
        name: 'Hotel Rotana',
        location: 'Salim Street, Sulaymaniyah, Sulaymaniyah Governorate, 46010',
        rating: 4.7,
        price: 126,
        imagePath: 'assets/images/rotana.jpg',
        description: 'Luxury downtown hotel',
        features: ['Pool', 'Gym', 'Restaurant', 'Bar'],
      ),
      Hotel(
        id: 4,
        name: 'grand Millennium Hotel',
        location: 'Sulaymaniyah, Sulaymaniyah Governorate, 46001',
        rating: 4.5,
        price: 125,
        imagePath: 'assets/images/grand.jpg',
        description: 'Luxury spa hotel in the heart of Sulaymaniyah',
        features: ['Pool', 'Spa', 'Restaurant', 'Bar', 'sulaymaniyah view'],
      ),
      Hotel(
        id: 5,
        name: 'Abu Sana Hotel',
        location: 'Sulaymaniyah, Sulaymaniyah Governorate, 46001',
        rating: 4.0,
        price: 92,
        imagePath: 'assets/images/sana.jpg',
        description: 'Sulaymaniyah, Sulaymaniyah Governorate, 46001',
        features: ['Pool', 'Spa', 'Restaurant', 'Bar'],
      ),
      Hotel(
        id: 6,
        name: 'Copthorne Hotel Baranan',
        location: 'Sarchinar Main Street, As Sulaymaniyah',
        rating: 4.0,
        price: 72,
        imagePath: 'assets/images/Copthorne.jpg',
        description: 'Sarchinar Main Street, As Sulaymaniyah',
        features: ['Spa', 'Restaurant', 'parking'],
      ),
      Hotel(
        id: 7,
        name: 'Millennium Kurdistan Hotel',
        location:
            'Next to Faruk Medical City, Malik mahmud Ring Road, As Sulaymaniyah',
        rating: 5.0,
        price: 84,
        imagePath: 'assets/images/Millennium.jpg',
        description:
            'Next to Faruk Medical City, Malik mahmud Ring Road, As Sulaymaniyah',
        features: ['Spa', 'Restaurant', 'free wifi'],
      ),
      Hotel(
        id: 8,
        name: 'Dawa Hotel',
        location:
            'H9RG+32C, Sareshnar Street, Sulaymaniyah, Sulaymaniyah Governorate',
        rating: 3.9,
        price: 51,
        imagePath: 'assets/images/Dawa.jpg',
        description:
            'H9RG+32C, Sareshnar Street, Sulaymaniyah, Sulaymaniyah Governorate',
        features: ['Spa', 'Restaurant', 'free wifi', 'bar'],
      ),
      Hotel(
        id: 9,
        name: 'Mihrako Hotel',
        location:
            'HC5F+HFV, Salim Street, Sulaymaniyah, Sulaymaniyah Governorate, 46001',
        rating: 4.6,
        price: 120,
        imagePath: 'assets/images/Mihrako.jpg',
        description:
            'HC5F+HFV, Salim Street, Sulaymaniyah, Sulaymaniyah Governorate, 46001',
        features: ['Spa', 'Restaurant', 'free wifi', 'city center'],
      ),
      Hotel(
        id: 10,
        name: 'View lounge Hotel',
        location: 'As Sulaymaniyah Qazzaz Building, As Sulaymaniyah',
        rating: 4.0,
        price: 85,
        imagePath: 'assets/images/ViewLounge.jpg',
        description: 'As Sulaymaniyah Qazzaz Building, As Sulaymaniyah',
        features: ['Restaurant', 'free wifi', ' bar'],
      ),
      Hotel(
        id: 11,
        name: 'Rawaz Hotel & Motel',
        location: 'Malik Mahmud Ring Road, 46001 As Sulaymaniyah',
        rating: 4.0,
        price: 46,
        imagePath: 'assets/images/Rawaz.jpg',
        description: 'Malik Mahmud Ring Road, 46001 As Sulaymaniyah',
        features: ['Restaurant', 'free wifi', 'parking'],
      ),
    ];
  }
}
