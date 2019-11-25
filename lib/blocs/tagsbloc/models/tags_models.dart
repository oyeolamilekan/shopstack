class ShopTags {
  String name;
  String slug;
  String publicSlug;
  int productCount;

  ShopTags({this.name, this.slug, this.publicSlug, this.productCount});

  ShopTags.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    publicSlug = json['public_slug'];
    productCount = json['product_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['public_slug'] = this.publicSlug;
    data['product_count'] = this.productCount;
    return data;
  }
}