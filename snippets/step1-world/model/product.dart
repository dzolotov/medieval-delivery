class Product {
  String name;
  int weight;
  String target;
  int? deliveryCost;

  Product({
    required this.name,
    required this.weight,
    required this.target,
  });

  @override
  String toString() =>
      'Product $name ($weight pounds), target: $target, cost: $deliveryCost';

  Map<String, dynamic> toJson() => {
        'name': name,
        'weight': weight,
        'target': target,
      };

  Product.fromJson(Map<String, dynamic> data)
      : this(
          name: data['name'],
          weight: data['weight'],
          target: data['target'],
        );
}

const medievalProducts = [
  "bread",
  "cheese",
  "butter",
  "ale",
  "wine",
  "salt",
  "honey",
  "porridge",
  "stew",
  "pottage",
  "sauerkraut",
  "mead",
  "venison",
  "pork",
  "beef",
  "fish",
  "oats",
  "barley",
  "rye",
  "apples",
  "pears",
  "plums",
  "walnuts",
  "herbs",
  "garlic",
  "onions",
  "leeks",
  "cabbage",
  "spinach",
  "carrots",
  "turnips",
  "beans",
  "lentils",
  "mushrooms",
  "spices",
  "mustard",
  "vinegar",
  "figs"
];
