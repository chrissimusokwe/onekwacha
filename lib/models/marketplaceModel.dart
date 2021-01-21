import 'package:http/http.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class ProductsModel {
  final String productCode;
  final String productDescription;
  final String productCategory;
  final String price;
  ProductsModel({
    this.productCode,
    this.productDescription,
    this.productCategory,
    this.price,
  });

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      productCode: json['product_code'],
      productDescription: json['product_description'],
      price: json['price'],
      productCategory: json['product_category'],
    );
  }

  //A function that converts a response body into a List<productModel>.
  List<ProductsModel> parseLiteSpeed(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed
        .map<ProductsModel>((json) => ProductsModel.fromJson(json))
        .toList();
  }

  //passing the product web service url and bearer token, get the products list
  Future<List<ProductsModel>> fetchLiteSpeed(
      String _productUrl, String _token) async {
    final response = await get(
      _productUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_token}',
      },
    );
    print('Here is the response from Liquid: ' + response.body);
    final responseJson = parseLiteSpeed(response.body);

    return responseJson;
  }
}
