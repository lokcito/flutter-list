import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Stateful Clicker Counter",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> lista = [];
  @override
  void initState() {
    super.initState();
    RequestService.getProducts().then((products) {
      setState(() {
        lista = products!.list;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listado"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: lista.length,
            itemBuilder: (BuildContext context, int index) =>
                      traerElemento(index),
          ),
        ),
        const SizedBox(height: 18),
      ],
    ),
      ),
    );
  }

  Widget traerElemento(int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Image.network(
              lista[index].image,
              width: 128,
            ),
            const SizedBox(width: 20),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lista[index].name),
                Text("Precio: " + lista[index].price),
                const SizedBox(height: 15),
                ElevatedButton(onPressed: () {}, child: const Text("Comprar"))
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class RequestService {
  List<Product> list;
  RequestService({required this.list});
  static Future<RequestService?> getProducts() async {
    var response =
        await http.get(Uri.parse("https://fipo.equisd.com/api/products.json"));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      List<Product> products = data["objects"]
          .map<Product>((dynamic value) => Product.fromJson(value))
          .toList();
      return RequestService(list: products);
    }
  }
}

class Product {
  int id;
  String name;
  String image;
  String price;
  Product(
      {required this.id,
      required this.name,
      required this.image,
      required this.price});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      name: json["name"],
      image: json["avatar"],
      price: json["price"]);
}
