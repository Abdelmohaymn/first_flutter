class ShopHomeModel {

  ShopHomeModel.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? status;
  dynamic message;
  Data? data;

}

class Data {

  Data.fromJson(dynamic json) {
    if (json['banners'] != null) {
      banners = [];
      json['banners'].forEach((v) {
        banners?.add(Banners.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products?.add(Products.fromJson(v));
      });
    }
    ad = json['ad'];
  }
  List<Banners>? banners;
  List<Products>? products;
  String? ad;

}

class Products {

  Products.fromJson(dynamic json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    images = json['images'] != null ? json['images'].cast<String>() : [];
    inFavorites = json['in_favorites'];
    inCart = json['in_cart'];
  }
  num? id;
  num? price;
  num? oldPrice;
  num? discount;
  String? image;
  String? name;
  String? description;
  List<String>? images;
  bool? inFavorites;
  bool? inCart;
}

class Banners {

  Banners.fromJson(dynamic json) {
    id = json['id'];
    image = json['image'];
    category = json['category'];
    product = json['product'];
  }
  num? id;
  String? image;
  dynamic category;
  dynamic product;


}