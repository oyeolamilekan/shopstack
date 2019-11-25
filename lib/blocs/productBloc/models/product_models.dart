class Product {
  int count;
  String next;
  String previous;
  List<Results> results;

  Product({this.count, this.next, this.previous, this.results});

  Product.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = new List<Results>();
      json['results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  String id;
  String name;
  String image;
  String sourceUrl;
  Genre genre;
  String shopRel;
  String price;
  String description;

  Results(
      {this.id,
      this.name,
      this.image,
      this.sourceUrl,
      this.genre,
      this.shopRel,
      this.price,
      this.description});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    sourceUrl = json['source_url'];
    genre = json['genre'] != null ? new Genre.fromJson(json['genre']) : null;
    shopRel = json['shop_rel'];
    price = json['price'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['source_url'] = this.sourceUrl;
    if (this.genre != null) {
      data['genre'] = this.genre.toJson();
    }
    data['shop_rel'] = this.shopRel;
    data['price'] = this.price;
    data['description'] = this.description;
    return data;
  }
}

class Genre {
  String name;
  String slug;
  String publicSlug;

  Genre({this.name, this.slug, this.publicSlug});

  Genre.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    publicSlug = json['public_slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['public_slug'] = this.publicSlug;
    return data;
  }
}