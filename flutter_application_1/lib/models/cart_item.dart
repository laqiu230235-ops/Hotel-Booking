import 'hotel.dart';

class CartItem {
  final Hotel hotel;
  int nights;

  CartItem({required this.hotel, this.nights = 1});

  int get subtotal => hotel.price * nights;

  // Converts the CartItem into a Map for saving to SharedPreferences/JSON
  Map<String, dynamic> toJson() => {
    'hotel': hotel.toJson(), // Requires Hotel model to have a toJson()
    'nights': nights,
  };

  // Creates a CartItem from a Map (needed for loading saved data)
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    hotel: Hotel.fromJson(
      json['hotel'],
    ), // Requires Hotel model to have fromJson()
    nights: json['nights'],
  );
}
