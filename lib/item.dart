class Item {
  int _id;
  String _name;
  int _price;
  String _stok;
  String _kode;

  int get id => _id;

  String get name => _name;
  set name(String value) => this._name = value;

  get price => _price;
  set price(value) => _price = value;

  String get stok => _stok;
  set stok(String value) => this._stok = value;

  String get kode => _kode;
  set kode(String value) => this._kode = value;

// konstruktor versi 1
  Item(this._name, this._price, this._stok, this._kode);
// konstruktor versi 2: konversi dari Map ke Item
  Item.fromMap(Map<String, dynamic> map) {
    _id = map['id'];
    _name = map['name'];
    _price = map['price'];
    _stok = map['stok'];
    _kode = map['kode'];
  }
  // konversi dari Item ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = name;
    map['price'] = price;
    map['stok'] = stok;
    map['kode'] = kode;
    return map;
  }
}
