// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products with TableInfo<$ProductsTable, Product> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    price,
    cost,
    stock,
    barcode,
    isActive,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<Product> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Product map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Product(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class Product extends DataClass implements Insertable<Product> {
  final String id;
  final String name;
  final String category;
  final int price;
  final int cost;
  final int stock;
  final String? barcode;
  final int isActive;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.cost,
    required this.stock,
    this.barcode,
    required this.isActive,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['price'] = Variable<int>(price);
    map['cost'] = Variable<int>(cost);
    map['stock'] = Variable<int>(stock);
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    map['is_active'] = Variable<int>(isActive);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      price: Value(price),
      cost: Value(cost),
      stock: Value(stock),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Product.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Product(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<int>(json['price']),
      cost: serializer.fromJson<int>(json['cost']),
      stock: serializer.fromJson<int>(json['stock']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      isActive: serializer.fromJson<int>(json['isActive']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<int>(price),
      'cost': serializer.toJson<int>(cost),
      'stock': serializer.toJson<int>(stock),
      'barcode': serializer.toJson<String?>(barcode),
      'isActive': serializer.toJson<int>(isActive),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? category,
    int? price,
    int? cost,
    int? stock,
    Value<String?> barcode = const Value.absent(),
    int? isActive,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Product(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    price: price ?? this.price,
    cost: cost ?? this.cost,
    stock: stock ?? this.stock,
    barcode: barcode.present ? barcode.value : this.barcode,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Product copyWithCompanion(ProductsCompanion data) {
    return Product(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      price: data.price.present ? data.price.value : this.price,
      cost: data.cost.present ? data.cost.value : this.cost,
      stock: data.stock.present ? data.stock.value : this.stock,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Product(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('cost: $cost, ')
          ..write('stock: $stock, ')
          ..write('barcode: $barcode, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    price,
    cost,
    stock,
    barcode,
    isActive,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Product &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.price == this.price &&
          other.cost == this.cost &&
          other.stock == this.stock &&
          other.barcode == this.barcode &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class ProductsCompanion extends UpdateCompanion<Product> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> price;
  final Value<int> cost;
  final Value<int> stock;
  final Value<String?> barcode;
  final Value<int> isActive;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.cost = const Value.absent(),
    this.stock = const Value.absent(),
    this.barcode = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required int price,
    required int cost,
    this.stock = const Value.absent(),
    this.barcode = const Value.absent(),
    this.isActive = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       category = Value(category),
       price = Value(price),
       cost = Value(cost),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Product> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? price,
    Expression<int>? cost,
    Expression<int>? stock,
    Expression<String>? barcode,
    Expression<int>? isActive,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (cost != null) 'cost': cost,
      if (stock != null) 'stock': stock,
      if (barcode != null) 'barcode': barcode,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? price,
    Value<int>? cost,
    Value<int>? stock,
    Value<String?>? barcode,
    Value<int>? isActive,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      stock: stock ?? this.stock,
      barcode: barcode ?? this.barcode,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('cost: $cost, ')
          ..write('stock: $stock, ')
          ..write('barcode: $barcode, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CustomersTable extends Customers
    with TableInfo<$CustomersTable, Customer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pointsMeta = const VerificationMeta('points');
  @override
  late final GeneratedColumn<int> points = GeneratedColumn<int>(
    'points',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    phone,
    points,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Customer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('points')) {
      context.handle(
        _pointsMeta,
        points.isAcceptableOrUnknown(data['points']!, _pointsMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Customer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Customer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      points: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}points'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $CustomersTable createAlias(String alias) {
    return $CustomersTable(attachedDatabase, alias);
  }
}

class Customer extends DataClass implements Insertable<Customer> {
  final String id;
  final String name;
  final String? phone;
  final int points;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Customer({
    required this.id,
    required this.name,
    this.phone,
    required this.points,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    map['points'] = Variable<int>(points);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  CustomersCompanion toCompanion(bool nullToAbsent) {
    return CustomersCompanion(
      id: Value(id),
      name: Value(name),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      points: Value(points),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Customer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Customer(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      phone: serializer.fromJson<String?>(json['phone']),
      points: serializer.fromJson<int>(json['points']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'phone': serializer.toJson<String?>(phone),
      'points': serializer.toJson<int>(points),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Customer copyWith({
    String? id,
    String? name,
    Value<String?> phone = const Value.absent(),
    int? points,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Customer(
    id: id ?? this.id,
    name: name ?? this.name,
    phone: phone.present ? phone.value : this.phone,
    points: points ?? this.points,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Customer copyWithCompanion(CustomersCompanion data) {
    return Customer(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      phone: data.phone.present ? data.phone.value : this.phone,
      points: data.points.present ? data.points.value : this.points,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Customer(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('points: $points, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, phone, points, updatedAt, deviceId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Customer &&
          other.id == this.id &&
          other.name == this.name &&
          other.phone == this.phone &&
          other.points == this.points &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class CustomersCompanion extends UpdateCompanion<Customer> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> phone;
  final Value<int> points;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const CustomersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.phone = const Value.absent(),
    this.points = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomersCompanion.insert({
    required String id,
    required String name,
    this.phone = const Value.absent(),
    this.points = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Customer> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? phone,
    Expression<int>? points,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      if (points != null) 'points': points,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomersCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? phone,
    Value<int>? points,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return CustomersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      points: points ?? this.points,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (points.present) {
      map['points'] = Variable<int>(points.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('phone: $phone, ')
          ..write('points: $points, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PromosTable extends Promos with TableInfo<$PromosTable, Promo> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PromosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<int> value = GeneratedColumn<int>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    type,
    value,
    isActive,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'promos';
  @override
  VerificationContext validateIntegrity(
    Insertable<Promo> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {code},
  ];
  @override
  Promo map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Promo(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}value'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $PromosTable createAlias(String alias) {
    return $PromosTable(attachedDatabase, alias);
  }
}

class Promo extends DataClass implements Insertable<Promo> {
  final String id;
  final String code;
  final String type;
  final int value;
  final int isActive;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Promo({
    required this.id,
    required this.code,
    required this.type,
    required this.value,
    required this.isActive,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<int>(value);
    map['is_active'] = Variable<int>(isActive);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  PromosCompanion toCompanion(bool nullToAbsent) {
    return PromosCompanion(
      id: Value(id),
      code: Value(code),
      type: Value(type),
      value: Value(value),
      isActive: Value(isActive),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Promo.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Promo(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<int>(json['value']),
      isActive: serializer.fromJson<int>(json['isActive']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<int>(value),
      'isActive': serializer.toJson<int>(isActive),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Promo copyWith({
    String? id,
    String? code,
    String? type,
    int? value,
    int? isActive,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Promo(
    id: id ?? this.id,
    code: code ?? this.code,
    type: type ?? this.type,
    value: value ?? this.value,
    isActive: isActive ?? this.isActive,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Promo copyWithCompanion(PromosCompanion data) {
    return Promo(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Promo(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    code,
    type,
    value,
    isActive,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Promo &&
          other.id == this.id &&
          other.code == this.code &&
          other.type == this.type &&
          other.value == this.value &&
          other.isActive == this.isActive &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class PromosCompanion extends UpdateCompanion<Promo> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> type;
  final Value<int> value;
  final Value<int> isActive;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const PromosCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.isActive = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PromosCompanion.insert({
    required String id,
    required String code,
    required String type,
    required int value,
    this.isActive = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       type = Value(type),
       value = Value(value),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Promo> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? type,
    Expression<int>? value,
    Expression<int>? isActive,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (isActive != null) 'is_active': isActive,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PromosCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? type,
    Value<int>? value,
    Value<int>? isActive,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return PromosCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      type: type ?? this.type,
      value: value ?? this.value,
      isActive: isActive ?? this.isActive,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<int>(value.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PromosCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('isActive: $isActive, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EmployeesTable extends Employees
    with TableInfo<$EmployeesTable, Employee> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmployeesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<int> isActive = GeneratedColumn<int>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _salaryTypeMeta = const VerificationMeta(
    'salaryType',
  );
  @override
  late final GeneratedColumn<String> salaryType = GeneratedColumn<String>(
    'salary_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('bulanan'),
  );
  static const VerificationMeta _baseSalaryMeta = const VerificationMeta(
    'baseSalary',
  );
  @override
  late final GeneratedColumn<int> baseSalary = GeneratedColumn<int>(
    'base_salary',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    role,
    pinHash,
    isActive,
    salaryType,
    baseSalary,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'employees';
  @override
  VerificationContext validateIntegrity(
    Insertable<Employee> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('salary_type')) {
      context.handle(
        _salaryTypeMeta,
        salaryType.isAcceptableOrUnknown(data['salary_type']!, _salaryTypeMeta),
      );
    }
    if (data.containsKey('base_salary')) {
      context.handle(
        _baseSalaryMeta,
        baseSalary.isAcceptableOrUnknown(data['base_salary']!, _baseSalaryMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Employee map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Employee(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_active'],
      )!,
      salaryType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salary_type'],
      )!,
      baseSalary: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_salary'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $EmployeesTable createAlias(String alias) {
    return $EmployeesTable(attachedDatabase, alias);
  }
}

class Employee extends DataClass implements Insertable<Employee> {
  final String id;
  final String name;
  final String role;
  final String pinHash;
  final int isActive;
  final String salaryType;
  final int baseSalary;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.pinHash,
    required this.isActive,
    required this.salaryType,
    required this.baseSalary,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    map['is_active'] = Variable<int>(isActive);
    map['salary_type'] = Variable<String>(salaryType);
    map['base_salary'] = Variable<int>(baseSalary);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  EmployeesCompanion toCompanion(bool nullToAbsent) {
    return EmployeesCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      pinHash: Value(pinHash),
      isActive: Value(isActive),
      salaryType: Value(salaryType),
      baseSalary: Value(baseSalary),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Employee.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Employee(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      isActive: serializer.fromJson<int>(json['isActive']),
      salaryType: serializer.fromJson<String>(json['salaryType']),
      baseSalary: serializer.fromJson<int>(json['baseSalary']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'isActive': serializer.toJson<int>(isActive),
      'salaryType': serializer.toJson<String>(salaryType),
      'baseSalary': serializer.toJson<int>(baseSalary),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Employee copyWith({
    String? id,
    String? name,
    String? role,
    String? pinHash,
    int? isActive,
    String? salaryType,
    int? baseSalary,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Employee(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    pinHash: pinHash ?? this.pinHash,
    isActive: isActive ?? this.isActive,
    salaryType: salaryType ?? this.salaryType,
    baseSalary: baseSalary ?? this.baseSalary,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Employee copyWithCompanion(EmployeesCompanion data) {
    return Employee(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      salaryType: data.salaryType.present
          ? data.salaryType.value
          : this.salaryType,
      baseSalary: data.baseSalary.present
          ? data.baseSalary.value
          : this.baseSalary,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Employee(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('isActive: $isActive, ')
          ..write('salaryType: $salaryType, ')
          ..write('baseSalary: $baseSalary, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    role,
    pinHash,
    isActive,
    salaryType,
    baseSalary,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Employee &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.isActive == this.isActive &&
          other.salaryType == this.salaryType &&
          other.baseSalary == this.baseSalary &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class EmployeesCompanion extends UpdateCompanion<Employee> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<int> isActive;
  final Value<String> salaryType;
  final Value<int> baseSalary;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const EmployeesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.isActive = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.baseSalary = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EmployeesCompanion.insert({
    required String id,
    required String name,
    required String role,
    required String pinHash,
    this.isActive = const Value.absent(),
    this.salaryType = const Value.absent(),
    this.baseSalary = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       role = Value(role),
       pinHash = Value(pinHash),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Employee> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<int>? isActive,
    Expression<String>? salaryType,
    Expression<int>? baseSalary,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (isActive != null) 'is_active': isActive,
      if (salaryType != null) 'salary_type': salaryType,
      if (baseSalary != null) 'base_salary': baseSalary,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EmployeesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? role,
    Value<String>? pinHash,
    Value<int>? isActive,
    Value<String>? salaryType,
    Value<int>? baseSalary,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return EmployeesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      isActive: isActive ?? this.isActive,
      salaryType: salaryType ?? this.salaryType,
      baseSalary: baseSalary ?? this.baseSalary,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<int>(isActive.value);
    }
    if (salaryType.present) {
      map['salary_type'] = Variable<String>(salaryType.value);
    }
    if (baseSalary.present) {
      map['base_salary'] = Variable<int>(baseSalary.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmployeesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('isActive: $isActive, ')
          ..write('salaryType: $salaryType, ')
          ..write('baseSalary: $baseSalary, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, Shift> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<int> openedAt = GeneratedColumn<int>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<int> closedAt = GeneratedColumn<int>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingFloatMeta = const VerificationMeta(
    'openingFloat',
  );
  @override
  late final GeneratedColumn<int> openingFloat = GeneratedColumn<int>(
    'opening_float',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expectedCashMeta = const VerificationMeta(
    'expectedCash',
  );
  @override
  late final GeneratedColumn<int> expectedCash = GeneratedColumn<int>(
    'expected_cash',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _actualCashMeta = const VerificationMeta(
    'actualCash',
  );
  @override
  late final GeneratedColumn<int> actualCash = GeneratedColumn<int>(
    'actual_cash',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _cashDiffMeta = const VerificationMeta(
    'cashDiff',
  );
  @override
  late final GeneratedColumn<int> cashDiff = GeneratedColumn<int>(
    'cash_diff',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    openedAt,
    closedAt,
    status,
    openingFloat,
    expectedCash,
    actualCash,
    cashDiff,
    employeeId,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Shift> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('opening_float')) {
      context.handle(
        _openingFloatMeta,
        openingFloat.isAcceptableOrUnknown(
          data['opening_float']!,
          _openingFloatMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingFloatMeta);
    }
    if (data.containsKey('expected_cash')) {
      context.handle(
        _expectedCashMeta,
        expectedCash.isAcceptableOrUnknown(
          data['expected_cash']!,
          _expectedCashMeta,
        ),
      );
    }
    if (data.containsKey('actual_cash')) {
      context.handle(
        _actualCashMeta,
        actualCash.isAcceptableOrUnknown(data['actual_cash']!, _actualCashMeta),
      );
    }
    if (data.containsKey('cash_diff')) {
      context.handle(
        _cashDiffMeta,
        cashDiff.isAcceptableOrUnknown(data['cash_diff']!, _cashDiffMeta),
      );
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Shift map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Shift(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opened_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}closed_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      openingFloat: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_float'],
      )!,
      expectedCash: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expected_cash'],
      )!,
      actualCash: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}actual_cash'],
      )!,
      cashDiff: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_diff'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class Shift extends DataClass implements Insertable<Shift> {
  final String id;
  final int openedAt;
  final int? closedAt;
  final String status;
  final int openingFloat;
  final int expectedCash;
  final int actualCash;
  final int cashDiff;
  final String? employeeId;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Shift({
    required this.id,
    required this.openedAt,
    this.closedAt,
    required this.status,
    required this.openingFloat,
    required this.expectedCash,
    required this.actualCash,
    required this.cashDiff,
    this.employeeId,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['opened_at'] = Variable<int>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<int>(closedAt);
    }
    map['status'] = Variable<String>(status);
    map['opening_float'] = Variable<int>(openingFloat);
    map['expected_cash'] = Variable<int>(expectedCash);
    map['actual_cash'] = Variable<int>(actualCash);
    map['cash_diff'] = Variable<int>(cashDiff);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<String>(employeeId);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
      status: Value(status),
      openingFloat: Value(openingFloat),
      expectedCash: Value(expectedCash),
      actualCash: Value(actualCash),
      cashDiff: Value(cashDiff),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Shift.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Shift(
      id: serializer.fromJson<String>(json['id']),
      openedAt: serializer.fromJson<int>(json['openedAt']),
      closedAt: serializer.fromJson<int?>(json['closedAt']),
      status: serializer.fromJson<String>(json['status']),
      openingFloat: serializer.fromJson<int>(json['openingFloat']),
      expectedCash: serializer.fromJson<int>(json['expectedCash']),
      actualCash: serializer.fromJson<int>(json['actualCash']),
      cashDiff: serializer.fromJson<int>(json['cashDiff']),
      employeeId: serializer.fromJson<String?>(json['employeeId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'openedAt': serializer.toJson<int>(openedAt),
      'closedAt': serializer.toJson<int?>(closedAt),
      'status': serializer.toJson<String>(status),
      'openingFloat': serializer.toJson<int>(openingFloat),
      'expectedCash': serializer.toJson<int>(expectedCash),
      'actualCash': serializer.toJson<int>(actualCash),
      'cashDiff': serializer.toJson<int>(cashDiff),
      'employeeId': serializer.toJson<String?>(employeeId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Shift copyWith({
    String? id,
    int? openedAt,
    Value<int?> closedAt = const Value.absent(),
    String? status,
    int? openingFloat,
    int? expectedCash,
    int? actualCash,
    int? cashDiff,
    Value<String?> employeeId = const Value.absent(),
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Shift(
    id: id ?? this.id,
    openedAt: openedAt ?? this.openedAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
    status: status ?? this.status,
    openingFloat: openingFloat ?? this.openingFloat,
    expectedCash: expectedCash ?? this.expectedCash,
    actualCash: actualCash ?? this.actualCash,
    cashDiff: cashDiff ?? this.cashDiff,
    employeeId: employeeId.present ? employeeId.value : this.employeeId,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Shift copyWithCompanion(ShiftsCompanion data) {
    return Shift(
      id: data.id.present ? data.id.value : this.id,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
      status: data.status.present ? data.status.value : this.status,
      openingFloat: data.openingFloat.present
          ? data.openingFloat.value
          : this.openingFloat,
      expectedCash: data.expectedCash.present
          ? data.expectedCash.value
          : this.expectedCash,
      actualCash: data.actualCash.present
          ? data.actualCash.value
          : this.actualCash,
      cashDiff: data.cashDiff.present ? data.cashDiff.value : this.cashDiff,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Shift(')
          ..write('id: $id, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('status: $status, ')
          ..write('openingFloat: $openingFloat, ')
          ..write('expectedCash: $expectedCash, ')
          ..write('actualCash: $actualCash, ')
          ..write('cashDiff: $cashDiff, ')
          ..write('employeeId: $employeeId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    openedAt,
    closedAt,
    status,
    openingFloat,
    expectedCash,
    actualCash,
    cashDiff,
    employeeId,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Shift &&
          other.id == this.id &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt &&
          other.status == this.status &&
          other.openingFloat == this.openingFloat &&
          other.expectedCash == this.expectedCash &&
          other.actualCash == this.actualCash &&
          other.cashDiff == this.cashDiff &&
          other.employeeId == this.employeeId &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class ShiftsCompanion extends UpdateCompanion<Shift> {
  final Value<String> id;
  final Value<int> openedAt;
  final Value<int?> closedAt;
  final Value<String> status;
  final Value<int> openingFloat;
  final Value<int> expectedCash;
  final Value<int> actualCash;
  final Value<int> cashDiff;
  final Value<String?> employeeId;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.openingFloat = const Value.absent(),
    this.expectedCash = const Value.absent(),
    this.actualCash = const Value.absent(),
    this.cashDiff = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftsCompanion.insert({
    required String id,
    required int openedAt,
    this.closedAt = const Value.absent(),
    required String status,
    required int openingFloat,
    this.expectedCash = const Value.absent(),
    this.actualCash = const Value.absent(),
    this.cashDiff = const Value.absent(),
    this.employeeId = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       openedAt = Value(openedAt),
       status = Value(status),
       openingFloat = Value(openingFloat),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Shift> custom({
    Expression<String>? id,
    Expression<int>? openedAt,
    Expression<int>? closedAt,
    Expression<String>? status,
    Expression<int>? openingFloat,
    Expression<int>? expectedCash,
    Expression<int>? actualCash,
    Expression<int>? cashDiff,
    Expression<String>? employeeId,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (status != null) 'status': status,
      if (openingFloat != null) 'opening_float': openingFloat,
      if (expectedCash != null) 'expected_cash': expectedCash,
      if (actualCash != null) 'actual_cash': actualCash,
      if (cashDiff != null) 'cash_diff': cashDiff,
      if (employeeId != null) 'employee_id': employeeId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftsCompanion copyWith({
    Value<String>? id,
    Value<int>? openedAt,
    Value<int?>? closedAt,
    Value<String>? status,
    Value<int>? openingFloat,
    Value<int>? expectedCash,
    Value<int>? actualCash,
    Value<int>? cashDiff,
    Value<String?>? employeeId,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return ShiftsCompanion(
      id: id ?? this.id,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      status: status ?? this.status,
      openingFloat: openingFloat ?? this.openingFloat,
      expectedCash: expectedCash ?? this.expectedCash,
      actualCash: actualCash ?? this.actualCash,
      cashDiff: cashDiff ?? this.cashDiff,
      employeeId: employeeId ?? this.employeeId,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<int>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<int>(closedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openingFloat.present) {
      map['opening_float'] = Variable<int>(openingFloat.value);
    }
    if (expectedCash.present) {
      map['expected_cash'] = Variable<int>(expectedCash.value);
    }
    if (actualCash.present) {
      map['actual_cash'] = Variable<int>(actualCash.value);
    }
    if (cashDiff.present) {
      map['cash_diff'] = Variable<int>(cashDiff.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('status: $status, ')
          ..write('openingFloat: $openingFloat, ')
          ..write('expectedCash: $expectedCash, ')
          ..write('actualCash: $actualCash, ')
          ..write('cashDiff: $cashDiff, ')
          ..write('employeeId: $employeeId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShopTablesTable extends ShopTables
    with TableInfo<$ShopTablesTable, ShopTable> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShopTablesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    status,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shop_tables';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShopTable> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShopTable map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShopTable(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $ShopTablesTable createAlias(String alias) {
    return $ShopTablesTable(attachedDatabase, alias);
  }
}

class ShopTable extends DataClass implements Insertable<ShopTable> {
  final String id;
  final String name;
  final String status;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const ShopTable({
    required this.id,
    required this.name,
    required this.status,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  ShopTablesCompanion toCompanion(bool nullToAbsent) {
    return ShopTablesCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory ShopTable.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShopTable(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  ShopTable copyWith({
    String? id,
    String? name,
    String? status,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => ShopTable(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  ShopTable copyWithCompanion(ShopTablesCompanion data) {
    return ShopTable(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShopTable(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, status, updatedAt, deviceId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShopTable &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class ShopTablesCompanion extends UpdateCompanion<ShopTable> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> status;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const ShopTablesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShopTablesCompanion.insert({
    required String id,
    required String name,
    required String status,
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       status = Value(status),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<ShopTable> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShopTablesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? status,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return ShopTablesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShopTablesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableIdMeta = const VerificationMeta(
    'tableId',
  );
  @override
  late final GeneratedColumn<String> tableId = GeneratedColumn<String>(
    'table_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shop_tables (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelMeta = const VerificationMeta(
    'channel',
  );
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
    'channel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tableId,
    status,
    channel,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<Order> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('table_id')) {
      context.handle(
        _tableIdMeta,
        tableId.isAcceptableOrUnknown(data['table_id']!, _tableIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('channel')) {
      context.handle(
        _channelMeta,
        channel.isAcceptableOrUnknown(data['channel']!, _channelMeta),
      );
    } else if (isInserting) {
      context.missing(_channelMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      tableId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_id'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      channel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final String id;
  final String? tableId;
  final String status;
  final String channel;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Order({
    required this.id,
    this.tableId,
    required this.status,
    required this.channel,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || tableId != null) {
      map['table_id'] = Variable<String>(tableId);
    }
    map['status'] = Variable<String>(status);
    map['channel'] = Variable<String>(channel);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      tableId: tableId == null && nullToAbsent
          ? const Value.absent()
          : Value(tableId),
      status: Value(status),
      channel: Value(channel),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Order.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<String>(json['id']),
      tableId: serializer.fromJson<String?>(json['tableId']),
      status: serializer.fromJson<String>(json['status']),
      channel: serializer.fromJson<String>(json['channel']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'tableId': serializer.toJson<String?>(tableId),
      'status': serializer.toJson<String>(status),
      'channel': serializer.toJson<String>(channel),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Order copyWith({
    String? id,
    Value<String?> tableId = const Value.absent(),
    String? status,
    String? channel,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Order(
    id: id ?? this.id,
    tableId: tableId.present ? tableId.value : this.tableId,
    status: status ?? this.status,
    channel: channel ?? this.channel,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      tableId: data.tableId.present ? data.tableId.value : this.tableId,
      status: data.status.present ? data.status.value : this.status,
      channel: data.channel.present ? data.channel.value : this.channel,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('status: $status, ')
          ..write('channel: $channel, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tableId, status, channel, updatedAt, deviceId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.tableId == this.tableId &&
          other.status == this.status &&
          other.channel == this.channel &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> id;
  final Value<String?> tableId;
  final Value<String> status;
  final Value<String> channel;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.tableId = const Value.absent(),
    this.status = const Value.absent(),
    this.channel = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    required String id,
    this.tableId = const Value.absent(),
    required String status,
    required String channel,
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       status = Value(status),
       channel = Value(channel),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Order> custom({
    Expression<String>? id,
    Expression<String>? tableId,
    Expression<String>? status,
    Expression<String>? channel,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tableId != null) 'table_id': tableId,
      if (status != null) 'status': status,
      if (channel != null) 'channel': channel,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith({
    Value<String>? id,
    Value<String?>? tableId,
    Value<String>? status,
    Value<String>? channel,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return OrdersCompanion(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      status: status ?? this.status,
      channel: channel ?? this.channel,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (tableId.present) {
      map['table_id'] = Variable<String>(tableId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('tableId: $tableId, ')
          ..write('status: $status, ')
          ..write('channel: $channel, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _channelMeta = const VerificationMeta(
    'channel',
  );
  @override
  late final GeneratedColumn<String> channel = GeneratedColumn<String>(
    'channel',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subtotalMeta = const VerificationMeta(
    'subtotal',
  );
  @override
  late final GeneratedColumn<int> subtotal = GeneratedColumn<int>(
    'subtotal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<int> tax = GeneratedColumn<int>(
    'tax',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _serviceChargeMeta = const VerificationMeta(
    'serviceCharge',
  );
  @override
  late final GeneratedColumn<int> serviceCharge = GeneratedColumn<int>(
    'service_charge',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ojolFeeMeta = const VerificationMeta(
    'ojolFee',
  );
  @override
  late final GeneratedColumn<int> ojolFee = GeneratedColumn<int>(
    'ojol_fee',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<int> total = GeneratedColumn<int>(
    'total',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidMeta = const VerificationMeta('paid');
  @override
  late final GeneratedColumn<int> paid = GeneratedColumn<int>(
    'paid',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeMeta = const VerificationMeta('change');
  @override
  late final GeneratedColumn<int> change = GeneratedColumn<int>(
    'change',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _voidedMeta = const VerificationMeta('voided');
  @override
  late final GeneratedColumn<int> voided = GeneratedColumn<int>(
    'voided',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta(
    'voidedAt',
  );
  @override
  late final GeneratedColumn<int> voidedAt = GeneratedColumn<int>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shifts (id)',
    ),
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _customerIdMeta = const VerificationMeta(
    'customerId',
  );
  @override
  late final GeneratedColumn<String> customerId = GeneratedColumn<String>(
    'customer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES customers (id)',
    ),
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _splitGroupIdMeta = const VerificationMeta(
    'splitGroupId',
  );
  @override
  late final GeneratedColumn<String> splitGroupId = GeneratedColumn<String>(
    'split_group_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    date,
    channel,
    paymentMethod,
    subtotal,
    discount,
    tax,
    serviceCharge,
    ojolFee,
    total,
    paid,
    change,
    voided,
    voidedAt,
    shiftId,
    employeeId,
    customerId,
    orderId,
    splitGroupId,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('channel')) {
      context.handle(
        _channelMeta,
        channel.isAcceptableOrUnknown(data['channel']!, _channelMeta),
      );
    } else if (isInserting) {
      context.missing(_channelMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(
        _subtotalMeta,
        subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta),
      );
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('tax')) {
      context.handle(
        _taxMeta,
        tax.isAcceptableOrUnknown(data['tax']!, _taxMeta),
      );
    }
    if (data.containsKey('service_charge')) {
      context.handle(
        _serviceChargeMeta,
        serviceCharge.isAcceptableOrUnknown(
          data['service_charge']!,
          _serviceChargeMeta,
        ),
      );
    }
    if (data.containsKey('ojol_fee')) {
      context.handle(
        _ojolFeeMeta,
        ojolFee.isAcceptableOrUnknown(data['ojol_fee']!, _ojolFeeMeta),
      );
    }
    if (data.containsKey('total')) {
      context.handle(
        _totalMeta,
        total.isAcceptableOrUnknown(data['total']!, _totalMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('paid')) {
      context.handle(
        _paidMeta,
        paid.isAcceptableOrUnknown(data['paid']!, _paidMeta),
      );
    } else if (isInserting) {
      context.missing(_paidMeta);
    }
    if (data.containsKey('change')) {
      context.handle(
        _changeMeta,
        change.isAcceptableOrUnknown(data['change']!, _changeMeta),
      );
    }
    if (data.containsKey('voided')) {
      context.handle(
        _voidedMeta,
        voided.isAcceptableOrUnknown(data['voided']!, _voidedMeta),
      );
    }
    if (data.containsKey('voided_at')) {
      context.handle(
        _voidedAtMeta,
        voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta),
      );
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('customer_id')) {
      context.handle(
        _customerIdMeta,
        customerId.isAcceptableOrUnknown(data['customer_id']!, _customerIdMeta),
      );
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    }
    if (data.containsKey('split_group_id')) {
      context.handle(
        _splitGroupIdMeta,
        splitGroupId.isAcceptableOrUnknown(
          data['split_group_id']!,
          _splitGroupIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {code},
  ];
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      channel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}channel'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      subtotal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}subtotal'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      tax: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tax'],
      )!,
      serviceCharge: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}service_charge'],
      )!,
      ojolFee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ojol_fee'],
      )!,
      total: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total'],
      )!,
      paid: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid'],
      )!,
      change: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}change'],
      )!,
      voided: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voided'],
      )!,
      voidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}voided_at'],
      ),
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      ),
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      ),
      customerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_id'],
      ),
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      ),
      splitGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_group_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final String id;
  final String code;
  final int date;
  final String channel;
  final String paymentMethod;
  final int subtotal;
  final int discount;
  final int tax;
  final int serviceCharge;
  final int ojolFee;
  final int total;
  final int paid;
  final int change;
  final int voided;
  final int? voidedAt;
  final String? shiftId;
  final String? employeeId;
  final String? customerId;
  final String? orderId;
  final String? splitGroupId;
  final int updatedAt;
  final String deviceId;
  const Sale({
    required this.id,
    required this.code,
    required this.date,
    required this.channel,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.serviceCharge,
    required this.ojolFee,
    required this.total,
    required this.paid,
    required this.change,
    required this.voided,
    this.voidedAt,
    this.shiftId,
    this.employeeId,
    this.customerId,
    this.orderId,
    this.splitGroupId,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['date'] = Variable<int>(date);
    map['channel'] = Variable<String>(channel);
    map['payment_method'] = Variable<String>(paymentMethod);
    map['subtotal'] = Variable<int>(subtotal);
    map['discount'] = Variable<int>(discount);
    map['tax'] = Variable<int>(tax);
    map['service_charge'] = Variable<int>(serviceCharge);
    map['ojol_fee'] = Variable<int>(ojolFee);
    map['total'] = Variable<int>(total);
    map['paid'] = Variable<int>(paid);
    map['change'] = Variable<int>(change);
    map['voided'] = Variable<int>(voided);
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<int>(voidedAt);
    }
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<String>(shiftId);
    }
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<String>(employeeId);
    }
    if (!nullToAbsent || customerId != null) {
      map['customer_id'] = Variable<String>(customerId);
    }
    if (!nullToAbsent || orderId != null) {
      map['order_id'] = Variable<String>(orderId);
    }
    if (!nullToAbsent || splitGroupId != null) {
      map['split_group_id'] = Variable<String>(splitGroupId);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      code: Value(code),
      date: Value(date),
      channel: Value(channel),
      paymentMethod: Value(paymentMethod),
      subtotal: Value(subtotal),
      discount: Value(discount),
      tax: Value(tax),
      serviceCharge: Value(serviceCharge),
      ojolFee: Value(ojolFee),
      total: Value(total),
      paid: Value(paid),
      change: Value(change),
      voided: Value(voided),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      customerId: customerId == null && nullToAbsent
          ? const Value.absent()
          : Value(customerId),
      orderId: orderId == null && nullToAbsent
          ? const Value.absent()
          : Value(orderId),
      splitGroupId: splitGroupId == null && nullToAbsent
          ? const Value.absent()
          : Value(splitGroupId),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      date: serializer.fromJson<int>(json['date']),
      channel: serializer.fromJson<String>(json['channel']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      subtotal: serializer.fromJson<int>(json['subtotal']),
      discount: serializer.fromJson<int>(json['discount']),
      tax: serializer.fromJson<int>(json['tax']),
      serviceCharge: serializer.fromJson<int>(json['serviceCharge']),
      ojolFee: serializer.fromJson<int>(json['ojolFee']),
      total: serializer.fromJson<int>(json['total']),
      paid: serializer.fromJson<int>(json['paid']),
      change: serializer.fromJson<int>(json['change']),
      voided: serializer.fromJson<int>(json['voided']),
      voidedAt: serializer.fromJson<int?>(json['voidedAt']),
      shiftId: serializer.fromJson<String?>(json['shiftId']),
      employeeId: serializer.fromJson<String?>(json['employeeId']),
      customerId: serializer.fromJson<String?>(json['customerId']),
      orderId: serializer.fromJson<String?>(json['orderId']),
      splitGroupId: serializer.fromJson<String?>(json['splitGroupId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'date': serializer.toJson<int>(date),
      'channel': serializer.toJson<String>(channel),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'subtotal': serializer.toJson<int>(subtotal),
      'discount': serializer.toJson<int>(discount),
      'tax': serializer.toJson<int>(tax),
      'serviceCharge': serializer.toJson<int>(serviceCharge),
      'ojolFee': serializer.toJson<int>(ojolFee),
      'total': serializer.toJson<int>(total),
      'paid': serializer.toJson<int>(paid),
      'change': serializer.toJson<int>(change),
      'voided': serializer.toJson<int>(voided),
      'voidedAt': serializer.toJson<int?>(voidedAt),
      'shiftId': serializer.toJson<String?>(shiftId),
      'employeeId': serializer.toJson<String?>(employeeId),
      'customerId': serializer.toJson<String?>(customerId),
      'orderId': serializer.toJson<String?>(orderId),
      'splitGroupId': serializer.toJson<String?>(splitGroupId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Sale copyWith({
    String? id,
    String? code,
    int? date,
    String? channel,
    String? paymentMethod,
    int? subtotal,
    int? discount,
    int? tax,
    int? serviceCharge,
    int? ojolFee,
    int? total,
    int? paid,
    int? change,
    int? voided,
    Value<int?> voidedAt = const Value.absent(),
    Value<String?> shiftId = const Value.absent(),
    Value<String?> employeeId = const Value.absent(),
    Value<String?> customerId = const Value.absent(),
    Value<String?> orderId = const Value.absent(),
    Value<String?> splitGroupId = const Value.absent(),
    int? updatedAt,
    String? deviceId,
  }) => Sale(
    id: id ?? this.id,
    code: code ?? this.code,
    date: date ?? this.date,
    channel: channel ?? this.channel,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    subtotal: subtotal ?? this.subtotal,
    discount: discount ?? this.discount,
    tax: tax ?? this.tax,
    serviceCharge: serviceCharge ?? this.serviceCharge,
    ojolFee: ojolFee ?? this.ojolFee,
    total: total ?? this.total,
    paid: paid ?? this.paid,
    change: change ?? this.change,
    voided: voided ?? this.voided,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    shiftId: shiftId.present ? shiftId.value : this.shiftId,
    employeeId: employeeId.present ? employeeId.value : this.employeeId,
    customerId: customerId.present ? customerId.value : this.customerId,
    orderId: orderId.present ? orderId.value : this.orderId,
    splitGroupId: splitGroupId.present ? splitGroupId.value : this.splitGroupId,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      date: data.date.present ? data.date.value : this.date,
      channel: data.channel.present ? data.channel.value : this.channel,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      tax: data.tax.present ? data.tax.value : this.tax,
      serviceCharge: data.serviceCharge.present
          ? data.serviceCharge.value
          : this.serviceCharge,
      ojolFee: data.ojolFee.present ? data.ojolFee.value : this.ojolFee,
      total: data.total.present ? data.total.value : this.total,
      paid: data.paid.present ? data.paid.value : this.paid,
      change: data.change.present ? data.change.value : this.change,
      voided: data.voided.present ? data.voided.value : this.voided,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      customerId: data.customerId.present
          ? data.customerId.value
          : this.customerId,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      splitGroupId: data.splitGroupId.present
          ? data.splitGroupId.value
          : this.splitGroupId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('date: $date, ')
          ..write('channel: $channel, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('serviceCharge: $serviceCharge, ')
          ..write('ojolFee: $ojolFee, ')
          ..write('total: $total, ')
          ..write('paid: $paid, ')
          ..write('change: $change, ')
          ..write('voided: $voided, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('shiftId: $shiftId, ')
          ..write('employeeId: $employeeId, ')
          ..write('customerId: $customerId, ')
          ..write('orderId: $orderId, ')
          ..write('splitGroupId: $splitGroupId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    code,
    date,
    channel,
    paymentMethod,
    subtotal,
    discount,
    tax,
    serviceCharge,
    ojolFee,
    total,
    paid,
    change,
    voided,
    voidedAt,
    shiftId,
    employeeId,
    customerId,
    orderId,
    splitGroupId,
    updatedAt,
    deviceId,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.code == this.code &&
          other.date == this.date &&
          other.channel == this.channel &&
          other.paymentMethod == this.paymentMethod &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.tax == this.tax &&
          other.serviceCharge == this.serviceCharge &&
          other.ojolFee == this.ojolFee &&
          other.total == this.total &&
          other.paid == this.paid &&
          other.change == this.change &&
          other.voided == this.voided &&
          other.voidedAt == this.voidedAt &&
          other.shiftId == this.shiftId &&
          other.employeeId == this.employeeId &&
          other.customerId == this.customerId &&
          other.orderId == this.orderId &&
          other.splitGroupId == this.splitGroupId &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<String> id;
  final Value<String> code;
  final Value<int> date;
  final Value<String> channel;
  final Value<String> paymentMethod;
  final Value<int> subtotal;
  final Value<int> discount;
  final Value<int> tax;
  final Value<int> serviceCharge;
  final Value<int> ojolFee;
  final Value<int> total;
  final Value<int> paid;
  final Value<int> change;
  final Value<int> voided;
  final Value<int?> voidedAt;
  final Value<String?> shiftId;
  final Value<String?> employeeId;
  final Value<String?> customerId;
  final Value<String?> orderId;
  final Value<String?> splitGroupId;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.date = const Value.absent(),
    this.channel = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.serviceCharge = const Value.absent(),
    this.ojolFee = const Value.absent(),
    this.total = const Value.absent(),
    this.paid = const Value.absent(),
    this.change = const Value.absent(),
    this.voided = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.splitGroupId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    required String code,
    required int date,
    required String channel,
    required String paymentMethod,
    required int subtotal,
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.serviceCharge = const Value.absent(),
    this.ojolFee = const Value.absent(),
    required int total,
    required int paid,
    this.change = const Value.absent(),
    this.voided = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.customerId = const Value.absent(),
    this.orderId = const Value.absent(),
    this.splitGroupId = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       date = Value(date),
       channel = Value(channel),
       paymentMethod = Value(paymentMethod),
       subtotal = Value(subtotal),
       total = Value(total),
       paid = Value(paid),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Sale> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<int>? date,
    Expression<String>? channel,
    Expression<String>? paymentMethod,
    Expression<int>? subtotal,
    Expression<int>? discount,
    Expression<int>? tax,
    Expression<int>? serviceCharge,
    Expression<int>? ojolFee,
    Expression<int>? total,
    Expression<int>? paid,
    Expression<int>? change,
    Expression<int>? voided,
    Expression<int>? voidedAt,
    Expression<String>? shiftId,
    Expression<String>? employeeId,
    Expression<String>? customerId,
    Expression<String>? orderId,
    Expression<String>? splitGroupId,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (date != null) 'date': date,
      if (channel != null) 'channel': channel,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (tax != null) 'tax': tax,
      if (serviceCharge != null) 'service_charge': serviceCharge,
      if (ojolFee != null) 'ojol_fee': ojolFee,
      if (total != null) 'total': total,
      if (paid != null) 'paid': paid,
      if (change != null) 'change': change,
      if (voided != null) 'voided': voided,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (shiftId != null) 'shift_id': shiftId,
      if (employeeId != null) 'employee_id': employeeId,
      if (customerId != null) 'customer_id': customerId,
      if (orderId != null) 'order_id': orderId,
      if (splitGroupId != null) 'split_group_id': splitGroupId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<int>? date,
    Value<String>? channel,
    Value<String>? paymentMethod,
    Value<int>? subtotal,
    Value<int>? discount,
    Value<int>? tax,
    Value<int>? serviceCharge,
    Value<int>? ojolFee,
    Value<int>? total,
    Value<int>? paid,
    Value<int>? change,
    Value<int>? voided,
    Value<int?>? voidedAt,
    Value<String?>? shiftId,
    Value<String?>? employeeId,
    Value<String?>? customerId,
    Value<String?>? orderId,
    Value<String?>? splitGroupId,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      date: date ?? this.date,
      channel: channel ?? this.channel,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      ojolFee: ojolFee ?? this.ojolFee,
      total: total ?? this.total,
      paid: paid ?? this.paid,
      change: change ?? this.change,
      voided: voided ?? this.voided,
      voidedAt: voidedAt ?? this.voidedAt,
      shiftId: shiftId ?? this.shiftId,
      employeeId: employeeId ?? this.employeeId,
      customerId: customerId ?? this.customerId,
      orderId: orderId ?? this.orderId,
      splitGroupId: splitGroupId ?? this.splitGroupId,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (channel.present) {
      map['channel'] = Variable<String>(channel.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<int>(subtotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (tax.present) {
      map['tax'] = Variable<int>(tax.value);
    }
    if (serviceCharge.present) {
      map['service_charge'] = Variable<int>(serviceCharge.value);
    }
    if (ojolFee.present) {
      map['ojol_fee'] = Variable<int>(ojolFee.value);
    }
    if (total.present) {
      map['total'] = Variable<int>(total.value);
    }
    if (paid.present) {
      map['paid'] = Variable<int>(paid.value);
    }
    if (change.present) {
      map['change'] = Variable<int>(change.value);
    }
    if (voided.present) {
      map['voided'] = Variable<int>(voided.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<int>(voidedAt.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (customerId.present) {
      map['customer_id'] = Variable<String>(customerId.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (splitGroupId.present) {
      map['split_group_id'] = Variable<String>(splitGroupId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('date: $date, ')
          ..write('channel: $channel, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('serviceCharge: $serviceCharge, ')
          ..write('ojolFee: $ojolFee, ')
          ..write('total: $total, ')
          ..write('paid: $paid, ')
          ..write('change: $change, ')
          ..write('voided: $voided, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('shiftId: $shiftId, ')
          ..write('employeeId: $employeeId, ')
          ..write('customerId: $customerId, ')
          ..write('orderId: $orderId, ')
          ..write('splitGroupId: $splitGroupId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleLinesTable extends SaleLines
    with TableInfo<$SaleLinesTable, SaleLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hppPerUnitMeta = const VerificationMeta(
    'hppPerUnit',
  );
  @override
  late final GeneratedColumn<int> hppPerUnit = GeneratedColumn<int>(
    'hpp_per_unit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _discountMeta = const VerificationMeta(
    'discount',
  );
  @override
  late final GeneratedColumn<int> discount = GeneratedColumn<int>(
    'discount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    qty,
    price,
    hppPerUnit,
    discount,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('hpp_per_unit')) {
      context.handle(
        _hppPerUnitMeta,
        hppPerUnit.isAcceptableOrUnknown(
          data['hpp_per_unit']!,
          _hppPerUnitMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hppPerUnitMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(
        _discountMeta,
        discount.isAcceptableOrUnknown(data['discount']!, _discountMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      hppPerUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hpp_per_unit'],
      )!,
      discount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}discount'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $SaleLinesTable createAlias(String alias) {
    return $SaleLinesTable(attachedDatabase, alias);
  }
}

class SaleLine extends DataClass implements Insertable<SaleLine> {
  final String id;
  final String saleId;
  final String productId;
  final int qty;
  final int price;
  final int hppPerUnit;
  final int discount;
  final int updatedAt;
  final String deviceId;
  const SaleLine({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.qty,
    required this.price,
    required this.hppPerUnit,
    required this.discount,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['qty'] = Variable<int>(qty);
    map['price'] = Variable<int>(price);
    map['hpp_per_unit'] = Variable<int>(hppPerUnit);
    map['discount'] = Variable<int>(discount);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  SaleLinesCompanion toCompanion(bool nullToAbsent) {
    return SaleLinesCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      qty: Value(qty),
      price: Value(price),
      hppPerUnit: Value(hppPerUnit),
      discount: Value(discount),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory SaleLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleLine(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      qty: serializer.fromJson<int>(json['qty']),
      price: serializer.fromJson<int>(json['price']),
      hppPerUnit: serializer.fromJson<int>(json['hppPerUnit']),
      discount: serializer.fromJson<int>(json['discount']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'qty': serializer.toJson<int>(qty),
      'price': serializer.toJson<int>(price),
      'hppPerUnit': serializer.toJson<int>(hppPerUnit),
      'discount': serializer.toJson<int>(discount),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  SaleLine copyWith({
    String? id,
    String? saleId,
    String? productId,
    int? qty,
    int? price,
    int? hppPerUnit,
    int? discount,
    int? updatedAt,
    String? deviceId,
  }) => SaleLine(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    qty: qty ?? this.qty,
    price: price ?? this.price,
    hppPerUnit: hppPerUnit ?? this.hppPerUnit,
    discount: discount ?? this.discount,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  SaleLine copyWithCompanion(SaleLinesCompanion data) {
    return SaleLine(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      qty: data.qty.present ? data.qty.value : this.qty,
      price: data.price.present ? data.price.value : this.price,
      hppPerUnit: data.hppPerUnit.present
          ? data.hppPerUnit.value
          : this.hppPerUnit,
      discount: data.discount.present ? data.discount.value : this.discount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleLine(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('price: $price, ')
          ..write('hppPerUnit: $hppPerUnit, ')
          ..write('discount: $discount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    saleId,
    productId,
    qty,
    price,
    hppPerUnit,
    discount,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleLine &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.qty == this.qty &&
          other.price == this.price &&
          other.hppPerUnit == this.hppPerUnit &&
          other.discount == this.discount &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class SaleLinesCompanion extends UpdateCompanion<SaleLine> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<int> qty;
  final Value<int> price;
  final Value<int> hppPerUnit;
  final Value<int> discount;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const SaleLinesCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.qty = const Value.absent(),
    this.price = const Value.absent(),
    this.hppPerUnit = const Value.absent(),
    this.discount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleLinesCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required int qty,
    required int price,
    required int hppPerUnit,
    this.discount = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       productId = Value(productId),
       qty = Value(qty),
       price = Value(price),
       hppPerUnit = Value(hppPerUnit),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<SaleLine> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<int>? qty,
    Expression<int>? price,
    Expression<int>? hppPerUnit,
    Expression<int>? discount,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (qty != null) 'qty': qty,
      if (price != null) 'price': price,
      if (hppPerUnit != null) 'hpp_per_unit': hppPerUnit,
      if (discount != null) 'discount': discount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? productId,
    Value<int>? qty,
    Value<int>? price,
    Value<int>? hppPerUnit,
    Value<int>? discount,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return SaleLinesCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      hppPerUnit: hppPerUnit ?? this.hppPerUnit,
      discount: discount ?? this.discount,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (hppPerUnit.present) {
      map['hpp_per_unit'] = Variable<int>(hppPerUnit.value);
    }
    if (discount.present) {
      map['discount'] = Variable<int>(discount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleLinesCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('price: $price, ')
          ..write('hppPerUnit: $hppPerUnit, ')
          ..write('discount: $discount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalePaymentsTable extends SalePayments
    with TableInfo<$SalePaymentsTable, SalePayment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalePaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES sales (id)',
    ),
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _processedAtMeta = const VerificationMeta(
    'processedAt',
  );
  @override
  late final GeneratedColumn<int> processedAt = GeneratedColumn<int>(
    'processed_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    method,
    amount,
    processedAt,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<SalePayment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('processed_at')) {
      context.handle(
        _processedAtMeta,
        processedAt.isAcceptableOrUnknown(
          data['processed_at']!,
          _processedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_processedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SalePayment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SalePayment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      processedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}processed_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $SalePaymentsTable createAlias(String alias) {
    return $SalePaymentsTable(attachedDatabase, alias);
  }
}

class SalePayment extends DataClass implements Insertable<SalePayment> {
  final String id;
  final String saleId;
  final String method;
  final int amount;
  final int processedAt;
  final int updatedAt;
  final String deviceId;
  const SalePayment({
    required this.id,
    required this.saleId,
    required this.method,
    required this.amount,
    required this.processedAt,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['method'] = Variable<String>(method);
    map['amount'] = Variable<int>(amount);
    map['processed_at'] = Variable<int>(processedAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  SalePaymentsCompanion toCompanion(bool nullToAbsent) {
    return SalePaymentsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      method: Value(method),
      amount: Value(amount),
      processedAt: Value(processedAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory SalePayment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SalePayment(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      method: serializer.fromJson<String>(json['method']),
      amount: serializer.fromJson<int>(json['amount']),
      processedAt: serializer.fromJson<int>(json['processedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'method': serializer.toJson<String>(method),
      'amount': serializer.toJson<int>(amount),
      'processedAt': serializer.toJson<int>(processedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  SalePayment copyWith({
    String? id,
    String? saleId,
    String? method,
    int? amount,
    int? processedAt,
    int? updatedAt,
    String? deviceId,
  }) => SalePayment(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    method: method ?? this.method,
    amount: amount ?? this.amount,
    processedAt: processedAt ?? this.processedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  SalePayment copyWithCompanion(SalePaymentsCompanion data) {
    return SalePayment(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      processedAt: data.processedAt.present
          ? data.processedAt.value
          : this.processedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SalePayment(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('processedAt: $processedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, method, amount, processedAt, updatedAt, deviceId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalePayment &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.processedAt == this.processedAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class SalePaymentsCompanion extends UpdateCompanion<SalePayment> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> method;
  final Value<int> amount;
  final Value<int> processedAt;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const SalePaymentsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.processedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalePaymentsCompanion.insert({
    required String id,
    required String saleId,
    required String method,
    required int amount,
    required int processedAt,
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       method = Value(method),
       amount = Value(amount),
       processedAt = Value(processedAt),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<SalePayment> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? method,
    Expression<int>? amount,
    Expression<int>? processedAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (processedAt != null) 'processed_at': processedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalePaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? method,
    Value<int>? amount,
    Value<int>? processedAt,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return SalePaymentsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      processedAt: processedAt ?? this.processedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (processedAt.present) {
      map['processed_at'] = Variable<int>(processedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalePaymentsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('processedAt: $processedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockQtyMeta = const VerificationMeta(
    'stockQty',
  );
  @override
  late final GeneratedColumn<double> stockQty = GeneratedColumn<double>(
    'stock_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _avgCostMilliMeta = const VerificationMeta(
    'avgCostMilli',
  );
  @override
  late final GeneratedColumn<int> avgCostMilli = GeneratedColumn<int>(
    'avg_cost_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalValueMeta = const VerificationMeta(
    'totalValue',
  );
  @override
  late final GeneratedColumn<int> totalValue = GeneratedColumn<int>(
    'total_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lowStockAtMeta = const VerificationMeta(
    'lowStockAt',
  );
  @override
  late final GeneratedColumn<double> lowStockAt = GeneratedColumn<double>(
    'low_stock_at',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    unit,
    stockQty,
    avgCostMilli,
    totalValue,
    lowStockAt,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('stock_qty')) {
      context.handle(
        _stockQtyMeta,
        stockQty.isAcceptableOrUnknown(data['stock_qty']!, _stockQtyMeta),
      );
    }
    if (data.containsKey('avg_cost_milli')) {
      context.handle(
        _avgCostMilliMeta,
        avgCostMilli.isAcceptableOrUnknown(
          data['avg_cost_milli']!,
          _avgCostMilliMeta,
        ),
      );
    }
    if (data.containsKey('total_value')) {
      context.handle(
        _totalValueMeta,
        totalValue.isAcceptableOrUnknown(data['total_value']!, _totalValueMeta),
      );
    }
    if (data.containsKey('low_stock_at')) {
      context.handle(
        _lowStockAtMeta,
        lowStockAt.isAcceptableOrUnknown(
          data['low_stock_at']!,
          _lowStockAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      stockQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stock_qty'],
      )!,
      avgCostMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}avg_cost_milli'],
      )!,
      totalValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_value'],
      )!,
      lowStockAt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}low_stock_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final String id;
  final String name;
  final String unit;
  final double stockQty;
  final int avgCostMilli;
  final int totalValue;
  final double lowStockAt;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Ingredient({
    required this.id,
    required this.name,
    required this.unit,
    required this.stockQty,
    required this.avgCostMilli,
    required this.totalValue,
    required this.lowStockAt,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['unit'] = Variable<String>(unit);
    map['stock_qty'] = Variable<double>(stockQty);
    map['avg_cost_milli'] = Variable<int>(avgCostMilli);
    map['total_value'] = Variable<int>(totalValue);
    map['low_stock_at'] = Variable<double>(lowStockAt);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      name: Value(name),
      unit: Value(unit),
      stockQty: Value(stockQty),
      avgCostMilli: Value(avgCostMilli),
      totalValue: Value(totalValue),
      lowStockAt: Value(lowStockAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      unit: serializer.fromJson<String>(json['unit']),
      stockQty: serializer.fromJson<double>(json['stockQty']),
      avgCostMilli: serializer.fromJson<int>(json['avgCostMilli']),
      totalValue: serializer.fromJson<int>(json['totalValue']),
      lowStockAt: serializer.fromJson<double>(json['lowStockAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'unit': serializer.toJson<String>(unit),
      'stockQty': serializer.toJson<double>(stockQty),
      'avgCostMilli': serializer.toJson<int>(avgCostMilli),
      'totalValue': serializer.toJson<int>(totalValue),
      'lowStockAt': serializer.toJson<double>(lowStockAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Ingredient copyWith({
    String? id,
    String? name,
    String? unit,
    double? stockQty,
    int? avgCostMilli,
    int? totalValue,
    double? lowStockAt,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Ingredient(
    id: id ?? this.id,
    name: name ?? this.name,
    unit: unit ?? this.unit,
    stockQty: stockQty ?? this.stockQty,
    avgCostMilli: avgCostMilli ?? this.avgCostMilli,
    totalValue: totalValue ?? this.totalValue,
    lowStockAt: lowStockAt ?? this.lowStockAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      unit: data.unit.present ? data.unit.value : this.unit,
      stockQty: data.stockQty.present ? data.stockQty.value : this.stockQty,
      avgCostMilli: data.avgCostMilli.present
          ? data.avgCostMilli.value
          : this.avgCostMilli,
      totalValue: data.totalValue.present
          ? data.totalValue.value
          : this.totalValue,
      lowStockAt: data.lowStockAt.present
          ? data.lowStockAt.value
          : this.lowStockAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('stockQty: $stockQty, ')
          ..write('avgCostMilli: $avgCostMilli, ')
          ..write('totalValue: $totalValue, ')
          ..write('lowStockAt: $lowStockAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    unit,
    stockQty,
    avgCostMilli,
    totalValue,
    lowStockAt,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.name == this.name &&
          other.unit == this.unit &&
          other.stockQty == this.stockQty &&
          other.avgCostMilli == this.avgCostMilli &&
          other.totalValue == this.totalValue &&
          other.lowStockAt == this.lowStockAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> unit;
  final Value<double> stockQty;
  final Value<int> avgCostMilli;
  final Value<int> totalValue;
  final Value<double> lowStockAt;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.unit = const Value.absent(),
    this.stockQty = const Value.absent(),
    this.avgCostMilli = const Value.absent(),
    this.totalValue = const Value.absent(),
    this.lowStockAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientsCompanion.insert({
    required String id,
    required String name,
    required String unit,
    this.stockQty = const Value.absent(),
    this.avgCostMilli = const Value.absent(),
    this.totalValue = const Value.absent(),
    this.lowStockAt = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       unit = Value(unit),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Ingredient> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? unit,
    Expression<double>? stockQty,
    Expression<int>? avgCostMilli,
    Expression<int>? totalValue,
    Expression<double>? lowStockAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (unit != null) 'unit': unit,
      if (stockQty != null) 'stock_qty': stockQty,
      if (avgCostMilli != null) 'avg_cost_milli': avgCostMilli,
      if (totalValue != null) 'total_value': totalValue,
      if (lowStockAt != null) 'low_stock_at': lowStockAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? unit,
    Value<double>? stockQty,
    Value<int>? avgCostMilli,
    Value<int>? totalValue,
    Value<double>? lowStockAt,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      unit: unit ?? this.unit,
      stockQty: stockQty ?? this.stockQty,
      avgCostMilli: avgCostMilli ?? this.avgCostMilli,
      totalValue: totalValue ?? this.totalValue,
      lowStockAt: lowStockAt ?? this.lowStockAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (stockQty.present) {
      map['stock_qty'] = Variable<double>(stockQty.value);
    }
    if (avgCostMilli.present) {
      map['avg_cost_milli'] = Variable<int>(avgCostMilli.value);
    }
    if (totalValue.present) {
      map['total_value'] = Variable<int>(totalValue.value);
    }
    if (lowStockAt.present) {
      map['low_stock_at'] = Variable<double>(lowStockAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('unit: $unit, ')
          ..write('stockQty: $stockQty, ')
          ..write('avgCostMilli: $avgCostMilli, ')
          ..write('totalValue: $totalValue, ')
          ..write('lowStockAt: $lowStockAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    productId,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {productId},
  ];
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final String productId;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Recipe({
    required this.id,
    required this.productId,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['product_id'] = Variable<String>(productId);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      productId: Value(productId),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      productId: serializer.fromJson<String>(json['productId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'productId': serializer.toJson<String>(productId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Recipe copyWith({
    String? id,
    String? productId,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Recipe(
    id: id ?? this.id,
    productId: productId ?? this.productId,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      productId: data.productId.present ? data.productId.value : this.productId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, productId, updatedAt, deviceId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.productId == this.productId &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<String> productId;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.productId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String productId,
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       productId = Value(productId),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<String>? productId,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (productId != null) 'product_id': productId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? productId,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('productId: $productId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeLinesTable extends RecipeLines
    with TableInfo<$RecipeLinesTable, RecipeLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    ingredientId,
    qty,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {recipeId, ingredientId},
  ];
  @override
  RecipeLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $RecipeLinesTable createAlias(String alias) {
    return $RecipeLinesTable(attachedDatabase, alias);
  }
}

class RecipeLine extends DataClass implements Insertable<RecipeLine> {
  final String id;
  final String recipeId;
  final String ingredientId;
  final double qty;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const RecipeLine({
    required this.id,
    required this.recipeId,
    required this.ingredientId,
    required this.qty,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['qty'] = Variable<double>(qty);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  RecipeLinesCompanion toCompanion(bool nullToAbsent) {
    return RecipeLinesCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      ingredientId: Value(ingredientId),
      qty: Value(qty),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory RecipeLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeLine(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      qty: serializer.fromJson<double>(json['qty']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'qty': serializer.toJson<double>(qty),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  RecipeLine copyWith({
    String? id,
    String? recipeId,
    String? ingredientId,
    double? qty,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => RecipeLine(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    ingredientId: ingredientId ?? this.ingredientId,
    qty: qty ?? this.qty,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  RecipeLine copyWithCompanion(RecipeLinesCompanion data) {
    return RecipeLine(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      qty: data.qty.present ? data.qty.value : this.qty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeLine(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('qty: $qty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    ingredientId,
    qty,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeLine &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.ingredientId == this.ingredientId &&
          other.qty == this.qty &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class RecipeLinesCompanion extends UpdateCompanion<RecipeLine> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<String> ingredientId;
  final Value<double> qty;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const RecipeLinesCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.qty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeLinesCompanion.insert({
    required String id,
    required String recipeId,
    required String ingredientId,
    required double qty,
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       ingredientId = Value(ingredientId),
       qty = Value(qty),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<RecipeLine> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<String>? ingredientId,
    Expression<double>? qty,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (qty != null) 'qty': qty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<String>? ingredientId,
    Value<double>? qty,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return RecipeLinesCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      ingredientId: ingredientId ?? this.ingredientId,
      qty: qty ?? this.qty,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeLinesCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('qty: $qty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovesTable extends StockMoves
    with TableInfo<$StockMovesTable, StockMove> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<double> qty = GeneratedColumn<double>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitCostMilliMeta = const VerificationMeta(
    'unitCostMilli',
  );
  @override
  late final GeneratedColumn<int> unitCostMilli = GeneratedColumn<int>(
    'unit_cost_milli',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refTypeMeta = const VerificationMeta(
    'refType',
  );
  @override
  late final GeneratedColumn<String> refType = GeneratedColumn<String>(
    'ref_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ingredientId,
    date,
    type,
    qty,
    unitCostMilli,
    refType,
    refId,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_moves';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMove> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('unit_cost_milli')) {
      context.handle(
        _unitCostMilliMeta,
        unitCostMilli.isAcceptableOrUnknown(
          data['unit_cost_milli']!,
          _unitCostMilliMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitCostMilliMeta);
    }
    if (data.containsKey('ref_type')) {
      context.handle(
        _refTypeMeta,
        refType.isAcceptableOrUnknown(data['ref_type']!, _refTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_refTypeMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMove map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMove(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty'],
      )!,
      unitCostMilli: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_cost_milli'],
      )!,
      refType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_type'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $StockMovesTable createAlias(String alias) {
    return $StockMovesTable(attachedDatabase, alias);
  }
}

class StockMove extends DataClass implements Insertable<StockMove> {
  final String id;
  final String ingredientId;
  final int date;
  final String type;
  final double qty;
  final int unitCostMilli;
  final String refType;
  final String refId;
  final int updatedAt;
  final String deviceId;
  const StockMove({
    required this.id,
    required this.ingredientId,
    required this.date,
    required this.type,
    required this.qty,
    required this.unitCostMilli,
    required this.refType,
    required this.refId,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['date'] = Variable<int>(date);
    map['type'] = Variable<String>(type);
    map['qty'] = Variable<double>(qty);
    map['unit_cost_milli'] = Variable<int>(unitCostMilli);
    map['ref_type'] = Variable<String>(refType);
    map['ref_id'] = Variable<String>(refId);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  StockMovesCompanion toCompanion(bool nullToAbsent) {
    return StockMovesCompanion(
      id: Value(id),
      ingredientId: Value(ingredientId),
      date: Value(date),
      type: Value(type),
      qty: Value(qty),
      unitCostMilli: Value(unitCostMilli),
      refType: Value(refType),
      refId: Value(refId),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory StockMove.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMove(
      id: serializer.fromJson<String>(json['id']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      date: serializer.fromJson<int>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      qty: serializer.fromJson<double>(json['qty']),
      unitCostMilli: serializer.fromJson<int>(json['unitCostMilli']),
      refType: serializer.fromJson<String>(json['refType']),
      refId: serializer.fromJson<String>(json['refId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'date': serializer.toJson<int>(date),
      'type': serializer.toJson<String>(type),
      'qty': serializer.toJson<double>(qty),
      'unitCostMilli': serializer.toJson<int>(unitCostMilli),
      'refType': serializer.toJson<String>(refType),
      'refId': serializer.toJson<String>(refId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  StockMove copyWith({
    String? id,
    String? ingredientId,
    int? date,
    String? type,
    double? qty,
    int? unitCostMilli,
    String? refType,
    String? refId,
    int? updatedAt,
    String? deviceId,
  }) => StockMove(
    id: id ?? this.id,
    ingredientId: ingredientId ?? this.ingredientId,
    date: date ?? this.date,
    type: type ?? this.type,
    qty: qty ?? this.qty,
    unitCostMilli: unitCostMilli ?? this.unitCostMilli,
    refType: refType ?? this.refType,
    refId: refId ?? this.refId,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  StockMove copyWithCompanion(StockMovesCompanion data) {
    return StockMove(
      id: data.id.present ? data.id.value : this.id,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      qty: data.qty.present ? data.qty.value : this.qty,
      unitCostMilli: data.unitCostMilli.present
          ? data.unitCostMilli.value
          : this.unitCostMilli,
      refType: data.refType.present ? data.refType.value : this.refType,
      refId: data.refId.present ? data.refId.value : this.refId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMove(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('qty: $qty, ')
          ..write('unitCostMilli: $unitCostMilli, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ingredientId,
    date,
    type,
    qty,
    unitCostMilli,
    refType,
    refId,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMove &&
          other.id == this.id &&
          other.ingredientId == this.ingredientId &&
          other.date == this.date &&
          other.type == this.type &&
          other.qty == this.qty &&
          other.unitCostMilli == this.unitCostMilli &&
          other.refType == this.refType &&
          other.refId == this.refId &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class StockMovesCompanion extends UpdateCompanion<StockMove> {
  final Value<String> id;
  final Value<String> ingredientId;
  final Value<int> date;
  final Value<String> type;
  final Value<double> qty;
  final Value<int> unitCostMilli;
  final Value<String> refType;
  final Value<String> refId;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const StockMovesCompanion({
    this.id = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.qty = const Value.absent(),
    this.unitCostMilli = const Value.absent(),
    this.refType = const Value.absent(),
    this.refId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovesCompanion.insert({
    required String id,
    required String ingredientId,
    required int date,
    required String type,
    required double qty,
    required int unitCostMilli,
    required String refType,
    required String refId,
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ingredientId = Value(ingredientId),
       date = Value(date),
       type = Value(type),
       qty = Value(qty),
       unitCostMilli = Value(unitCostMilli),
       refType = Value(refType),
       refId = Value(refId),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<StockMove> custom({
    Expression<String>? id,
    Expression<String>? ingredientId,
    Expression<int>? date,
    Expression<String>? type,
    Expression<double>? qty,
    Expression<int>? unitCostMilli,
    Expression<String>? refType,
    Expression<String>? refId,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (qty != null) 'qty': qty,
      if (unitCostMilli != null) 'unit_cost_milli': unitCostMilli,
      if (refType != null) 'ref_type': refType,
      if (refId != null) 'ref_id': refId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovesCompanion copyWith({
    Value<String>? id,
    Value<String>? ingredientId,
    Value<int>? date,
    Value<String>? type,
    Value<double>? qty,
    Value<int>? unitCostMilli,
    Value<String>? refType,
    Value<String>? refId,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return StockMovesCompanion(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      date: date ?? this.date,
      type: type ?? this.type,
      qty: qty ?? this.qty,
      unitCostMilli: unitCostMilli ?? this.unitCostMilli,
      refType: refType ?? this.refType,
      refId: refId ?? this.refId,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (qty.present) {
      map['qty'] = Variable<double>(qty.value);
    }
    if (unitCostMilli.present) {
      map['unit_cost_milli'] = Variable<int>(unitCostMilli.value);
    }
    if (refType.present) {
      map['ref_type'] = Variable<String>(refType.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovesCompanion(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('qty: $qty, ')
          ..write('unitCostMilli: $unitCostMilli, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalMeta = const VerificationMeta('normal');
  @override
  late final GeneratedColumn<String> normal = GeneratedColumn<String>(
    'normal',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    name,
    type,
    normal,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('normal')) {
      context.handle(
        _normalMeta,
        normal.isAcceptableOrUnknown(data['normal']!, _normalMeta),
      );
    } else if (isInserting) {
      context.missing(_normalMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {code},
  ];
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      normal: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normal'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String code;
  final String name;
  final String type;
  final String normal;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Account({
    required this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.normal,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['code'] = Variable<String>(code);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['normal'] = Variable<String>(normal);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      code: Value(code),
      name: Value(name),
      type: Value(type),
      normal: Value(normal),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      normal: serializer.fromJson<String>(json['normal']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'code': serializer.toJson<String>(code),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'normal': serializer.toJson<String>(normal),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Account copyWith({
    String? id,
    String? code,
    String? name,
    String? type,
    String? normal,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Account(
    id: id ?? this.id,
    code: code ?? this.code,
    name: name ?? this.name,
    type: type ?? this.type,
    normal: normal ?? this.normal,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      normal: data.normal.present ? data.normal.value : this.normal,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('normal: $normal, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, name, type, normal, updatedAt, deviceId, isDeleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.code == this.code &&
          other.name == this.name &&
          other.type == this.type &&
          other.normal == this.normal &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> code;
  final Value<String> name;
  final Value<String> type;
  final Value<String> normal;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.normal = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String code,
    required String name,
    required String type,
    required String normal,
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       code = Value(code),
       name = Value(name),
       type = Value(type),
       normal = Value(normal),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? code,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? normal,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (normal != null) 'normal': normal,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? code,
    Value<String>? name,
    Value<String>? type,
    Value<String>? normal,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      type: type ?? this.type,
      normal: normal ?? this.normal,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (normal.present) {
      map['normal'] = Variable<String>(normal.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('normal: $normal, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalsTable extends Journals with TableInfo<$JournalsTable, Journal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refTypeMeta = const VerificationMeta(
    'refType',
  );
  @override
  late final GeneratedColumn<String> refType = GeneratedColumn<String>(
    'ref_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reversesJournalIdMeta = const VerificationMeta(
    'reversesJournalId',
  );
  @override
  late final GeneratedColumn<String> reversesJournalId =
      GeneratedColumn<String>(
        'reverses_journal_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isReversalMeta = const VerificationMeta(
    'isReversal',
  );
  @override
  late final GeneratedColumn<int> isReversal = GeneratedColumn<int>(
    'is_reversal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    memo,
    refType,
    refId,
    reversesJournalId,
    isReversal,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Journal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    } else if (isInserting) {
      context.missing(_memoMeta);
    }
    if (data.containsKey('ref_type')) {
      context.handle(
        _refTypeMeta,
        refType.isAcceptableOrUnknown(data['ref_type']!, _refTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_refTypeMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    } else if (isInserting) {
      context.missing(_refIdMeta);
    }
    if (data.containsKey('reverses_journal_id')) {
      context.handle(
        _reversesJournalIdMeta,
        reversesJournalId.isAcceptableOrUnknown(
          data['reverses_journal_id']!,
          _reversesJournalIdMeta,
        ),
      );
    }
    if (data.containsKey('is_reversal')) {
      context.handle(
        _isReversalMeta,
        isReversal.isAcceptableOrUnknown(data['is_reversal']!, _isReversalMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {refType, refId},
  ];
  @override
  Journal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Journal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      )!,
      refType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_type'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      )!,
      reversesJournalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reverses_journal_id'],
      ),
      isReversal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}is_reversal'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $JournalsTable createAlias(String alias) {
    return $JournalsTable(attachedDatabase, alias);
  }
}

class Journal extends DataClass implements Insertable<Journal> {
  final String id;
  final int date;
  final String memo;
  final String refType;
  final String refId;
  final String? reversesJournalId;
  final int isReversal;
  final int updatedAt;
  final String deviceId;
  const Journal({
    required this.id,
    required this.date,
    required this.memo,
    required this.refType,
    required this.refId,
    this.reversesJournalId,
    required this.isReversal,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<int>(date);
    map['memo'] = Variable<String>(memo);
    map['ref_type'] = Variable<String>(refType);
    map['ref_id'] = Variable<String>(refId);
    if (!nullToAbsent || reversesJournalId != null) {
      map['reverses_journal_id'] = Variable<String>(reversesJournalId);
    }
    map['is_reversal'] = Variable<int>(isReversal);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  JournalsCompanion toCompanion(bool nullToAbsent) {
    return JournalsCompanion(
      id: Value(id),
      date: Value(date),
      memo: Value(memo),
      refType: Value(refType),
      refId: Value(refId),
      reversesJournalId: reversesJournalId == null && nullToAbsent
          ? const Value.absent()
          : Value(reversesJournalId),
      isReversal: Value(isReversal),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory Journal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Journal(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      memo: serializer.fromJson<String>(json['memo']),
      refType: serializer.fromJson<String>(json['refType']),
      refId: serializer.fromJson<String>(json['refId']),
      reversesJournalId: serializer.fromJson<String?>(
        json['reversesJournalId'],
      ),
      isReversal: serializer.fromJson<int>(json['isReversal']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<int>(date),
      'memo': serializer.toJson<String>(memo),
      'refType': serializer.toJson<String>(refType),
      'refId': serializer.toJson<String>(refId),
      'reversesJournalId': serializer.toJson<String?>(reversesJournalId),
      'isReversal': serializer.toJson<int>(isReversal),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Journal copyWith({
    String? id,
    int? date,
    String? memo,
    String? refType,
    String? refId,
    Value<String?> reversesJournalId = const Value.absent(),
    int? isReversal,
    int? updatedAt,
    String? deviceId,
  }) => Journal(
    id: id ?? this.id,
    date: date ?? this.date,
    memo: memo ?? this.memo,
    refType: refType ?? this.refType,
    refId: refId ?? this.refId,
    reversesJournalId: reversesJournalId.present
        ? reversesJournalId.value
        : this.reversesJournalId,
    isReversal: isReversal ?? this.isReversal,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Journal copyWithCompanion(JournalsCompanion data) {
    return Journal(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      memo: data.memo.present ? data.memo.value : this.memo,
      refType: data.refType.present ? data.refType.value : this.refType,
      refId: data.refId.present ? data.refId.value : this.refId,
      reversesJournalId: data.reversesJournalId.present
          ? data.reversesJournalId.value
          : this.reversesJournalId,
      isReversal: data.isReversal.present
          ? data.isReversal.value
          : this.isReversal,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Journal(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('memo: $memo, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('reversesJournalId: $reversesJournalId, ')
          ..write('isReversal: $isReversal, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    memo,
    refType,
    refId,
    reversesJournalId,
    isReversal,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Journal &&
          other.id == this.id &&
          other.date == this.date &&
          other.memo == this.memo &&
          other.refType == this.refType &&
          other.refId == this.refId &&
          other.reversesJournalId == this.reversesJournalId &&
          other.isReversal == this.isReversal &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class JournalsCompanion extends UpdateCompanion<Journal> {
  final Value<String> id;
  final Value<int> date;
  final Value<String> memo;
  final Value<String> refType;
  final Value<String> refId;
  final Value<String?> reversesJournalId;
  final Value<int> isReversal;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const JournalsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.memo = const Value.absent(),
    this.refType = const Value.absent(),
    this.refId = const Value.absent(),
    this.reversesJournalId = const Value.absent(),
    this.isReversal = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalsCompanion.insert({
    required String id,
    required int date,
    required String memo,
    required String refType,
    required String refId,
    this.reversesJournalId = const Value.absent(),
    this.isReversal = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       memo = Value(memo),
       refType = Value(refType),
       refId = Value(refId),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Journal> custom({
    Expression<String>? id,
    Expression<int>? date,
    Expression<String>? memo,
    Expression<String>? refType,
    Expression<String>? refId,
    Expression<String>? reversesJournalId,
    Expression<int>? isReversal,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (memo != null) 'memo': memo,
      if (refType != null) 'ref_type': refType,
      if (refId != null) 'ref_id': refId,
      if (reversesJournalId != null) 'reverses_journal_id': reversesJournalId,
      if (isReversal != null) 'is_reversal': isReversal,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalsCompanion copyWith({
    Value<String>? id,
    Value<int>? date,
    Value<String>? memo,
    Value<String>? refType,
    Value<String>? refId,
    Value<String?>? reversesJournalId,
    Value<int>? isReversal,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return JournalsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      memo: memo ?? this.memo,
      refType: refType ?? this.refType,
      refId: refId ?? this.refId,
      reversesJournalId: reversesJournalId ?? this.reversesJournalId,
      isReversal: isReversal ?? this.isReversal,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (refType.present) {
      map['ref_type'] = Variable<String>(refType.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (reversesJournalId.present) {
      map['reverses_journal_id'] = Variable<String>(reversesJournalId.value);
    }
    if (isReversal.present) {
      map['is_reversal'] = Variable<int>(isReversal.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('memo: $memo, ')
          ..write('refType: $refType, ')
          ..write('refId: $refId, ')
          ..write('reversesJournalId: $reversesJournalId, ')
          ..write('isReversal: $isReversal, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $JournalLinesTable extends JournalLines
    with TableInfo<$JournalLinesTable, JournalLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $JournalLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _journalIdMeta = const VerificationMeta(
    'journalId',
  );
  @override
  late final GeneratedColumn<String> journalId = GeneratedColumn<String>(
    'journal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES journals (id)',
    ),
  );
  static const VerificationMeta _accountCodeMeta = const VerificationMeta(
    'accountCode',
  );
  @override
  late final GeneratedColumn<String> accountCode = GeneratedColumn<String>(
    'account_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (code)',
    ),
  );
  static const VerificationMeta _debitMeta = const VerificationMeta('debit');
  @override
  late final GeneratedColumn<int> debit = GeneratedColumn<int>(
    'debit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _creditMeta = const VerificationMeta('credit');
  @override
  late final GeneratedColumn<int> credit = GeneratedColumn<int>(
    'credit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    journalId,
    accountCode,
    debit,
    credit,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('journal_id')) {
      context.handle(
        _journalIdMeta,
        journalId.isAcceptableOrUnknown(data['journal_id']!, _journalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_journalIdMeta);
    }
    if (data.containsKey('account_code')) {
      context.handle(
        _accountCodeMeta,
        accountCode.isAcceptableOrUnknown(
          data['account_code']!,
          _accountCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountCodeMeta);
    }
    if (data.containsKey('debit')) {
      context.handle(
        _debitMeta,
        debit.isAcceptableOrUnknown(data['debit']!, _debitMeta),
      );
    }
    if (data.containsKey('credit')) {
      context.handle(
        _creditMeta,
        credit.isAcceptableOrUnknown(data['credit']!, _creditMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      journalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}journal_id'],
      )!,
      accountCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_code'],
      )!,
      debit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}debit'],
      )!,
      credit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $JournalLinesTable createAlias(String alias) {
    return $JournalLinesTable(attachedDatabase, alias);
  }
}

class JournalLine extends DataClass implements Insertable<JournalLine> {
  final String id;
  final String journalId;
  final String accountCode;
  final int debit;
  final int credit;
  final int updatedAt;
  final String deviceId;
  const JournalLine({
    required this.id,
    required this.journalId,
    required this.accountCode,
    required this.debit,
    required this.credit,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['journal_id'] = Variable<String>(journalId);
    map['account_code'] = Variable<String>(accountCode);
    map['debit'] = Variable<int>(debit);
    map['credit'] = Variable<int>(credit);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  JournalLinesCompanion toCompanion(bool nullToAbsent) {
    return JournalLinesCompanion(
      id: Value(id),
      journalId: Value(journalId),
      accountCode: Value(accountCode),
      debit: Value(debit),
      credit: Value(credit),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory JournalLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return JournalLine(
      id: serializer.fromJson<String>(json['id']),
      journalId: serializer.fromJson<String>(json['journalId']),
      accountCode: serializer.fromJson<String>(json['accountCode']),
      debit: serializer.fromJson<int>(json['debit']),
      credit: serializer.fromJson<int>(json['credit']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'journalId': serializer.toJson<String>(journalId),
      'accountCode': serializer.toJson<String>(accountCode),
      'debit': serializer.toJson<int>(debit),
      'credit': serializer.toJson<int>(credit),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  JournalLine copyWith({
    String? id,
    String? journalId,
    String? accountCode,
    int? debit,
    int? credit,
    int? updatedAt,
    String? deviceId,
  }) => JournalLine(
    id: id ?? this.id,
    journalId: journalId ?? this.journalId,
    accountCode: accountCode ?? this.accountCode,
    debit: debit ?? this.debit,
    credit: credit ?? this.credit,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  JournalLine copyWithCompanion(JournalLinesCompanion data) {
    return JournalLine(
      id: data.id.present ? data.id.value : this.id,
      journalId: data.journalId.present ? data.journalId.value : this.journalId,
      accountCode: data.accountCode.present
          ? data.accountCode.value
          : this.accountCode,
      debit: data.debit.present ? data.debit.value : this.debit,
      credit: data.credit.present ? data.credit.value : this.credit,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('JournalLine(')
          ..write('id: $id, ')
          ..write('journalId: $journalId, ')
          ..write('accountCode: $accountCode, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    journalId,
    accountCode,
    debit,
    credit,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is JournalLine &&
          other.id == this.id &&
          other.journalId == this.journalId &&
          other.accountCode == this.accountCode &&
          other.debit == this.debit &&
          other.credit == this.credit &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class JournalLinesCompanion extends UpdateCompanion<JournalLine> {
  final Value<String> id;
  final Value<String> journalId;
  final Value<String> accountCode;
  final Value<int> debit;
  final Value<int> credit;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const JournalLinesCompanion({
    this.id = const Value.absent(),
    this.journalId = const Value.absent(),
    this.accountCode = const Value.absent(),
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  JournalLinesCompanion.insert({
    required String id,
    required String journalId,
    required String accountCode,
    this.debit = const Value.absent(),
    this.credit = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       journalId = Value(journalId),
       accountCode = Value(accountCode),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<JournalLine> custom({
    Expression<String>? id,
    Expression<String>? journalId,
    Expression<String>? accountCode,
    Expression<int>? debit,
    Expression<int>? credit,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (journalId != null) 'journal_id': journalId,
      if (accountCode != null) 'account_code': accountCode,
      if (debit != null) 'debit': debit,
      if (credit != null) 'credit': credit,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  JournalLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? journalId,
    Value<String>? accountCode,
    Value<int>? debit,
    Value<int>? credit,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return JournalLinesCompanion(
      id: id ?? this.id,
      journalId: journalId ?? this.journalId,
      accountCode: accountCode ?? this.accountCode,
      debit: debit ?? this.debit,
      credit: credit ?? this.credit,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (journalId.present) {
      map['journal_id'] = Variable<String>(journalId.value);
    }
    if (accountCode.present) {
      map['account_code'] = Variable<String>(accountCode.value);
    }
    if (debit.present) {
      map['debit'] = Variable<int>(debit.value);
    }
    if (credit.present) {
      map['credit'] = Variable<int>(credit.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('JournalLinesCompanion(')
          ..write('id: $id, ')
          ..write('journalId: $journalId, ')
          ..write('accountCode: $accountCode, ')
          ..write('debit: $debit, ')
          ..write('credit: $credit, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PettyCashTable extends PettyCash
    with TableInfo<$PettyCashTable, PettyCashRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PettyCashTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shifts (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    date,
    amount,
    note,
    employeeId,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'petty_cash';
  @override
  VerificationContext validateIntegrity(
    Insertable<PettyCashRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PettyCashRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PettyCashRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $PettyCashTable createAlias(String alias) {
    return $PettyCashTable(attachedDatabase, alias);
  }
}

class PettyCashRow extends DataClass implements Insertable<PettyCashRow> {
  final String id;
  final String? shiftId;
  final int date;
  final int amount;
  final String note;
  final String employeeId;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const PettyCashRow({
    required this.id,
    this.shiftId,
    required this.date,
    required this.amount,
    required this.note,
    required this.employeeId,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<String>(shiftId);
    }
    map['date'] = Variable<int>(date);
    map['amount'] = Variable<int>(amount);
    map['note'] = Variable<String>(note);
    map['employee_id'] = Variable<String>(employeeId);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  PettyCashCompanion toCompanion(bool nullToAbsent) {
    return PettyCashCompanion(
      id: Value(id),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      date: Value(date),
      amount: Value(amount),
      note: Value(note),
      employeeId: Value(employeeId),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory PettyCashRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PettyCashRow(
      id: serializer.fromJson<String>(json['id']),
      shiftId: serializer.fromJson<String?>(json['shiftId']),
      date: serializer.fromJson<int>(json['date']),
      amount: serializer.fromJson<int>(json['amount']),
      note: serializer.fromJson<String>(json['note']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'shiftId': serializer.toJson<String?>(shiftId),
      'date': serializer.toJson<int>(date),
      'amount': serializer.toJson<int>(amount),
      'note': serializer.toJson<String>(note),
      'employeeId': serializer.toJson<String>(employeeId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  PettyCashRow copyWith({
    String? id,
    Value<String?> shiftId = const Value.absent(),
    int? date,
    int? amount,
    String? note,
    String? employeeId,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => PettyCashRow(
    id: id ?? this.id,
    shiftId: shiftId.present ? shiftId.value : this.shiftId,
    date: date ?? this.date,
    amount: amount ?? this.amount,
    note: note ?? this.note,
    employeeId: employeeId ?? this.employeeId,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  PettyCashRow copyWithCompanion(PettyCashCompanion data) {
    return PettyCashRow(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      date: data.date.present ? data.date.value : this.date,
      amount: data.amount.present ? data.amount.value : this.amount,
      note: data.note.present ? data.note.value : this.note,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PettyCashRow(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('employeeId: $employeeId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shiftId,
    date,
    amount,
    note,
    employeeId,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PettyCashRow &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.date == this.date &&
          other.amount == this.amount &&
          other.note == this.note &&
          other.employeeId == this.employeeId &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class PettyCashCompanion extends UpdateCompanion<PettyCashRow> {
  final Value<String> id;
  final Value<String?> shiftId;
  final Value<int> date;
  final Value<int> amount;
  final Value<String> note;
  final Value<String> employeeId;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const PettyCashCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.date = const Value.absent(),
    this.amount = const Value.absent(),
    this.note = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PettyCashCompanion.insert({
    required String id,
    this.shiftId = const Value.absent(),
    required int date,
    required int amount,
    required String note,
    required String employeeId,
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       amount = Value(amount),
       note = Value(note),
       employeeId = Value(employeeId),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<PettyCashRow> custom({
    Expression<String>? id,
    Expression<String>? shiftId,
    Expression<int>? date,
    Expression<int>? amount,
    Expression<String>? note,
    Expression<String>? employeeId,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (date != null) 'date': date,
      if (amount != null) 'amount': amount,
      if (note != null) 'note': note,
      if (employeeId != null) 'employee_id': employeeId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PettyCashCompanion copyWith({
    Value<String>? id,
    Value<String?>? shiftId,
    Value<int>? date,
    Value<int>? amount,
    Value<String>? note,
    Value<String>? employeeId,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return PettyCashCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      employeeId: employeeId ?? this.employeeId,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PettyCashCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('date: $date, ')
          ..write('amount: $amount, ')
          ..write('note: $note, ')
          ..write('employeeId: $employeeId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OrderLinesTable extends OrderLines
    with TableInfo<$OrderLinesTable, OrderLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIdMeta = const VerificationMeta(
    'orderId',
  );
  @override
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
    'order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES orders (id)',
    ),
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES products (id)',
    ),
  );
  static const VerificationMeta _qtyMeta = const VerificationMeta('qty');
  @override
  late final GeneratedColumn<int> qty = GeneratedColumn<int>(
    'qty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<int> price = GeneratedColumn<int>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    orderId,
    productId,
    qty,
    price,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<OrderLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('order_id')) {
      context.handle(
        _orderIdMeta,
        orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('qty')) {
      context.handle(
        _qtyMeta,
        qty.isAcceptableOrUnknown(data['qty']!, _qtyMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      orderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      qty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}qty'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}price'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $OrderLinesTable createAlias(String alias) {
    return $OrderLinesTable(attachedDatabase, alias);
  }
}

class OrderLine extends DataClass implements Insertable<OrderLine> {
  final String id;
  final String orderId;
  final String productId;
  final int qty;
  final int price;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const OrderLine({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.qty,
    required this.price,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_id'] = Variable<String>(orderId);
    map['product_id'] = Variable<String>(productId);
    map['qty'] = Variable<int>(qty);
    map['price'] = Variable<int>(price);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  OrderLinesCompanion toCompanion(bool nullToAbsent) {
    return OrderLinesCompanion(
      id: Value(id),
      orderId: Value(orderId),
      productId: Value(productId),
      qty: Value(qty),
      price: Value(price),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory OrderLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderLine(
      id: serializer.fromJson<String>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      productId: serializer.fromJson<String>(json['productId']),
      qty: serializer.fromJson<int>(json['qty']),
      price: serializer.fromJson<int>(json['price']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderId': serializer.toJson<String>(orderId),
      'productId': serializer.toJson<String>(productId),
      'qty': serializer.toJson<int>(qty),
      'price': serializer.toJson<int>(price),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  OrderLine copyWith({
    String? id,
    String? orderId,
    String? productId,
    int? qty,
    int? price,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => OrderLine(
    id: id ?? this.id,
    orderId: orderId ?? this.orderId,
    productId: productId ?? this.productId,
    qty: qty ?? this.qty,
    price: price ?? this.price,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  OrderLine copyWithCompanion(OrderLinesCompanion data) {
    return OrderLine(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      productId: data.productId.present ? data.productId.value : this.productId,
      qty: data.qty.present ? data.qty.value : this.qty,
      price: data.price.present ? data.price.value : this.price,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderLine(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('price: $price, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    orderId,
    productId,
    qty,
    price,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderLine &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.productId == this.productId &&
          other.qty == this.qty &&
          other.price == this.price &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class OrderLinesCompanion extends UpdateCompanion<OrderLine> {
  final Value<String> id;
  final Value<String> orderId;
  final Value<String> productId;
  final Value<int> qty;
  final Value<int> price;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const OrderLinesCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.productId = const Value.absent(),
    this.qty = const Value.absent(),
    this.price = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrderLinesCompanion.insert({
    required String id,
    required String orderId,
    required String productId,
    required int qty,
    required int price,
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       orderId = Value(orderId),
       productId = Value(productId),
       qty = Value(qty),
       price = Value(price),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<OrderLine> custom({
    Expression<String>? id,
    Expression<String>? orderId,
    Expression<String>? productId,
    Expression<int>? qty,
    Expression<int>? price,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (productId != null) 'product_id': productId,
      if (qty != null) 'qty': qty,
      if (price != null) 'price': price,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrderLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? orderId,
    Value<String>? productId,
    Value<int>? qty,
    Value<int>? price,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return OrderLinesCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      qty: qty ?? this.qty,
      price: price ?? this.price,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (qty.present) {
      map['qty'] = Variable<int>(qty.value);
    }
    if (price.present) {
      map['price'] = Variable<int>(price.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderLinesCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('productId: $productId, ')
          ..write('qty: $qty, ')
          ..write('price: $price, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetsTable extends Assets with TableInfo<$AssetsTable, Asset> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purchaseDateMeta = const VerificationMeta(
    'purchaseDate',
  );
  @override
  late final GeneratedColumn<int> purchaseDate = GeneratedColumn<int>(
    'purchase_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costMeta = const VerificationMeta('cost');
  @override
  late final GeneratedColumn<int> cost = GeneratedColumn<int>(
    'cost',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _residualValueMeta = const VerificationMeta(
    'residualValue',
  );
  @override
  late final GeneratedColumn<int> residualValue = GeneratedColumn<int>(
    'residual_value',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usefulLifeMonthsMeta = const VerificationMeta(
    'usefulLifeMonths',
  );
  @override
  late final GeneratedColumn<int> usefulLifeMonths = GeneratedColumn<int>(
    'useful_life_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accumulatedDepreciationMeta =
      const VerificationMeta('accumulatedDepreciation');
  @override
  late final GeneratedColumn<int> accumulatedDepreciation =
      GeneratedColumn<int>(
        'accumulated_depreciation',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      );
  static const VerificationMeta _lastDepreciationMonthMeta =
      const VerificationMeta('lastDepreciationMonth');
  @override
  late final GeneratedColumn<String> lastDepreciationMonth =
      GeneratedColumn<String>(
        'last_depreciation_month',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    purchaseDate,
    cost,
    residualValue,
    usefulLifeMonths,
    accumulatedDepreciation,
    lastDepreciationMonth,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'assets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Asset> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('purchase_date')) {
      context.handle(
        _purchaseDateMeta,
        purchaseDate.isAcceptableOrUnknown(
          data['purchase_date']!,
          _purchaseDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_purchaseDateMeta);
    }
    if (data.containsKey('cost')) {
      context.handle(
        _costMeta,
        cost.isAcceptableOrUnknown(data['cost']!, _costMeta),
      );
    } else if (isInserting) {
      context.missing(_costMeta);
    }
    if (data.containsKey('residual_value')) {
      context.handle(
        _residualValueMeta,
        residualValue.isAcceptableOrUnknown(
          data['residual_value']!,
          _residualValueMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_residualValueMeta);
    }
    if (data.containsKey('useful_life_months')) {
      context.handle(
        _usefulLifeMonthsMeta,
        usefulLifeMonths.isAcceptableOrUnknown(
          data['useful_life_months']!,
          _usefulLifeMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_usefulLifeMonthsMeta);
    }
    if (data.containsKey('accumulated_depreciation')) {
      context.handle(
        _accumulatedDepreciationMeta,
        accumulatedDepreciation.isAcceptableOrUnknown(
          data['accumulated_depreciation']!,
          _accumulatedDepreciationMeta,
        ),
      );
    }
    if (data.containsKey('last_depreciation_month')) {
      context.handle(
        _lastDepreciationMonthMeta,
        lastDepreciationMonth.isAcceptableOrUnknown(
          data['last_depreciation_month']!,
          _lastDepreciationMonthMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Asset map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Asset(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      purchaseDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}purchase_date'],
      )!,
      cost: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost'],
      )!,
      residualValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}residual_value'],
      )!,
      usefulLifeMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}useful_life_months'],
      )!,
      accumulatedDepreciation: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}accumulated_depreciation'],
      )!,
      lastDepreciationMonth: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_depreciation_month'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $AssetsTable createAlias(String alias) {
    return $AssetsTable(attachedDatabase, alias);
  }
}

class Asset extends DataClass implements Insertable<Asset> {
  final String id;
  final String name;
  final int purchaseDate;
  final int cost;
  final int residualValue;
  final int usefulLifeMonths;
  final int accumulatedDepreciation;
  final String? lastDepreciationMonth;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const Asset({
    required this.id,
    required this.name,
    required this.purchaseDate,
    required this.cost,
    required this.residualValue,
    required this.usefulLifeMonths,
    required this.accumulatedDepreciation,
    this.lastDepreciationMonth,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['purchase_date'] = Variable<int>(purchaseDate);
    map['cost'] = Variable<int>(cost);
    map['residual_value'] = Variable<int>(residualValue);
    map['useful_life_months'] = Variable<int>(usefulLifeMonths);
    map['accumulated_depreciation'] = Variable<int>(accumulatedDepreciation);
    if (!nullToAbsent || lastDepreciationMonth != null) {
      map['last_depreciation_month'] = Variable<String>(lastDepreciationMonth);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  AssetsCompanion toCompanion(bool nullToAbsent) {
    return AssetsCompanion(
      id: Value(id),
      name: Value(name),
      purchaseDate: Value(purchaseDate),
      cost: Value(cost),
      residualValue: Value(residualValue),
      usefulLifeMonths: Value(usefulLifeMonths),
      accumulatedDepreciation: Value(accumulatedDepreciation),
      lastDepreciationMonth: lastDepreciationMonth == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDepreciationMonth),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory Asset.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Asset(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      purchaseDate: serializer.fromJson<int>(json['purchaseDate']),
      cost: serializer.fromJson<int>(json['cost']),
      residualValue: serializer.fromJson<int>(json['residualValue']),
      usefulLifeMonths: serializer.fromJson<int>(json['usefulLifeMonths']),
      accumulatedDepreciation: serializer.fromJson<int>(
        json['accumulatedDepreciation'],
      ),
      lastDepreciationMonth: serializer.fromJson<String?>(
        json['lastDepreciationMonth'],
      ),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'purchaseDate': serializer.toJson<int>(purchaseDate),
      'cost': serializer.toJson<int>(cost),
      'residualValue': serializer.toJson<int>(residualValue),
      'usefulLifeMonths': serializer.toJson<int>(usefulLifeMonths),
      'accumulatedDepreciation': serializer.toJson<int>(
        accumulatedDepreciation,
      ),
      'lastDepreciationMonth': serializer.toJson<String?>(
        lastDepreciationMonth,
      ),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  Asset copyWith({
    String? id,
    String? name,
    int? purchaseDate,
    int? cost,
    int? residualValue,
    int? usefulLifeMonths,
    int? accumulatedDepreciation,
    Value<String?> lastDepreciationMonth = const Value.absent(),
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => Asset(
    id: id ?? this.id,
    name: name ?? this.name,
    purchaseDate: purchaseDate ?? this.purchaseDate,
    cost: cost ?? this.cost,
    residualValue: residualValue ?? this.residualValue,
    usefulLifeMonths: usefulLifeMonths ?? this.usefulLifeMonths,
    accumulatedDepreciation:
        accumulatedDepreciation ?? this.accumulatedDepreciation,
    lastDepreciationMonth: lastDepreciationMonth.present
        ? lastDepreciationMonth.value
        : this.lastDepreciationMonth,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  Asset copyWithCompanion(AssetsCompanion data) {
    return Asset(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      purchaseDate: data.purchaseDate.present
          ? data.purchaseDate.value
          : this.purchaseDate,
      cost: data.cost.present ? data.cost.value : this.cost,
      residualValue: data.residualValue.present
          ? data.residualValue.value
          : this.residualValue,
      usefulLifeMonths: data.usefulLifeMonths.present
          ? data.usefulLifeMonths.value
          : this.usefulLifeMonths,
      accumulatedDepreciation: data.accumulatedDepreciation.present
          ? data.accumulatedDepreciation.value
          : this.accumulatedDepreciation,
      lastDepreciationMonth: data.lastDepreciationMonth.present
          ? data.lastDepreciationMonth.value
          : this.lastDepreciationMonth,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Asset(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('cost: $cost, ')
          ..write('residualValue: $residualValue, ')
          ..write('usefulLifeMonths: $usefulLifeMonths, ')
          ..write('accumulatedDepreciation: $accumulatedDepreciation, ')
          ..write('lastDepreciationMonth: $lastDepreciationMonth, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    purchaseDate,
    cost,
    residualValue,
    usefulLifeMonths,
    accumulatedDepreciation,
    lastDepreciationMonth,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Asset &&
          other.id == this.id &&
          other.name == this.name &&
          other.purchaseDate == this.purchaseDate &&
          other.cost == this.cost &&
          other.residualValue == this.residualValue &&
          other.usefulLifeMonths == this.usefulLifeMonths &&
          other.accumulatedDepreciation == this.accumulatedDepreciation &&
          other.lastDepreciationMonth == this.lastDepreciationMonth &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class AssetsCompanion extends UpdateCompanion<Asset> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> purchaseDate;
  final Value<int> cost;
  final Value<int> residualValue;
  final Value<int> usefulLifeMonths;
  final Value<int> accumulatedDepreciation;
  final Value<String?> lastDepreciationMonth;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const AssetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.purchaseDate = const Value.absent(),
    this.cost = const Value.absent(),
    this.residualValue = const Value.absent(),
    this.usefulLifeMonths = const Value.absent(),
    this.accumulatedDepreciation = const Value.absent(),
    this.lastDepreciationMonth = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetsCompanion.insert({
    required String id,
    required String name,
    required int purchaseDate,
    required int cost,
    required int residualValue,
    required int usefulLifeMonths,
    this.accumulatedDepreciation = const Value.absent(),
    this.lastDepreciationMonth = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       purchaseDate = Value(purchaseDate),
       cost = Value(cost),
       residualValue = Value(residualValue),
       usefulLifeMonths = Value(usefulLifeMonths),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Asset> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? purchaseDate,
    Expression<int>? cost,
    Expression<int>? residualValue,
    Expression<int>? usefulLifeMonths,
    Expression<int>? accumulatedDepreciation,
    Expression<String>? lastDepreciationMonth,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (purchaseDate != null) 'purchase_date': purchaseDate,
      if (cost != null) 'cost': cost,
      if (residualValue != null) 'residual_value': residualValue,
      if (usefulLifeMonths != null) 'useful_life_months': usefulLifeMonths,
      if (accumulatedDepreciation != null)
        'accumulated_depreciation': accumulatedDepreciation,
      if (lastDepreciationMonth != null)
        'last_depreciation_month': lastDepreciationMonth,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? purchaseDate,
    Value<int>? cost,
    Value<int>? residualValue,
    Value<int>? usefulLifeMonths,
    Value<int>? accumulatedDepreciation,
    Value<String?>? lastDepreciationMonth,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return AssetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      cost: cost ?? this.cost,
      residualValue: residualValue ?? this.residualValue,
      usefulLifeMonths: usefulLifeMonths ?? this.usefulLifeMonths,
      accumulatedDepreciation:
          accumulatedDepreciation ?? this.accumulatedDepreciation,
      lastDepreciationMonth:
          lastDepreciationMonth ?? this.lastDepreciationMonth,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (purchaseDate.present) {
      map['purchase_date'] = Variable<int>(purchaseDate.value);
    }
    if (cost.present) {
      map['cost'] = Variable<int>(cost.value);
    }
    if (residualValue.present) {
      map['residual_value'] = Variable<int>(residualValue.value);
    }
    if (usefulLifeMonths.present) {
      map['useful_life_months'] = Variable<int>(usefulLifeMonths.value);
    }
    if (accumulatedDepreciation.present) {
      map['accumulated_depreciation'] = Variable<int>(
        accumulatedDepreciation.value,
      );
    }
    if (lastDepreciationMonth.present) {
      map['last_depreciation_month'] = Variable<String>(
        lastDepreciationMonth.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('purchaseDate: $purchaseDate, ')
          ..write('cost: $cost, ')
          ..write('residualValue: $residualValue, ')
          ..write('usefulLifeMonths: $usefulLifeMonths, ')
          ..write('accumulatedDepreciation: $accumulatedDepreciation, ')
          ..write('lastDepreciationMonth: $lastDepreciationMonth, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses with TableInfo<$ExpensesTable, Expense> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountCodeMeta = const VerificationMeta(
    'accountCode',
  );
  @override
  late final GeneratedColumn<String> accountCode = GeneratedColumn<String>(
    'account_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (code)',
    ),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    category,
    amount,
    accountCode,
    note,
    employeeId,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<Expense> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('account_code')) {
      context.handle(
        _accountCodeMeta,
        accountCode.isAcceptableOrUnknown(
          data['account_code']!,
          _accountCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountCodeMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    } else if (isInserting) {
      context.missing(_noteMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Expense map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Expense(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      accountCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_code'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class Expense extends DataClass implements Insertable<Expense> {
  final String id;
  final int date;
  final String category;
  final int amount;
  final String accountCode;
  final String note;
  final String? employeeId;
  final int updatedAt;
  final String deviceId;
  const Expense({
    required this.id,
    required this.date,
    required this.category,
    required this.amount,
    required this.accountCode,
    required this.note,
    this.employeeId,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<int>(date);
    map['category'] = Variable<String>(category);
    map['amount'] = Variable<int>(amount);
    map['account_code'] = Variable<String>(accountCode);
    map['note'] = Variable<String>(note);
    if (!nullToAbsent || employeeId != null) {
      map['employee_id'] = Variable<String>(employeeId);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      date: Value(date),
      category: Value(category),
      amount: Value(amount),
      accountCode: Value(accountCode),
      note: Value(note),
      employeeId: employeeId == null && nullToAbsent
          ? const Value.absent()
          : Value(employeeId),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory Expense.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Expense(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      amount: serializer.fromJson<int>(json['amount']),
      accountCode: serializer.fromJson<String>(json['accountCode']),
      note: serializer.fromJson<String>(json['note']),
      employeeId: serializer.fromJson<String?>(json['employeeId']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<int>(date),
      'category': serializer.toJson<String>(category),
      'amount': serializer.toJson<int>(amount),
      'accountCode': serializer.toJson<String>(accountCode),
      'note': serializer.toJson<String>(note),
      'employeeId': serializer.toJson<String?>(employeeId),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Expense copyWith({
    String? id,
    int? date,
    String? category,
    int? amount,
    String? accountCode,
    String? note,
    Value<String?> employeeId = const Value.absent(),
    int? updatedAt,
    String? deviceId,
  }) => Expense(
    id: id ?? this.id,
    date: date ?? this.date,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    accountCode: accountCode ?? this.accountCode,
    note: note ?? this.note,
    employeeId: employeeId.present ? employeeId.value : this.employeeId,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Expense copyWithCompanion(ExpensesCompanion data) {
    return Expense(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      category: data.category.present ? data.category.value : this.category,
      amount: data.amount.present ? data.amount.value : this.amount,
      accountCode: data.accountCode.present
          ? data.accountCode.value
          : this.accountCode,
      note: data.note.present ? data.note.value : this.note,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Expense(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('accountCode: $accountCode, ')
          ..write('note: $note, ')
          ..write('employeeId: $employeeId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    category,
    amount,
    accountCode,
    note,
    employeeId,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Expense &&
          other.id == this.id &&
          other.date == this.date &&
          other.category == this.category &&
          other.amount == this.amount &&
          other.accountCode == this.accountCode &&
          other.note == this.note &&
          other.employeeId == this.employeeId &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class ExpensesCompanion extends UpdateCompanion<Expense> {
  final Value<String> id;
  final Value<int> date;
  final Value<String> category;
  final Value<int> amount;
  final Value<String> accountCode;
  final Value<String> note;
  final Value<String?> employeeId;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.amount = const Value.absent(),
    this.accountCode = const Value.absent(),
    this.note = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required int date,
    required String category,
    required int amount,
    required String accountCode,
    required String note,
    this.employeeId = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       category = Value(category),
       amount = Value(amount),
       accountCode = Value(accountCode),
       note = Value(note),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Expense> custom({
    Expression<String>? id,
    Expression<int>? date,
    Expression<String>? category,
    Expression<int>? amount,
    Expression<String>? accountCode,
    Expression<String>? note,
    Expression<String>? employeeId,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (amount != null) 'amount': amount,
      if (accountCode != null) 'account_code': accountCode,
      if (note != null) 'note': note,
      if (employeeId != null) 'employee_id': employeeId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<int>? date,
    Value<String>? category,
    Value<int>? amount,
    Value<String>? accountCode,
    Value<String>? note,
    Value<String?>? employeeId,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      accountCode: accountCode ?? this.accountCode,
      note: note ?? this.note,
      employeeId: employeeId ?? this.employeeId,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (accountCode.present) {
      map['account_code'] = Variable<String>(accountCode.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('amount: $amount, ')
          ..write('accountCode: $accountCode, ')
          ..write('note: $note, ')
          ..write('employeeId: $employeeId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AttendanceTable extends Attendance
    with TableInfo<$AttendanceTable, AttendanceRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AttendanceTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clockInMeta = const VerificationMeta(
    'clockIn',
  );
  @override
  late final GeneratedColumn<int> clockIn = GeneratedColumn<int>(
    'clock_in',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clockOutMeta = const VerificationMeta(
    'clockOut',
  );
  @override
  late final GeneratedColumn<int> clockOut = GeneratedColumn<int>(
    'clock_out',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pinVerifiedMeta = const VerificationMeta(
    'pinVerified',
  );
  @override
  late final GeneratedColumn<int> pinVerified = GeneratedColumn<int>(
    'pin_verified',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    date,
    clockIn,
    clockOut,
    pinVerified,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'attendance';
  @override
  VerificationContext validateIntegrity(
    Insertable<AttendanceRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('clock_in')) {
      context.handle(
        _clockInMeta,
        clockIn.isAcceptableOrUnknown(data['clock_in']!, _clockInMeta),
      );
    }
    if (data.containsKey('clock_out')) {
      context.handle(
        _clockOutMeta,
        clockOut.isAcceptableOrUnknown(data['clock_out']!, _clockOutMeta),
      );
    }
    if (data.containsKey('pin_verified')) {
      context.handle(
        _pinVerifiedMeta,
        pinVerified.isAcceptableOrUnknown(
          data['pin_verified']!,
          _pinVerifiedMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {employeeId, date},
  ];
  @override
  AttendanceRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AttendanceRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      clockIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clock_in'],
      ),
      clockOut: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}clock_out'],
      ),
      pinVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}pin_verified'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $AttendanceTable createAlias(String alias) {
    return $AttendanceTable(attachedDatabase, alias);
  }
}

class AttendanceRow extends DataClass implements Insertable<AttendanceRow> {
  final String id;
  final String employeeId;
  final int date;
  final int? clockIn;
  final int? clockOut;
  final int pinVerified;
  final int updatedAt;
  final String deviceId;
  const AttendanceRow({
    required this.id,
    required this.employeeId,
    required this.date,
    this.clockIn,
    this.clockOut,
    required this.pinVerified,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['date'] = Variable<int>(date);
    if (!nullToAbsent || clockIn != null) {
      map['clock_in'] = Variable<int>(clockIn);
    }
    if (!nullToAbsent || clockOut != null) {
      map['clock_out'] = Variable<int>(clockOut);
    }
    map['pin_verified'] = Variable<int>(pinVerified);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  AttendanceCompanion toCompanion(bool nullToAbsent) {
    return AttendanceCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      date: Value(date),
      clockIn: clockIn == null && nullToAbsent
          ? const Value.absent()
          : Value(clockIn),
      clockOut: clockOut == null && nullToAbsent
          ? const Value.absent()
          : Value(clockOut),
      pinVerified: Value(pinVerified),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory AttendanceRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AttendanceRow(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      date: serializer.fromJson<int>(json['date']),
      clockIn: serializer.fromJson<int?>(json['clockIn']),
      clockOut: serializer.fromJson<int?>(json['clockOut']),
      pinVerified: serializer.fromJson<int>(json['pinVerified']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'date': serializer.toJson<int>(date),
      'clockIn': serializer.toJson<int?>(clockIn),
      'clockOut': serializer.toJson<int?>(clockOut),
      'pinVerified': serializer.toJson<int>(pinVerified),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  AttendanceRow copyWith({
    String? id,
    String? employeeId,
    int? date,
    Value<int?> clockIn = const Value.absent(),
    Value<int?> clockOut = const Value.absent(),
    int? pinVerified,
    int? updatedAt,
    String? deviceId,
  }) => AttendanceRow(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    date: date ?? this.date,
    clockIn: clockIn.present ? clockIn.value : this.clockIn,
    clockOut: clockOut.present ? clockOut.value : this.clockOut,
    pinVerified: pinVerified ?? this.pinVerified,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  AttendanceRow copyWithCompanion(AttendanceCompanion data) {
    return AttendanceRow(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      date: data.date.present ? data.date.value : this.date,
      clockIn: data.clockIn.present ? data.clockIn.value : this.clockIn,
      clockOut: data.clockOut.present ? data.clockOut.value : this.clockOut,
      pinVerified: data.pinVerified.present
          ? data.pinVerified.value
          : this.pinVerified,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceRow(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('date: $date, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('pinVerified: $pinVerified, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    date,
    clockIn,
    clockOut,
    pinVerified,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AttendanceRow &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.date == this.date &&
          other.clockIn == this.clockIn &&
          other.clockOut == this.clockOut &&
          other.pinVerified == this.pinVerified &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class AttendanceCompanion extends UpdateCompanion<AttendanceRow> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<int> date;
  final Value<int?> clockIn;
  final Value<int?> clockOut;
  final Value<int> pinVerified;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const AttendanceCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.date = const Value.absent(),
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.pinVerified = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AttendanceCompanion.insert({
    required String id,
    required String employeeId,
    required int date,
    this.clockIn = const Value.absent(),
    this.clockOut = const Value.absent(),
    this.pinVerified = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       date = Value(date),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<AttendanceRow> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<int>? date,
    Expression<int>? clockIn,
    Expression<int>? clockOut,
    Expression<int>? pinVerified,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (date != null) 'date': date,
      if (clockIn != null) 'clock_in': clockIn,
      if (clockOut != null) 'clock_out': clockOut,
      if (pinVerified != null) 'pin_verified': pinVerified,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AttendanceCompanion copyWith({
    Value<String>? id,
    Value<String>? employeeId,
    Value<int>? date,
    Value<int?>? clockIn,
    Value<int?>? clockOut,
    Value<int>? pinVerified,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return AttendanceCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      clockIn: clockIn ?? this.clockIn,
      clockOut: clockOut ?? this.clockOut,
      pinVerified: pinVerified ?? this.pinVerified,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (clockIn.present) {
      map['clock_in'] = Variable<int>(clockIn.value);
    }
    if (clockOut.present) {
      map['clock_out'] = Variable<int>(clockOut.value);
    }
    if (pinVerified.present) {
      map['pin_verified'] = Variable<int>(pinVerified.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AttendanceCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('date: $date, ')
          ..write('clockIn: $clockIn, ')
          ..write('clockOut: $clockOut, ')
          ..write('pinVerified: $pinVerified, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PayrollsTable extends Payrolls with TableInfo<$PayrollsTable, Payroll> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayrollsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseSalaryMeta = const VerificationMeta(
    'baseSalary',
  );
  @override
  late final GeneratedColumn<int> baseSalary = GeneratedColumn<int>(
    'base_salary',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deductionsMeta = const VerificationMeta(
    'deductions',
  );
  @override
  late final GeneratedColumn<int> deductions = GeneratedColumn<int>(
    'deductions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netPayMeta = const VerificationMeta('netPay');
  @override
  late final GeneratedColumn<int> netPay = GeneratedColumn<int>(
    'net_pay',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _additionsMeta = const VerificationMeta(
    'additions',
  );
  @override
  late final GeneratedColumn<int> additions = GeneratedColumn<int>(
    'additions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<int> paidAt = GeneratedColumn<int>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    employeeId,
    period,
    baseSalary,
    deductions,
    netPay,
    additions,
    note,
    paidAt,
    updatedAt,
    deviceId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payrolls';
  @override
  VerificationContext validateIntegrity(
    Insertable<Payroll> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('base_salary')) {
      context.handle(
        _baseSalaryMeta,
        baseSalary.isAcceptableOrUnknown(data['base_salary']!, _baseSalaryMeta),
      );
    } else if (isInserting) {
      context.missing(_baseSalaryMeta);
    }
    if (data.containsKey('deductions')) {
      context.handle(
        _deductionsMeta,
        deductions.isAcceptableOrUnknown(data['deductions']!, _deductionsMeta),
      );
    } else if (isInserting) {
      context.missing(_deductionsMeta);
    }
    if (data.containsKey('net_pay')) {
      context.handle(
        _netPayMeta,
        netPay.isAcceptableOrUnknown(data['net_pay']!, _netPayMeta),
      );
    } else if (isInserting) {
      context.missing(_netPayMeta);
    }
    if (data.containsKey('additions')) {
      context.handle(
        _additionsMeta,
        additions.isAcceptableOrUnknown(data['additions']!, _additionsMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {employeeId, period},
  ];
  @override
  Payroll map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Payroll(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      baseSalary: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_salary'],
      )!,
      deductions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deductions'],
      )!,
      netPay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net_pay'],
      )!,
      additions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}additions'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}paid_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
    );
  }

  @override
  $PayrollsTable createAlias(String alias) {
    return $PayrollsTable(attachedDatabase, alias);
  }
}

class Payroll extends DataClass implements Insertable<Payroll> {
  final String id;
  final String employeeId;
  final String period;
  final int baseSalary;
  final int deductions;
  final int netPay;
  final int additions;
  final String? note;
  final int? paidAt;
  final int updatedAt;
  final String deviceId;
  const Payroll({
    required this.id,
    required this.employeeId,
    required this.period,
    required this.baseSalary,
    required this.deductions,
    required this.netPay,
    required this.additions,
    this.note,
    this.paidAt,
    required this.updatedAt,
    required this.deviceId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['employee_id'] = Variable<String>(employeeId);
    map['period'] = Variable<String>(period);
    map['base_salary'] = Variable<int>(baseSalary);
    map['deductions'] = Variable<int>(deductions);
    map['net_pay'] = Variable<int>(netPay);
    map['additions'] = Variable<int>(additions);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<int>(paidAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    return map;
  }

  PayrollsCompanion toCompanion(bool nullToAbsent) {
    return PayrollsCompanion(
      id: Value(id),
      employeeId: Value(employeeId),
      period: Value(period),
      baseSalary: Value(baseSalary),
      deductions: Value(deductions),
      netPay: Value(netPay),
      additions: Value(additions),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
    );
  }

  factory Payroll.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Payroll(
      id: serializer.fromJson<String>(json['id']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      period: serializer.fromJson<String>(json['period']),
      baseSalary: serializer.fromJson<int>(json['baseSalary']),
      deductions: serializer.fromJson<int>(json['deductions']),
      netPay: serializer.fromJson<int>(json['netPay']),
      additions: serializer.fromJson<int>(json['additions']),
      note: serializer.fromJson<String?>(json['note']),
      paidAt: serializer.fromJson<int?>(json['paidAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'employeeId': serializer.toJson<String>(employeeId),
      'period': serializer.toJson<String>(period),
      'baseSalary': serializer.toJson<int>(baseSalary),
      'deductions': serializer.toJson<int>(deductions),
      'netPay': serializer.toJson<int>(netPay),
      'additions': serializer.toJson<int>(additions),
      'note': serializer.toJson<String?>(note),
      'paidAt': serializer.toJson<int?>(paidAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
    };
  }

  Payroll copyWith({
    String? id,
    String? employeeId,
    String? period,
    int? baseSalary,
    int? deductions,
    int? netPay,
    int? additions,
    Value<String?> note = const Value.absent(),
    Value<int?> paidAt = const Value.absent(),
    int? updatedAt,
    String? deviceId,
  }) => Payroll(
    id: id ?? this.id,
    employeeId: employeeId ?? this.employeeId,
    period: period ?? this.period,
    baseSalary: baseSalary ?? this.baseSalary,
    deductions: deductions ?? this.deductions,
    netPay: netPay ?? this.netPay,
    additions: additions ?? this.additions,
    note: note.present ? note.value : this.note,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
  );
  Payroll copyWithCompanion(PayrollsCompanion data) {
    return Payroll(
      id: data.id.present ? data.id.value : this.id,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      period: data.period.present ? data.period.value : this.period,
      baseSalary: data.baseSalary.present
          ? data.baseSalary.value
          : this.baseSalary,
      deductions: data.deductions.present
          ? data.deductions.value
          : this.deductions,
      netPay: data.netPay.present ? data.netPay.value : this.netPay,
      additions: data.additions.present ? data.additions.value : this.additions,
      note: data.note.present ? data.note.value : this.note,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Payroll(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('period: $period, ')
          ..write('baseSalary: $baseSalary, ')
          ..write('deductions: $deductions, ')
          ..write('netPay: $netPay, ')
          ..write('additions: $additions, ')
          ..write('note: $note, ')
          ..write('paidAt: $paidAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    employeeId,
    period,
    baseSalary,
    deductions,
    netPay,
    additions,
    note,
    paidAt,
    updatedAt,
    deviceId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Payroll &&
          other.id == this.id &&
          other.employeeId == this.employeeId &&
          other.period == this.period &&
          other.baseSalary == this.baseSalary &&
          other.deductions == this.deductions &&
          other.netPay == this.netPay &&
          other.additions == this.additions &&
          other.note == this.note &&
          other.paidAt == this.paidAt &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId);
}

class PayrollsCompanion extends UpdateCompanion<Payroll> {
  final Value<String> id;
  final Value<String> employeeId;
  final Value<String> period;
  final Value<int> baseSalary;
  final Value<int> deductions;
  final Value<int> netPay;
  final Value<int> additions;
  final Value<String?> note;
  final Value<int?> paidAt;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> rowid;
  const PayrollsCompanion({
    this.id = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.period = const Value.absent(),
    this.baseSalary = const Value.absent(),
    this.deductions = const Value.absent(),
    this.netPay = const Value.absent(),
    this.additions = const Value.absent(),
    this.note = const Value.absent(),
    this.paidAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PayrollsCompanion.insert({
    required String id,
    required String employeeId,
    required String period,
    required int baseSalary,
    required int deductions,
    required int netPay,
    this.additions = const Value.absent(),
    this.note = const Value.absent(),
    this.paidAt = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       employeeId = Value(employeeId),
       period = Value(period),
       baseSalary = Value(baseSalary),
       deductions = Value(deductions),
       netPay = Value(netPay),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<Payroll> custom({
    Expression<String>? id,
    Expression<String>? employeeId,
    Expression<String>? period,
    Expression<int>? baseSalary,
    Expression<int>? deductions,
    Expression<int>? netPay,
    Expression<int>? additions,
    Expression<String>? note,
    Expression<int>? paidAt,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (employeeId != null) 'employee_id': employeeId,
      if (period != null) 'period': period,
      if (baseSalary != null) 'base_salary': baseSalary,
      if (deductions != null) 'deductions': deductions,
      if (netPay != null) 'net_pay': netPay,
      if (additions != null) 'additions': additions,
      if (note != null) 'note': note,
      if (paidAt != null) 'paid_at': paidAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PayrollsCompanion copyWith({
    Value<String>? id,
    Value<String>? employeeId,
    Value<String>? period,
    Value<int>? baseSalary,
    Value<int>? deductions,
    Value<int>? netPay,
    Value<int>? additions,
    Value<String?>? note,
    Value<int?>? paidAt,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? rowid,
  }) {
    return PayrollsCompanion(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      period: period ?? this.period,
      baseSalary: baseSalary ?? this.baseSalary,
      deductions: deductions ?? this.deductions,
      netPay: netPay ?? this.netPay,
      additions: additions ?? this.additions,
      note: note ?? this.note,
      paidAt: paidAt ?? this.paidAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (baseSalary.present) {
      map['base_salary'] = Variable<int>(baseSalary.value);
    }
    if (deductions.present) {
      map['deductions'] = Variable<int>(deductions.value);
    }
    if (netPay.present) {
      map['net_pay'] = Variable<int>(netPay.value);
    }
    if (additions.present) {
      map['additions'] = Variable<int>(additions.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<int>(paidAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayrollsCompanion(')
          ..write('id: $id, ')
          ..write('employeeId: $employeeId, ')
          ..write('period: $period, ')
          ..write('baseSalary: $baseSalary, ')
          ..write('deductions: $deductions, ')
          ..write('netPay: $netPay, ')
          ..write('additions: $additions, ')
          ..write('note: $note, ')
          ..write('paidAt: $paidAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockOpnamesTable extends StockOpnames
    with TableInfo<$StockOpnamesTable, StockOpname> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockOpnamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _employeeIdMeta = const VerificationMeta(
    'employeeId',
  );
  @override
  late final GeneratedColumn<String> employeeId = GeneratedColumn<String>(
    'employee_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES employees (id)',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    date,
    employeeId,
    status,
    note,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_opnames';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockOpname> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('employee_id')) {
      context.handle(
        _employeeIdMeta,
        employeeId.isAcceptableOrUnknown(data['employee_id']!, _employeeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_employeeIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockOpname map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockOpname(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      employeeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employee_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $StockOpnamesTable createAlias(String alias) {
    return $StockOpnamesTable(attachedDatabase, alias);
  }
}

class StockOpname extends DataClass implements Insertable<StockOpname> {
  final String id;
  final int date;
  final String employeeId;
  final String status;
  final String? note;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const StockOpname({
    required this.id,
    required this.date,
    required this.employeeId,
    required this.status,
    this.note,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<int>(date);
    map['employee_id'] = Variable<String>(employeeId);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  StockOpnamesCompanion toCompanion(bool nullToAbsent) {
    return StockOpnamesCompanion(
      id: Value(id),
      date: Value(date),
      employeeId: Value(employeeId),
      status: Value(status),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory StockOpname.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockOpname(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      employeeId: serializer.fromJson<String>(json['employeeId']),
      status: serializer.fromJson<String>(json['status']),
      note: serializer.fromJson<String?>(json['note']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<int>(date),
      'employeeId': serializer.toJson<String>(employeeId),
      'status': serializer.toJson<String>(status),
      'note': serializer.toJson<String?>(note),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  StockOpname copyWith({
    String? id,
    int? date,
    String? employeeId,
    String? status,
    Value<String?> note = const Value.absent(),
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => StockOpname(
    id: id ?? this.id,
    date: date ?? this.date,
    employeeId: employeeId ?? this.employeeId,
    status: status ?? this.status,
    note: note.present ? note.value : this.note,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  StockOpname copyWithCompanion(StockOpnamesCompanion data) {
    return StockOpname(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      employeeId: data.employeeId.present
          ? data.employeeId.value
          : this.employeeId,
      status: data.status.present ? data.status.value : this.status,
      note: data.note.present ? data.note.value : this.note,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockOpname(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('employeeId: $employeeId, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    date,
    employeeId,
    status,
    note,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockOpname &&
          other.id == this.id &&
          other.date == this.date &&
          other.employeeId == this.employeeId &&
          other.status == this.status &&
          other.note == this.note &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class StockOpnamesCompanion extends UpdateCompanion<StockOpname> {
  final Value<String> id;
  final Value<int> date;
  final Value<String> employeeId;
  final Value<String> status;
  final Value<String?> note;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const StockOpnamesCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.employeeId = const Value.absent(),
    this.status = const Value.absent(),
    this.note = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockOpnamesCompanion.insert({
    required String id,
    required int date,
    required String employeeId,
    required String status,
    this.note = const Value.absent(),
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       date = Value(date),
       employeeId = Value(employeeId),
       status = Value(status),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<StockOpname> custom({
    Expression<String>? id,
    Expression<int>? date,
    Expression<String>? employeeId,
    Expression<String>? status,
    Expression<String>? note,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (employeeId != null) 'employee_id': employeeId,
      if (status != null) 'status': status,
      if (note != null) 'note': note,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockOpnamesCompanion copyWith({
    Value<String>? id,
    Value<int>? date,
    Value<String>? employeeId,
    Value<String>? status,
    Value<String?>? note,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return StockOpnamesCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      employeeId: employeeId ?? this.employeeId,
      status: status ?? this.status,
      note: note ?? this.note,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (employeeId.present) {
      map['employee_id'] = Variable<String>(employeeId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockOpnamesCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('employeeId: $employeeId, ')
          ..write('status: $status, ')
          ..write('note: $note, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockOpnameLinesTable extends StockOpnameLines
    with TableInfo<$StockOpnameLinesTable, StockOpnameLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockOpnameLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _opnameIdMeta = const VerificationMeta(
    'opnameId',
  );
  @override
  late final GeneratedColumn<String> opnameId = GeneratedColumn<String>(
    'opname_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES stock_opnames (id)',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _systemQtyMeta = const VerificationMeta(
    'systemQty',
  );
  @override
  late final GeneratedColumn<double> systemQty = GeneratedColumn<double>(
    'system_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actualQtyMeta = const VerificationMeta(
    'actualQty',
  );
  @override
  late final GeneratedColumn<double> actualQty = GeneratedColumn<double>(
    'actual_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diffQtyMeta = const VerificationMeta(
    'diffQty',
  );
  @override
  late final GeneratedColumn<double> diffQty = GeneratedColumn<double>(
    'diff_qty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<int> isDeleted = GeneratedColumn<int>(
    '_deleted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    opnameId,
    ingredientId,
    systemQty,
    actualQty,
    diffQty,
    updatedAt,
    deviceId,
    isDeleted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_opname_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockOpnameLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('opname_id')) {
      context.handle(
        _opnameIdMeta,
        opnameId.isAcceptableOrUnknown(data['opname_id']!, _opnameIdMeta),
      );
    } else if (isInserting) {
      context.missing(_opnameIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('system_qty')) {
      context.handle(
        _systemQtyMeta,
        systemQty.isAcceptableOrUnknown(data['system_qty']!, _systemQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_systemQtyMeta);
    }
    if (data.containsKey('actual_qty')) {
      context.handle(
        _actualQtyMeta,
        actualQty.isAcceptableOrUnknown(data['actual_qty']!, _actualQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_actualQtyMeta);
    }
    if (data.containsKey('diff_qty')) {
      context.handle(
        _diffQtyMeta,
        diffQty.isAcceptableOrUnknown(data['diff_qty']!, _diffQtyMeta),
      );
    } else if (isInserting) {
      context.missing(_diffQtyMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['_deleted']!, _isDeletedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockOpnameLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockOpnameLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      opnameId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opname_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      systemQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}system_qty'],
      )!,
      actualQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}actual_qty'],
      )!,
      diffQty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}diff_qty'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}_deleted'],
      )!,
    );
  }

  @override
  $StockOpnameLinesTable createAlias(String alias) {
    return $StockOpnameLinesTable(attachedDatabase, alias);
  }
}

class StockOpnameLine extends DataClass implements Insertable<StockOpnameLine> {
  final String id;
  final String opnameId;
  final String ingredientId;
  final double systemQty;
  final double actualQty;
  final double diffQty;
  final int updatedAt;
  final String deviceId;
  final int isDeleted;
  const StockOpnameLine({
    required this.id,
    required this.opnameId,
    required this.ingredientId,
    required this.systemQty,
    required this.actualQty,
    required this.diffQty,
    required this.updatedAt,
    required this.deviceId,
    required this.isDeleted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['opname_id'] = Variable<String>(opnameId);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['system_qty'] = Variable<double>(systemQty);
    map['actual_qty'] = Variable<double>(actualQty);
    map['diff_qty'] = Variable<double>(diffQty);
    map['updated_at'] = Variable<int>(updatedAt);
    map['device_id'] = Variable<String>(deviceId);
    map['_deleted'] = Variable<int>(isDeleted);
    return map;
  }

  StockOpnameLinesCompanion toCompanion(bool nullToAbsent) {
    return StockOpnameLinesCompanion(
      id: Value(id),
      opnameId: Value(opnameId),
      ingredientId: Value(ingredientId),
      systemQty: Value(systemQty),
      actualQty: Value(actualQty),
      diffQty: Value(diffQty),
      updatedAt: Value(updatedAt),
      deviceId: Value(deviceId),
      isDeleted: Value(isDeleted),
    );
  }

  factory StockOpnameLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockOpnameLine(
      id: serializer.fromJson<String>(json['id']),
      opnameId: serializer.fromJson<String>(json['opnameId']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      systemQty: serializer.fromJson<double>(json['systemQty']),
      actualQty: serializer.fromJson<double>(json['actualQty']),
      diffQty: serializer.fromJson<double>(json['diffQty']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDeleted: serializer.fromJson<int>(json['isDeleted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'opnameId': serializer.toJson<String>(opnameId),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'systemQty': serializer.toJson<double>(systemQty),
      'actualQty': serializer.toJson<double>(actualQty),
      'diffQty': serializer.toJson<double>(diffQty),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDeleted': serializer.toJson<int>(isDeleted),
    };
  }

  StockOpnameLine copyWith({
    String? id,
    String? opnameId,
    String? ingredientId,
    double? systemQty,
    double? actualQty,
    double? diffQty,
    int? updatedAt,
    String? deviceId,
    int? isDeleted,
  }) => StockOpnameLine(
    id: id ?? this.id,
    opnameId: opnameId ?? this.opnameId,
    ingredientId: ingredientId ?? this.ingredientId,
    systemQty: systemQty ?? this.systemQty,
    actualQty: actualQty ?? this.actualQty,
    diffQty: diffQty ?? this.diffQty,
    updatedAt: updatedAt ?? this.updatedAt,
    deviceId: deviceId ?? this.deviceId,
    isDeleted: isDeleted ?? this.isDeleted,
  );
  StockOpnameLine copyWithCompanion(StockOpnameLinesCompanion data) {
    return StockOpnameLine(
      id: data.id.present ? data.id.value : this.id,
      opnameId: data.opnameId.present ? data.opnameId.value : this.opnameId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      systemQty: data.systemQty.present ? data.systemQty.value : this.systemQty,
      actualQty: data.actualQty.present ? data.actualQty.value : this.actualQty,
      diffQty: data.diffQty.present ? data.diffQty.value : this.diffQty,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockOpnameLine(')
          ..write('id: $id, ')
          ..write('opnameId: $opnameId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('systemQty: $systemQty, ')
          ..write('actualQty: $actualQty, ')
          ..write('diffQty: $diffQty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    opnameId,
    ingredientId,
    systemQty,
    actualQty,
    diffQty,
    updatedAt,
    deviceId,
    isDeleted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockOpnameLine &&
          other.id == this.id &&
          other.opnameId == this.opnameId &&
          other.ingredientId == this.ingredientId &&
          other.systemQty == this.systemQty &&
          other.actualQty == this.actualQty &&
          other.diffQty == this.diffQty &&
          other.updatedAt == this.updatedAt &&
          other.deviceId == this.deviceId &&
          other.isDeleted == this.isDeleted);
}

class StockOpnameLinesCompanion extends UpdateCompanion<StockOpnameLine> {
  final Value<String> id;
  final Value<String> opnameId;
  final Value<String> ingredientId;
  final Value<double> systemQty;
  final Value<double> actualQty;
  final Value<double> diffQty;
  final Value<int> updatedAt;
  final Value<String> deviceId;
  final Value<int> isDeleted;
  final Value<int> rowid;
  const StockOpnameLinesCompanion({
    this.id = const Value.absent(),
    this.opnameId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.systemQty = const Value.absent(),
    this.actualQty = const Value.absent(),
    this.diffQty = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockOpnameLinesCompanion.insert({
    required String id,
    required String opnameId,
    required String ingredientId,
    required double systemQty,
    required double actualQty,
    required double diffQty,
    required int updatedAt,
    required String deviceId,
    this.isDeleted = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       opnameId = Value(opnameId),
       ingredientId = Value(ingredientId),
       systemQty = Value(systemQty),
       actualQty = Value(actualQty),
       diffQty = Value(diffQty),
       updatedAt = Value(updatedAt),
       deviceId = Value(deviceId);
  static Insertable<StockOpnameLine> custom({
    Expression<String>? id,
    Expression<String>? opnameId,
    Expression<String>? ingredientId,
    Expression<double>? systemQty,
    Expression<double>? actualQty,
    Expression<double>? diffQty,
    Expression<int>? updatedAt,
    Expression<String>? deviceId,
    Expression<int>? isDeleted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (opnameId != null) 'opname_id': opnameId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (systemQty != null) 'system_qty': systemQty,
      if (actualQty != null) 'actual_qty': actualQty,
      if (diffQty != null) 'diff_qty': diffQty,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deviceId != null) 'device_id': deviceId,
      if (isDeleted != null) '_deleted': isDeleted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockOpnameLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? opnameId,
    Value<String>? ingredientId,
    Value<double>? systemQty,
    Value<double>? actualQty,
    Value<double>? diffQty,
    Value<int>? updatedAt,
    Value<String>? deviceId,
    Value<int>? isDeleted,
    Value<int>? rowid,
  }) {
    return StockOpnameLinesCompanion(
      id: id ?? this.id,
      opnameId: opnameId ?? this.opnameId,
      ingredientId: ingredientId ?? this.ingredientId,
      systemQty: systemQty ?? this.systemQty,
      actualQty: actualQty ?? this.actualQty,
      diffQty: diffQty ?? this.diffQty,
      updatedAt: updatedAt ?? this.updatedAt,
      deviceId: deviceId ?? this.deviceId,
      isDeleted: isDeleted ?? this.isDeleted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (opnameId.present) {
      map['opname_id'] = Variable<String>(opnameId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (systemQty.present) {
      map['system_qty'] = Variable<double>(systemQty.value);
    }
    if (actualQty.present) {
      map['actual_qty'] = Variable<double>(actualQty.value);
    }
    if (diffQty.present) {
      map['diff_qty'] = Variable<double>(diffQty.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDeleted.present) {
      map['_deleted'] = Variable<int>(isDeleted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockOpnameLinesCompanion(')
          ..write('id: $id, ')
          ..write('opnameId: $opnameId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('systemQty: $systemQty, ')
          ..write('actualQty: $actualQty, ')
          ..write('diffQty: $diffQty, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String id;
  final String value;
  const Setting({required this.id, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(id: Value(id), value: Value(value));
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<String>(json['id']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({String? id, String? value}) =>
      Setting(id: id ?? this.id, value: value ?? this.value);
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.id == this.id && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> id;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String id,
    required String value,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? id,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? id,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, SyncOutboxRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableMeta = const VerificationMeta('table');
  @override
  late final GeneratedColumn<String> table = GeneratedColumn<String>(
    'tableName',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    table,
    rowId,
    operation,
    payload,
    status,
    attempts,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOutboxRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tableName')) {
      context.handle(
        _tableMeta,
        table.isAcceptableOrUnknown(data['tableName']!, _tableMeta),
      );
    } else if (isInserting) {
      context.missing(_tableMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOutboxRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOutboxRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      table: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tableName'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class SyncOutboxRow extends DataClass implements Insertable<SyncOutboxRow> {
  final String id;
  final String table;
  final String rowId;
  final String operation;
  final String payload;
  final String status;
  final int attempts;
  final int createdAt;
  const SyncOutboxRow({
    required this.id,
    required this.table,
    required this.rowId,
    required this.operation,
    required this.payload,
    required this.status,
    required this.attempts,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tableName'] = Variable<String>(table);
    map['row_id'] = Variable<String>(rowId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['status'] = Variable<String>(status);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      id: Value(id),
      table: Value(table),
      rowId: Value(rowId),
      operation: Value(operation),
      payload: Value(payload),
      status: Value(status),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOutboxRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOutboxRow(
      id: serializer.fromJson<String>(json['id']),
      table: serializer.fromJson<String>(json['table']),
      rowId: serializer.fromJson<String>(json['rowId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      status: serializer.fromJson<String>(json['status']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'table': serializer.toJson<String>(table),
      'rowId': serializer.toJson<String>(rowId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'status': serializer.toJson<String>(status),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  SyncOutboxRow copyWith({
    String? id,
    String? table,
    String? rowId,
    String? operation,
    String? payload,
    String? status,
    int? attempts,
    int? createdAt,
  }) => SyncOutboxRow(
    id: id ?? this.id,
    table: table ?? this.table,
    rowId: rowId ?? this.rowId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    status: status ?? this.status,
    attempts: attempts ?? this.attempts,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncOutboxRow copyWithCompanion(SyncOutboxCompanion data) {
    return SyncOutboxRow(
      id: data.id.present ? data.id.value : this.id,
      table: data.table.present ? data.table.value : this.table,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      status: data.status.present ? data.status.value : this.status,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxRow(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('rowId: $rowId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    table,
    rowId,
    operation,
    payload,
    status,
    attempts,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOutboxRow &&
          other.id == this.id &&
          other.table == this.table &&
          other.rowId == this.rowId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.status == this.status &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt);
}

class SyncOutboxCompanion extends UpdateCompanion<SyncOutboxRow> {
  final Value<String> id;
  final Value<String> table;
  final Value<String> rowId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<String> status;
  final Value<int> attempts;
  final Value<int> createdAt;
  final Value<int> rowid;
  const SyncOutboxCompanion({
    this.id = const Value.absent(),
    this.table = const Value.absent(),
    this.rowId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.status = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    required String id,
    required String table,
    required String rowId,
    required String operation,
    required String payload,
    required String status,
    this.attempts = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       table = Value(table),
       rowId = Value(rowId),
       operation = Value(operation),
       payload = Value(payload),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<SyncOutboxRow> custom({
    Expression<String>? id,
    Expression<String>? table,
    Expression<String>? rowId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<String>? status,
    Expression<int>? attempts,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (table != null) 'tableName': table,
      if (rowId != null) 'row_id': rowId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (status != null) 'status': status,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? table,
    Value<String>? rowId,
    Value<String>? operation,
    Value<String>? payload,
    Value<String>? status,
    Value<int>? attempts,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return SyncOutboxCompanion(
      id: id ?? this.id,
      table: table ?? this.table,
      rowId: rowId ?? this.rowId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (table.present) {
      map['tableName'] = Variable<String>(table.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('rowId: $rowId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('status: $status, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastPulledAtMeta = const VerificationMeta(
    'lastPulledAt',
  );
  @override
  late final GeneratedColumn<int> lastPulledAt = GeneratedColumn<int>(
    'last_pulled_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, lastPulledAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('last_pulled_at')) {
      context.handle(
        _lastPulledAtMeta,
        lastPulledAt.isAcceptableOrUnknown(
          data['last_pulled_at']!,
          _lastPulledAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastPulledAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lastPulledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_pulled_at'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateRow extends DataClass implements Insertable<SyncStateRow> {
  final String id;
  final int lastPulledAt;
  const SyncStateRow({required this.id, required this.lastPulledAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['last_pulled_at'] = Variable<int>(lastPulledAt);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(id: Value(id), lastPulledAt: Value(lastPulledAt));
  }

  factory SyncStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateRow(
      id: serializer.fromJson<String>(json['id']),
      lastPulledAt: serializer.fromJson<int>(json['lastPulledAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lastPulledAt': serializer.toJson<int>(lastPulledAt),
    };
  }

  SyncStateRow copyWith({String? id, int? lastPulledAt}) => SyncStateRow(
    id: id ?? this.id,
    lastPulledAt: lastPulledAt ?? this.lastPulledAt,
  );
  SyncStateRow copyWithCompanion(SyncStateCompanion data) {
    return SyncStateRow(
      id: data.id.present ? data.id.value : this.id,
      lastPulledAt: data.lastPulledAt.present
          ? data.lastPulledAt.value
          : this.lastPulledAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateRow(')
          ..write('id: $id, ')
          ..write('lastPulledAt: $lastPulledAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastPulledAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateRow &&
          other.id == this.id &&
          other.lastPulledAt == this.lastPulledAt);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateRow> {
  final Value<String> id;
  final Value<int> lastPulledAt;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.id = const Value.absent(),
    this.lastPulledAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String id,
    required int lastPulledAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lastPulledAt = Value(lastPulledAt);
  static Insertable<SyncStateRow> custom({
    Expression<String>? id,
    Expression<int>? lastPulledAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastPulledAt != null) 'last_pulled_at': lastPulledAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? id,
    Value<int>? lastPulledAt,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      id: id ?? this.id,
      lastPulledAt: lastPulledAt ?? this.lastPulledAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lastPulledAt.present) {
      map['last_pulled_at'] = Variable<int>(lastPulledAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('id: $id, ')
          ..write('lastPulledAt: $lastPulledAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncConflictsTable extends SyncConflicts
    with TableInfo<$SyncConflictsTable, SyncConflictRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncConflictsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tableMeta = const VerificationMeta('table');
  @override
  late final GeneratedColumn<String> table = GeneratedColumn<String>(
    'tableName',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rowIdMeta = const VerificationMeta('rowId');
  @override
  late final GeneratedColumn<String> rowId = GeneratedColumn<String>(
    'row_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localUpdatedAtMeta = const VerificationMeta(
    'localUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> localUpdatedAt = GeneratedColumn<int>(
    'local_updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteUpdatedAtMeta = const VerificationMeta(
    'remoteUpdatedAt',
  );
  @override
  late final GeneratedColumn<int> remoteUpdatedAt = GeneratedColumn<int>(
    'remote_updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _localDeviceIdMeta = const VerificationMeta(
    'localDeviceId',
  );
  @override
  late final GeneratedColumn<String> localDeviceId = GeneratedColumn<String>(
    'local_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remoteDeviceIdMeta = const VerificationMeta(
    'remoteDeviceId',
  );
  @override
  late final GeneratedColumn<String> remoteDeviceId = GeneratedColumn<String>(
    'remote_device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    table,
    rowId,
    localUpdatedAt,
    remoteUpdatedAt,
    localDeviceId,
    remoteDeviceId,
    reason,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_conflicts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncConflictRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('tableName')) {
      context.handle(
        _tableMeta,
        table.isAcceptableOrUnknown(data['tableName']!, _tableMeta),
      );
    } else if (isInserting) {
      context.missing(_tableMeta);
    }
    if (data.containsKey('row_id')) {
      context.handle(
        _rowIdMeta,
        rowId.isAcceptableOrUnknown(data['row_id']!, _rowIdMeta),
      );
    } else if (isInserting) {
      context.missing(_rowIdMeta);
    }
    if (data.containsKey('local_updated_at')) {
      context.handle(
        _localUpdatedAtMeta,
        localUpdatedAt.isAcceptableOrUnknown(
          data['local_updated_at']!,
          _localUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localUpdatedAtMeta);
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
        _remoteUpdatedAtMeta,
        remoteUpdatedAt.isAcceptableOrUnknown(
          data['remote_updated_at']!,
          _remoteUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remoteUpdatedAtMeta);
    }
    if (data.containsKey('local_device_id')) {
      context.handle(
        _localDeviceIdMeta,
        localDeviceId.isAcceptableOrUnknown(
          data['local_device_id']!,
          _localDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_localDeviceIdMeta);
    }
    if (data.containsKey('remote_device_id')) {
      context.handle(
        _remoteDeviceIdMeta,
        remoteDeviceId.isAcceptableOrUnknown(
          data['remote_device_id']!,
          _remoteDeviceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remoteDeviceIdMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncConflictRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncConflictRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      table: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tableName'],
      )!,
      rowId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}row_id'],
      )!,
      localUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}local_updated_at'],
      )!,
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remote_updated_at'],
      )!,
      localDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}local_device_id'],
      )!,
      remoteDeviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remote_device_id'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncConflictsTable createAlias(String alias) {
    return $SyncConflictsTable(attachedDatabase, alias);
  }
}

class SyncConflictRow extends DataClass implements Insertable<SyncConflictRow> {
  final String id;
  final String table;
  final String rowId;
  final int localUpdatedAt;
  final int remoteUpdatedAt;
  final String localDeviceId;
  final String remoteDeviceId;
  final String reason;
  final int createdAt;
  const SyncConflictRow({
    required this.id,
    required this.table,
    required this.rowId,
    required this.localUpdatedAt,
    required this.remoteUpdatedAt,
    required this.localDeviceId,
    required this.remoteDeviceId,
    required this.reason,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['tableName'] = Variable<String>(table);
    map['row_id'] = Variable<String>(rowId);
    map['local_updated_at'] = Variable<int>(localUpdatedAt);
    map['remote_updated_at'] = Variable<int>(remoteUpdatedAt);
    map['local_device_id'] = Variable<String>(localDeviceId);
    map['remote_device_id'] = Variable<String>(remoteDeviceId);
    map['reason'] = Variable<String>(reason);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SyncConflictsCompanion toCompanion(bool nullToAbsent) {
    return SyncConflictsCompanion(
      id: Value(id),
      table: Value(table),
      rowId: Value(rowId),
      localUpdatedAt: Value(localUpdatedAt),
      remoteUpdatedAt: Value(remoteUpdatedAt),
      localDeviceId: Value(localDeviceId),
      remoteDeviceId: Value(remoteDeviceId),
      reason: Value(reason),
      createdAt: Value(createdAt),
    );
  }

  factory SyncConflictRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncConflictRow(
      id: serializer.fromJson<String>(json['id']),
      table: serializer.fromJson<String>(json['table']),
      rowId: serializer.fromJson<String>(json['rowId']),
      localUpdatedAt: serializer.fromJson<int>(json['localUpdatedAt']),
      remoteUpdatedAt: serializer.fromJson<int>(json['remoteUpdatedAt']),
      localDeviceId: serializer.fromJson<String>(json['localDeviceId']),
      remoteDeviceId: serializer.fromJson<String>(json['remoteDeviceId']),
      reason: serializer.fromJson<String>(json['reason']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'table': serializer.toJson<String>(table),
      'rowId': serializer.toJson<String>(rowId),
      'localUpdatedAt': serializer.toJson<int>(localUpdatedAt),
      'remoteUpdatedAt': serializer.toJson<int>(remoteUpdatedAt),
      'localDeviceId': serializer.toJson<String>(localDeviceId),
      'remoteDeviceId': serializer.toJson<String>(remoteDeviceId),
      'reason': serializer.toJson<String>(reason),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  SyncConflictRow copyWith({
    String? id,
    String? table,
    String? rowId,
    int? localUpdatedAt,
    int? remoteUpdatedAt,
    String? localDeviceId,
    String? remoteDeviceId,
    String? reason,
    int? createdAt,
  }) => SyncConflictRow(
    id: id ?? this.id,
    table: table ?? this.table,
    rowId: rowId ?? this.rowId,
    localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
    remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
    localDeviceId: localDeviceId ?? this.localDeviceId,
    remoteDeviceId: remoteDeviceId ?? this.remoteDeviceId,
    reason: reason ?? this.reason,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncConflictRow copyWithCompanion(SyncConflictsCompanion data) {
    return SyncConflictRow(
      id: data.id.present ? data.id.value : this.id,
      table: data.table.present ? data.table.value : this.table,
      rowId: data.rowId.present ? data.rowId.value : this.rowId,
      localUpdatedAt: data.localUpdatedAt.present
          ? data.localUpdatedAt.value
          : this.localUpdatedAt,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      localDeviceId: data.localDeviceId.present
          ? data.localDeviceId.value
          : this.localDeviceId,
      remoteDeviceId: data.remoteDeviceId.present
          ? data.remoteDeviceId.value
          : this.remoteDeviceId,
      reason: data.reason.present ? data.reason.value : this.reason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictRow(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('rowId: $rowId, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('localDeviceId: $localDeviceId, ')
          ..write('remoteDeviceId: $remoteDeviceId, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    table,
    rowId,
    localUpdatedAt,
    remoteUpdatedAt,
    localDeviceId,
    remoteDeviceId,
    reason,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncConflictRow &&
          other.id == this.id &&
          other.table == this.table &&
          other.rowId == this.rowId &&
          other.localUpdatedAt == this.localUpdatedAt &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.localDeviceId == this.localDeviceId &&
          other.remoteDeviceId == this.remoteDeviceId &&
          other.reason == this.reason &&
          other.createdAt == this.createdAt);
}

class SyncConflictsCompanion extends UpdateCompanion<SyncConflictRow> {
  final Value<String> id;
  final Value<String> table;
  final Value<String> rowId;
  final Value<int> localUpdatedAt;
  final Value<int> remoteUpdatedAt;
  final Value<String> localDeviceId;
  final Value<String> remoteDeviceId;
  final Value<String> reason;
  final Value<int> createdAt;
  final Value<int> rowid;
  const SyncConflictsCompanion({
    this.id = const Value.absent(),
    this.table = const Value.absent(),
    this.rowId = const Value.absent(),
    this.localUpdatedAt = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.localDeviceId = const Value.absent(),
    this.remoteDeviceId = const Value.absent(),
    this.reason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncConflictsCompanion.insert({
    required String id,
    required String table,
    required String rowId,
    required int localUpdatedAt,
    required int remoteUpdatedAt,
    required String localDeviceId,
    required String remoteDeviceId,
    required String reason,
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       table = Value(table),
       rowId = Value(rowId),
       localUpdatedAt = Value(localUpdatedAt),
       remoteUpdatedAt = Value(remoteUpdatedAt),
       localDeviceId = Value(localDeviceId),
       remoteDeviceId = Value(remoteDeviceId),
       reason = Value(reason),
       createdAt = Value(createdAt);
  static Insertable<SyncConflictRow> custom({
    Expression<String>? id,
    Expression<String>? table,
    Expression<String>? rowId,
    Expression<int>? localUpdatedAt,
    Expression<int>? remoteUpdatedAt,
    Expression<String>? localDeviceId,
    Expression<String>? remoteDeviceId,
    Expression<String>? reason,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (table != null) 'tableName': table,
      if (rowId != null) 'row_id': rowId,
      if (localUpdatedAt != null) 'local_updated_at': localUpdatedAt,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (localDeviceId != null) 'local_device_id': localDeviceId,
      if (remoteDeviceId != null) 'remote_device_id': remoteDeviceId,
      if (reason != null) 'reason': reason,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncConflictsCompanion copyWith({
    Value<String>? id,
    Value<String>? table,
    Value<String>? rowId,
    Value<int>? localUpdatedAt,
    Value<int>? remoteUpdatedAt,
    Value<String>? localDeviceId,
    Value<String>? remoteDeviceId,
    Value<String>? reason,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return SyncConflictsCompanion(
      id: id ?? this.id,
      table: table ?? this.table,
      rowId: rowId ?? this.rowId,
      localUpdatedAt: localUpdatedAt ?? this.localUpdatedAt,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      localDeviceId: localDeviceId ?? this.localDeviceId,
      remoteDeviceId: remoteDeviceId ?? this.remoteDeviceId,
      reason: reason ?? this.reason,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (table.present) {
      map['tableName'] = Variable<String>(table.value);
    }
    if (rowId.present) {
      map['row_id'] = Variable<String>(rowId.value);
    }
    if (localUpdatedAt.present) {
      map['local_updated_at'] = Variable<int>(localUpdatedAt.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<int>(remoteUpdatedAt.value);
    }
    if (localDeviceId.present) {
      map['local_device_id'] = Variable<String>(localDeviceId.value);
    }
    if (remoteDeviceId.present) {
      map['remote_device_id'] = Variable<String>(remoteDeviceId.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncConflictsCompanion(')
          ..write('id: $id, ')
          ..write('table: $table, ')
          ..write('rowId: $rowId, ')
          ..write('localUpdatedAt: $localUpdatedAt, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('localDeviceId: $localDeviceId, ')
          ..write('remoteDeviceId: $remoteDeviceId, ')
          ..write('reason: $reason, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $CustomersTable customers = $CustomersTable(this);
  late final $PromosTable promos = $PromosTable(this);
  late final $EmployeesTable employees = $EmployeesTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $ShopTablesTable shopTables = $ShopTablesTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleLinesTable saleLines = $SaleLinesTable(this);
  late final $SalePaymentsTable salePayments = $SalePaymentsTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeLinesTable recipeLines = $RecipeLinesTable(this);
  late final $StockMovesTable stockMoves = $StockMovesTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $JournalsTable journals = $JournalsTable(this);
  late final $JournalLinesTable journalLines = $JournalLinesTable(this);
  late final $PettyCashTable pettyCash = $PettyCashTable(this);
  late final $OrderLinesTable orderLines = $OrderLinesTable(this);
  late final $AssetsTable assets = $AssetsTable(this);
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $AttendanceTable attendance = $AttendanceTable(this);
  late final $PayrollsTable payrolls = $PayrollsTable(this);
  late final $StockOpnamesTable stockOpnames = $StockOpnamesTable(this);
  late final $StockOpnameLinesTable stockOpnameLines = $StockOpnameLinesTable(
    this,
  );
  late final $SettingsTable settings = $SettingsTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $SyncConflictsTable syncConflicts = $SyncConflictsTable(this);
  late final Index idxProductsCategory = Index(
    'idx_products_category',
    'CREATE INDEX idx_products_category ON products (category)',
  );
  late final Index idxProductsName = Index(
    'idx_products_name',
    'CREATE INDEX idx_products_name ON products (name)',
  );
  late final Index idxCustomersName = Index(
    'idx_customers_name',
    'CREATE INDEX idx_customers_name ON customers (name)',
  );
  late final Index idxSalesDate = Index(
    'idx_sales_date',
    'CREATE INDEX idx_sales_date ON sales (date)',
  );
  late final Index idxSalesCode = Index(
    'idx_sales_code',
    'CREATE INDEX idx_sales_code ON sales (code)',
  );
  late final Index idxSaleLinesSale = Index(
    'idx_sale_lines_sale',
    'CREATE INDEX idx_sale_lines_sale ON sale_lines (sale_id)',
  );
  late final Index idxSalePaymentsSale = Index(
    'idx_sale_payments_sale',
    'CREATE INDEX idx_sale_payments_sale ON sale_payments (sale_id)',
  );
  late final Index idxIngredientsName = Index(
    'idx_ingredients_name',
    'CREATE INDEX idx_ingredients_name ON ingredients (name)',
  );
  late final Index idxRecipeLinesRecipe = Index(
    'idx_recipe_lines_recipe',
    'CREATE INDEX idx_recipe_lines_recipe ON recipe_lines (recipe_id)',
  );
  late final Index idxStockMovesIngredient = Index(
    'idx_stock_moves_ingredient',
    'CREATE INDEX idx_stock_moves_ingredient ON stock_moves (ingredient_id)',
  );
  late final Index idxStockMovesDate = Index(
    'idx_stock_moves_date',
    'CREATE INDEX idx_stock_moves_date ON stock_moves (date)',
  );
  late final Index idxStockMovesRef = Index(
    'idx_stock_moves_ref',
    'CREATE INDEX idx_stock_moves_ref ON stock_moves (ref_type, ref_id)',
  );
  late final Index idxJournalsDate = Index(
    'idx_journals_date',
    'CREATE INDEX idx_journals_date ON journals (date)',
  );
  late final Index idxJournalsRef = Index(
    'idx_journals_ref',
    'CREATE INDEX idx_journals_ref ON journals (ref_type, ref_id)',
  );
  late final Index idxJournalLinesJournal = Index(
    'idx_journal_lines_journal',
    'CREATE INDEX idx_journal_lines_journal ON journal_lines (journal_id)',
  );
  late final Index idxJournalLinesAccount = Index(
    'idx_journal_lines_account',
    'CREATE INDEX idx_journal_lines_account ON journal_lines (account_code)',
  );
  late final Index idxOrderLinesOrder = Index(
    'idx_order_lines_order',
    'CREATE INDEX idx_order_lines_order ON order_lines (order_id)',
  );
  late final Index idxExpensesDate = Index(
    'idx_expenses_date',
    'CREATE INDEX idx_expenses_date ON expenses (date)',
  );
  late final Index idxOpnameLinesOpname = Index(
    'idx_opname_lines_opname',
    'CREATE INDEX idx_opname_lines_opname ON stock_opname_lines (opname_id)',
  );
  late final Index idxOutboxStatus = Index(
    'idx_outbox_status',
    'CREATE INDEX idx_outbox_status ON sync_outbox (status)',
  );
  late final Index idxOutboxCreated = Index(
    'idx_outbox_created',
    'CREATE INDEX idx_outbox_created ON sync_outbox (created_at)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    products,
    customers,
    promos,
    employees,
    shifts,
    shopTables,
    orders,
    sales,
    saleLines,
    salePayments,
    ingredients,
    recipes,
    recipeLines,
    stockMoves,
    accounts,
    journals,
    journalLines,
    pettyCash,
    orderLines,
    assets,
    expenses,
    attendance,
    payrolls,
    stockOpnames,
    stockOpnameLines,
    settings,
    syncOutbox,
    syncState,
    syncConflicts,
    idxProductsCategory,
    idxProductsName,
    idxCustomersName,
    idxSalesDate,
    idxSalesCode,
    idxSaleLinesSale,
    idxSalePaymentsSale,
    idxIngredientsName,
    idxRecipeLinesRecipe,
    idxStockMovesIngredient,
    idxStockMovesDate,
    idxStockMovesRef,
    idxJournalsDate,
    idxJournalsRef,
    idxJournalLinesJournal,
    idxJournalLinesAccount,
    idxOrderLinesOrder,
    idxExpensesDate,
    idxOpnameLinesOpname,
    idxOutboxStatus,
    idxOutboxCreated,
  ];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String name,
      required String category,
      required int price,
      required int cost,
      Value<int> stock,
      Value<String?> barcode,
      Value<int> isActive,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> category,
      Value<int> price,
      Value<int> cost,
      Value<int> stock,
      Value<String?> barcode,
      Value<int> isActive,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$ProductsTableReferences
    extends BaseReferences<_$AppDatabase, $ProductsTable, Product> {
  $$ProductsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SaleLinesTable, List<SaleLine>>
  _saleLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleLines,
    aliasName: $_aliasNameGenerator(db.products.id, db.saleLines.productId),
  );

  $$SaleLinesTableProcessedTableManager get saleLinesRefs {
    final manager = $$SaleLinesTableTableManager(
      $_db,
      $_db.saleLines,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipesTable, List<Recipe>> _recipesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.recipes,
    aliasName: $_aliasNameGenerator(db.products.id, db.recipes.productId),
  );

  $$RecipesTableProcessedTableManager get recipesRefs {
    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderLinesTable, List<OrderLine>>
  _orderLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderLines,
    aliasName: $_aliasNameGenerator(db.products.id, db.orderLines.productId),
  );

  $$OrderLinesTableProcessedTableManager get orderLinesRefs {
    final manager = $$OrderLinesTableTableManager(
      $_db,
      $_db.orderLines,
    ).filter((f) => f.productId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> saleLinesRefs(
    Expression<bool> Function($$SaleLinesTableFilterComposer f) f,
  ) {
    final $$SaleLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableFilterComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipesRefs(
    Expression<bool> Function($$RecipesTableFilterComposer f) f,
  ) {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderLinesRefs(
    Expression<bool> Function($$OrderLinesTableFilterComposer f) f,
  ) {
    final $$OrderLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableFilterComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> saleLinesRefs<T extends Object>(
    Expression<T> Function($$SaleLinesTableAnnotationComposer a) f,
  ) {
    final $$SaleLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recipesRefs<T extends Object>(
    Expression<T> Function($$RecipesTableAnnotationComposer a) f,
  ) {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderLinesRefs<T extends Object>(
    Expression<T> Function($$OrderLinesTableAnnotationComposer a) f,
  ) {
    final $$OrderLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.productId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          Product,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (Product, $$ProductsTableReferences),
          Product,
          PrefetchHooks Function({
            bool saleLinesRefs,
            bool recipesRefs,
            bool orderLinesRefs,
          })
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                name: name,
                category: category,
                price: price,
                cost: cost,
                stock: stock,
                barcode: barcode,
                isActive: isActive,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String category,
                required int price,
                required int cost,
                Value<int> stock = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                name: name,
                category: category,
                price: price,
                cost: cost,
                stock: stock,
                barcode: barcode,
                isActive: isActive,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProductsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                saleLinesRefs = false,
                recipesRefs = false,
                orderLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (saleLinesRefs) db.saleLines,
                    if (recipesRefs) db.recipes,
                    if (orderLinesRefs) db.orderLines,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (saleLinesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          SaleLine
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._saleLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).saleLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          Recipe
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._recipesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderLinesRefs)
                        await $_getPrefetchedData<
                          Product,
                          $ProductsTable,
                          OrderLine
                        >(
                          currentTable: table,
                          referencedTable: $$ProductsTableReferences
                              ._orderLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProductsTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.productId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      Product,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (Product, $$ProductsTableReferences),
      Product,
      PrefetchHooks Function({
        bool saleLinesRefs,
        bool recipesRefs,
        bool orderLinesRefs,
      })
    >;
typedef $$CustomersTableCreateCompanionBuilder =
    CustomersCompanion Function({
      required String id,
      required String name,
      Value<String?> phone,
      Value<int> points,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$CustomersTableUpdateCompanionBuilder =
    CustomersCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> phone,
      Value<int> points,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$CustomersTableReferences
    extends BaseReferences<_$AppDatabase, $CustomersTable, Customer> {
  $$CustomersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: $_aliasNameGenerator(db.customers.id, db.sales.customerId),
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.customerId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomersTableFilterComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get points => $composableBuilder(
    column: $table.points,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomersTable> {
  $$CustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<int> get points =>
      $composableBuilder(column: $table.points, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.customerId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomersTable,
          Customer,
          $$CustomersTableFilterComposer,
          $$CustomersTableOrderingComposer,
          $$CustomersTableAnnotationComposer,
          $$CustomersTableCreateCompanionBuilder,
          $$CustomersTableUpdateCompanionBuilder,
          (Customer, $$CustomersTableReferences),
          Customer,
          PrefetchHooks Function({bool salesRefs})
        > {
  $$CustomersTableTableManager(_$AppDatabase db, $CustomersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<int> points = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion(
                id: id,
                name: name,
                phone: phone,
                points: points,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> phone = const Value.absent(),
                Value<int> points = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomersCompanion.insert(
                id: id,
                name: name,
                phone: phone,
                points: points,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({salesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (salesRefs) db.sales],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (salesRefs)
                    await $_getPrefetchedData<Customer, $CustomersTable, Sale>(
                      currentTable: table,
                      referencedTable: $$CustomersTableReferences
                          ._salesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomersTableReferences(db, table, p0).salesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.customerId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomersTable,
      Customer,
      $$CustomersTableFilterComposer,
      $$CustomersTableOrderingComposer,
      $$CustomersTableAnnotationComposer,
      $$CustomersTableCreateCompanionBuilder,
      $$CustomersTableUpdateCompanionBuilder,
      (Customer, $$CustomersTableReferences),
      Customer,
      PrefetchHooks Function({bool salesRefs})
    >;
typedef $$PromosTableCreateCompanionBuilder =
    PromosCompanion Function({
      required String id,
      required String code,
      required String type,
      required int value,
      Value<int> isActive,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$PromosTableUpdateCompanionBuilder =
    PromosCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> type,
      Value<int> value,
      Value<int> isActive,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

class $$PromosTableFilterComposer
    extends Composer<_$AppDatabase, $PromosTable> {
  $$PromosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PromosTableOrderingComposer
    extends Composer<_$AppDatabase, $PromosTable> {
  $$PromosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PromosTableAnnotationComposer
    extends Composer<_$AppDatabase, $PromosTable> {
  $$PromosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$PromosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PromosTable,
          Promo,
          $$PromosTableFilterComposer,
          $$PromosTableOrderingComposer,
          $$PromosTableAnnotationComposer,
          $$PromosTableCreateCompanionBuilder,
          $$PromosTableUpdateCompanionBuilder,
          (Promo, BaseReferences<_$AppDatabase, $PromosTable, Promo>),
          Promo,
          PrefetchHooks Function()
        > {
  $$PromosTableTableManager(_$AppDatabase db, $PromosTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PromosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PromosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PromosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> value = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PromosCompanion(
                id: id,
                code: code,
                type: type,
                value: value,
                isActive: isActive,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String type,
                required int value,
                Value<int> isActive = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PromosCompanion.insert(
                id: id,
                code: code,
                type: type,
                value: value,
                isActive: isActive,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PromosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PromosTable,
      Promo,
      $$PromosTableFilterComposer,
      $$PromosTableOrderingComposer,
      $$PromosTableAnnotationComposer,
      $$PromosTableCreateCompanionBuilder,
      $$PromosTableUpdateCompanionBuilder,
      (Promo, BaseReferences<_$AppDatabase, $PromosTable, Promo>),
      Promo,
      PrefetchHooks Function()
    >;
typedef $$EmployeesTableCreateCompanionBuilder =
    EmployeesCompanion Function({
      required String id,
      required String name,
      required String role,
      required String pinHash,
      Value<int> isActive,
      Value<String> salaryType,
      Value<int> baseSalary,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$EmployeesTableUpdateCompanionBuilder =
    EmployeesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> role,
      Value<String> pinHash,
      Value<int> isActive,
      Value<String> salaryType,
      Value<int> baseSalary,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$EmployeesTableReferences
    extends BaseReferences<_$AppDatabase, $EmployeesTable, Employee> {
  $$EmployeesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ShiftsTable, List<Shift>> _shiftsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.shifts,
    aliasName: $_aliasNameGenerator(db.employees.id, db.shifts.employeeId),
  );

  $$ShiftsTableProcessedTableManager get shiftsRefs {
    final manager = $$ShiftsTableTableManager(
      $_db,
      $_db.shifts,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_shiftsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: $_aliasNameGenerator(db.employees.id, db.sales.employeeId),
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PettyCashTable, List<PettyCashRow>>
  _pettyCashRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pettyCash,
    aliasName: $_aliasNameGenerator(db.employees.id, db.pettyCash.employeeId),
  );

  $$PettyCashTableProcessedTableManager get pettyCashRefs {
    final manager = $$PettyCashTableTableManager(
      $_db,
      $_db.pettyCash,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pettyCashRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(db.employees.id, db.expenses.employeeId),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AttendanceTable, List<AttendanceRow>>
  _attendanceRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.attendance,
    aliasName: $_aliasNameGenerator(db.employees.id, db.attendance.employeeId),
  );

  $$AttendanceTableProcessedTableManager get attendanceRefs {
    final manager = $$AttendanceTableTableManager(
      $_db,
      $_db.attendance,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_attendanceRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PayrollsTable, List<Payroll>> _payrollsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.payrolls,
    aliasName: $_aliasNameGenerator(db.employees.id, db.payrolls.employeeId),
  );

  $$PayrollsTableProcessedTableManager get payrollsRefs {
    final manager = $$PayrollsTableTableManager(
      $_db,
      $_db.payrolls,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_payrollsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockOpnamesTable, List<StockOpname>>
  _stockOpnamesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockOpnames,
    aliasName: $_aliasNameGenerator(
      db.employees.id,
      db.stockOpnames.employeeId,
    ),
  );

  $$StockOpnamesTableProcessedTableManager get stockOpnamesRefs {
    final manager = $$StockOpnamesTableTableManager(
      $_db,
      $_db.stockOpnames,
    ).filter((f) => f.employeeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockOpnamesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$EmployeesTableFilterComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salaryType => $composableBuilder(
    column: $table.salaryType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseSalary => $composableBuilder(
    column: $table.baseSalary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> shiftsRefs(
    Expression<bool> Function($$ShiftsTableFilterComposer f) f,
  ) {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shifts,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftsTableFilterComposer(
            $db: $db,
            $table: $db.shifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pettyCashRefs(
    Expression<bool> Function($$PettyCashTableFilterComposer f) f,
  ) {
    final $$PettyCashTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pettyCash,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PettyCashTableFilterComposer(
            $db: $db,
            $table: $db.pettyCash,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> attendanceRefs(
    Expression<bool> Function($$AttendanceTableFilterComposer f) f,
  ) {
    final $$AttendanceTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableFilterComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> payrollsRefs(
    Expression<bool> Function($$PayrollsTableFilterComposer f) f,
  ) {
    final $$PayrollsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payrolls,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayrollsTableFilterComposer(
            $db: $db,
            $table: $db.payrolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockOpnamesRefs(
    Expression<bool> Function($$StockOpnamesTableFilterComposer f) f,
  ) {
    final $$StockOpnamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockOpnames,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnamesTableFilterComposer(
            $db: $db,
            $table: $db.stockOpnames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableOrderingComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salaryType => $composableBuilder(
    column: $table.salaryType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseSalary => $composableBuilder(
    column: $table.baseSalary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmployeesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmployeesTable> {
  $$EmployeesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<int> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<String> get salaryType => $composableBuilder(
    column: $table.salaryType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseSalary => $composableBuilder(
    column: $table.baseSalary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> shiftsRefs<T extends Object>(
    Expression<T> Function($$ShiftsTableAnnotationComposer a) f,
  ) {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shifts,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftsTableAnnotationComposer(
            $db: $db,
            $table: $db.shifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pettyCashRefs<T extends Object>(
    Expression<T> Function($$PettyCashTableAnnotationComposer a) f,
  ) {
    final $$PettyCashTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pettyCash,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PettyCashTableAnnotationComposer(
            $db: $db,
            $table: $db.pettyCash,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> attendanceRefs<T extends Object>(
    Expression<T> Function($$AttendanceTableAnnotationComposer a) f,
  ) {
    final $$AttendanceTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.attendance,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AttendanceTableAnnotationComposer(
            $db: $db,
            $table: $db.attendance,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> payrollsRefs<T extends Object>(
    Expression<T> Function($$PayrollsTableAnnotationComposer a) f,
  ) {
    final $$PayrollsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.payrolls,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PayrollsTableAnnotationComposer(
            $db: $db,
            $table: $db.payrolls,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockOpnamesRefs<T extends Object>(
    Expression<T> Function($$StockOpnamesTableAnnotationComposer a) f,
  ) {
    final $$StockOpnamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockOpnames,
      getReferencedColumn: (t) => t.employeeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnamesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockOpnames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$EmployeesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmployeesTable,
          Employee,
          $$EmployeesTableFilterComposer,
          $$EmployeesTableOrderingComposer,
          $$EmployeesTableAnnotationComposer,
          $$EmployeesTableCreateCompanionBuilder,
          $$EmployeesTableUpdateCompanionBuilder,
          (Employee, $$EmployeesTableReferences),
          Employee,
          PrefetchHooks Function({
            bool shiftsRefs,
            bool salesRefs,
            bool pettyCashRefs,
            bool expensesRefs,
            bool attendanceRefs,
            bool payrollsRefs,
            bool stockOpnamesRefs,
          })
        > {
  $$EmployeesTableTableManager(_$AppDatabase db, $EmployeesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EmployeesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EmployeesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EmployeesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<int> isActive = const Value.absent(),
                Value<String> salaryType = const Value.absent(),
                Value<int> baseSalary = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeesCompanion(
                id: id,
                name: name,
                role: role,
                pinHash: pinHash,
                isActive: isActive,
                salaryType: salaryType,
                baseSalary: baseSalary,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String role,
                required String pinHash,
                Value<int> isActive = const Value.absent(),
                Value<String> salaryType = const Value.absent(),
                Value<int> baseSalary = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EmployeesCompanion.insert(
                id: id,
                name: name,
                role: role,
                pinHash: pinHash,
                isActive: isActive,
                salaryType: salaryType,
                baseSalary: baseSalary,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$EmployeesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                shiftsRefs = false,
                salesRefs = false,
                pettyCashRefs = false,
                expensesRefs = false,
                attendanceRefs = false,
                payrollsRefs = false,
                stockOpnamesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (shiftsRefs) db.shifts,
                    if (salesRefs) db.sales,
                    if (pettyCashRefs) db.pettyCash,
                    if (expensesRefs) db.expenses,
                    if (attendanceRefs) db.attendance,
                    if (payrollsRefs) db.payrolls,
                    if (stockOpnamesRefs) db.stockOpnames,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (shiftsRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Shift
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._shiftsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).shiftsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (salesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Sale
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._salesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).salesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pettyCashRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          PettyCashRow
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._pettyCashRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).pettyCashRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Expense
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (attendanceRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          AttendanceRow
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._attendanceRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).attendanceRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (payrollsRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          Payroll
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._payrollsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).payrollsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockOpnamesRefs)
                        await $_getPrefetchedData<
                          Employee,
                          $EmployeesTable,
                          StockOpname
                        >(
                          currentTable: table,
                          referencedTable: $$EmployeesTableReferences
                              ._stockOpnamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$EmployeesTableReferences(
                                db,
                                table,
                                p0,
                              ).stockOpnamesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.employeeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$EmployeesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmployeesTable,
      Employee,
      $$EmployeesTableFilterComposer,
      $$EmployeesTableOrderingComposer,
      $$EmployeesTableAnnotationComposer,
      $$EmployeesTableCreateCompanionBuilder,
      $$EmployeesTableUpdateCompanionBuilder,
      (Employee, $$EmployeesTableReferences),
      Employee,
      PrefetchHooks Function({
        bool shiftsRefs,
        bool salesRefs,
        bool pettyCashRefs,
        bool expensesRefs,
        bool attendanceRefs,
        bool payrollsRefs,
        bool stockOpnamesRefs,
      })
    >;
typedef $$ShiftsTableCreateCompanionBuilder =
    ShiftsCompanion Function({
      required String id,
      required int openedAt,
      Value<int?> closedAt,
      required String status,
      required int openingFloat,
      Value<int> expectedCash,
      Value<int> actualCash,
      Value<int> cashDiff,
      Value<String?> employeeId,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$ShiftsTableUpdateCompanionBuilder =
    ShiftsCompanion Function({
      Value<String> id,
      Value<int> openedAt,
      Value<int?> closedAt,
      Value<String> status,
      Value<int> openingFloat,
      Value<int> expectedCash,
      Value<int> actualCash,
      Value<int> cashDiff,
      Value<String?> employeeId,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$ShiftsTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftsTable, Shift> {
  $$ShiftsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) => db.employees
      .createAlias($_aliasNameGenerator(db.shifts.employeeId, db.employees.id));

  $$EmployeesTableProcessedTableManager? get employeeId {
    final $_column = $_itemColumn<String>('employee_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: $_aliasNameGenerator(db.shifts.id, db.sales.shiftId),
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.shiftId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PettyCashTable, List<PettyCashRow>>
  _pettyCashRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pettyCash,
    aliasName: $_aliasNameGenerator(db.shifts.id, db.pettyCash.shiftId),
  );

  $$PettyCashTableProcessedTableManager get pettyCashRefs {
    final manager = $$PettyCashTableTableManager(
      $_db,
      $_db.pettyCash,
    ).filter((f) => f.shiftId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pettyCashRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingFloat => $composableBuilder(
    column: $table.openingFloat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expectedCash => $composableBuilder(
    column: $table.expectedCash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get actualCash => $composableBuilder(
    column: $table.actualCash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cashDiff => $composableBuilder(
    column: $table.cashDiff,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pettyCashRefs(
    Expression<bool> Function($$PettyCashTableFilterComposer f) f,
  ) {
    final $$PettyCashTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pettyCash,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PettyCashTableFilterComposer(
            $db: $db,
            $table: $db.pettyCash,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingFloat => $composableBuilder(
    column: $table.openingFloat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expectedCash => $composableBuilder(
    column: $table.expectedCash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get actualCash => $composableBuilder(
    column: $table.actualCash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cashDiff => $composableBuilder(
    column: $table.cashDiff,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<int> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get openingFloat => $composableBuilder(
    column: $table.openingFloat,
    builder: (column) => column,
  );

  GeneratedColumn<int> get expectedCash => $composableBuilder(
    column: $table.expectedCash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get actualCash => $composableBuilder(
    column: $table.actualCash,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cashDiff =>
      $composableBuilder(column: $table.cashDiff, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> pettyCashRefs<T extends Object>(
    Expression<T> Function($$PettyCashTableAnnotationComposer a) f,
  ) {
    final $$PettyCashTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pettyCash,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PettyCashTableAnnotationComposer(
            $db: $db,
            $table: $db.pettyCash,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftsTable,
          Shift,
          $$ShiftsTableFilterComposer,
          $$ShiftsTableOrderingComposer,
          $$ShiftsTableAnnotationComposer,
          $$ShiftsTableCreateCompanionBuilder,
          $$ShiftsTableUpdateCompanionBuilder,
          (Shift, $$ShiftsTableReferences),
          Shift,
          PrefetchHooks Function({
            bool employeeId,
            bool salesRefs,
            bool pettyCashRefs,
          })
        > {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> openedAt = const Value.absent(),
                Value<int?> closedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> openingFloat = const Value.absent(),
                Value<int> expectedCash = const Value.absent(),
                Value<int> actualCash = const Value.absent(),
                Value<int> cashDiff = const Value.absent(),
                Value<String?> employeeId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsCompanion(
                id: id,
                openedAt: openedAt,
                closedAt: closedAt,
                status: status,
                openingFloat: openingFloat,
                expectedCash: expectedCash,
                actualCash: actualCash,
                cashDiff: cashDiff,
                employeeId: employeeId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int openedAt,
                Value<int?> closedAt = const Value.absent(),
                required String status,
                required int openingFloat,
                Value<int> expectedCash = const Value.absent(),
                Value<int> actualCash = const Value.absent(),
                Value<int> cashDiff = const Value.absent(),
                Value<String?> employeeId = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsCompanion.insert(
                id: id,
                openedAt: openedAt,
                closedAt: closedAt,
                status: status,
                openingFloat: openingFloat,
                expectedCash: expectedCash,
                actualCash: actualCash,
                cashDiff: cashDiff,
                employeeId: employeeId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$ShiftsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({employeeId = false, salesRefs = false, pettyCashRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (salesRefs) db.sales,
                    if (pettyCashRefs) db.pettyCash,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (employeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.employeeId,
                                    referencedTable: $$ShiftsTableReferences
                                        ._employeeIdTable(db),
                                    referencedColumn: $$ShiftsTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (salesRefs)
                        await $_getPrefetchedData<Shift, $ShiftsTable, Sale>(
                          currentTable: table,
                          referencedTable: $$ShiftsTableReferences
                              ._salesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftsTableReferences(db, table, p0).salesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pettyCashRefs)
                        await $_getPrefetchedData<
                          Shift,
                          $ShiftsTable,
                          PettyCashRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftsTableReferences
                              ._pettyCashRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftsTableReferences(
                                db,
                                table,
                                p0,
                              ).pettyCashRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftsTable,
      Shift,
      $$ShiftsTableFilterComposer,
      $$ShiftsTableOrderingComposer,
      $$ShiftsTableAnnotationComposer,
      $$ShiftsTableCreateCompanionBuilder,
      $$ShiftsTableUpdateCompanionBuilder,
      (Shift, $$ShiftsTableReferences),
      Shift,
      PrefetchHooks Function({
        bool employeeId,
        bool salesRefs,
        bool pettyCashRefs,
      })
    >;
typedef $$ShopTablesTableCreateCompanionBuilder =
    ShopTablesCompanion Function({
      required String id,
      required String name,
      required String status,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$ShopTablesTableUpdateCompanionBuilder =
    ShopTablesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> status,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$ShopTablesTableReferences
    extends BaseReferences<_$AppDatabase, $ShopTablesTable, ShopTable> {
  $$ShopTablesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrdersTable, List<Order>> _ordersRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.orders,
    aliasName: $_aliasNameGenerator(db.shopTables.id, db.orders.tableId),
  );

  $$OrdersTableProcessedTableManager get ordersRefs {
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.tableId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_ordersRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShopTablesTableFilterComposer
    extends Composer<_$AppDatabase, $ShopTablesTable> {
  $$ShopTablesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ordersRefs(
    Expression<bool> Function($$OrdersTableFilterComposer f) f,
  ) {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShopTablesTableOrderingComposer
    extends Composer<_$AppDatabase, $ShopTablesTable> {
  $$ShopTablesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShopTablesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShopTablesTable> {
  $$ShopTablesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> ordersRefs<T extends Object>(
    Expression<T> Function($$OrdersTableAnnotationComposer a) f,
  ) {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.tableId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShopTablesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShopTablesTable,
          ShopTable,
          $$ShopTablesTableFilterComposer,
          $$ShopTablesTableOrderingComposer,
          $$ShopTablesTableAnnotationComposer,
          $$ShopTablesTableCreateCompanionBuilder,
          $$ShopTablesTableUpdateCompanionBuilder,
          (ShopTable, $$ShopTablesTableReferences),
          ShopTable,
          PrefetchHooks Function({bool ordersRefs})
        > {
  $$ShopTablesTableTableManager(_$AppDatabase db, $ShopTablesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShopTablesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShopTablesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShopTablesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopTablesCompanion(
                id: id,
                name: name,
                status: status,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String status,
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShopTablesCompanion.insert(
                id: id,
                name: name,
                status: status,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShopTablesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ordersRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (ordersRefs) db.orders],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (ordersRefs)
                    await $_getPrefetchedData<
                      ShopTable,
                      $ShopTablesTable,
                      Order
                    >(
                      currentTable: table,
                      referencedTable: $$ShopTablesTableReferences
                          ._ordersRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ShopTablesTableReferences(db, table, p0).ordersRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.tableId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ShopTablesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShopTablesTable,
      ShopTable,
      $$ShopTablesTableFilterComposer,
      $$ShopTablesTableOrderingComposer,
      $$ShopTablesTableAnnotationComposer,
      $$ShopTablesTableCreateCompanionBuilder,
      $$ShopTablesTableUpdateCompanionBuilder,
      (ShopTable, $$ShopTablesTableReferences),
      ShopTable,
      PrefetchHooks Function({bool ordersRefs})
    >;
typedef $$OrdersTableCreateCompanionBuilder =
    OrdersCompanion Function({
      required String id,
      Value<String?> tableId,
      required String status,
      required String channel,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$OrdersTableUpdateCompanionBuilder =
    OrdersCompanion Function({
      Value<String> id,
      Value<String?> tableId,
      Value<String> status,
      Value<String> channel,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShopTablesTable _tableIdTable(_$AppDatabase db) => db.shopTables
      .createAlias($_aliasNameGenerator(db.orders.tableId, db.shopTables.id));

  $$ShopTablesTableProcessedTableManager? get tableId {
    final $_column = $_itemColumn<String>('table_id');
    if ($_column == null) return null;
    final manager = $$ShopTablesTableTableManager(
      $_db,
      $_db.shopTables,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tableIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SalesTable, List<Sale>> _salesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.sales,
    aliasName: $_aliasNameGenerator(db.orders.id, db.sales.orderId),
  );

  $$SalesTableProcessedTableManager get salesRefs {
    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$OrderLinesTable, List<OrderLine>>
  _orderLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.orderLines,
    aliasName: $_aliasNameGenerator(db.orders.id, db.orderLines.orderId),
  );

  $$OrderLinesTableProcessedTableManager get orderLinesRefs {
    final manager = $$OrderLinesTableTableManager(
      $_db,
      $_db.orderLines,
    ).filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$ShopTablesTableFilterComposer get tableId {
    final $$ShopTablesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.shopTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopTablesTableFilterComposer(
            $db: $db,
            $table: $db.shopTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> salesRefs(
    Expression<bool> Function($$SalesTableFilterComposer f) f,
  ) {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> orderLinesRefs(
    Expression<bool> Function($$OrderLinesTableFilterComposer f) f,
  ) {
    final $$OrderLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableFilterComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShopTablesTableOrderingComposer get tableId {
    final $$ShopTablesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.shopTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopTablesTableOrderingComposer(
            $db: $db,
            $table: $db.shopTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$ShopTablesTableAnnotationComposer get tableId {
    final $$ShopTablesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.tableId,
      referencedTable: $db.shopTables,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShopTablesTableAnnotationComposer(
            $db: $db,
            $table: $db.shopTables,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> salesRefs<T extends Object>(
    Expression<T> Function($$SalesTableAnnotationComposer a) f,
  ) {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> orderLinesRefs<T extends Object>(
    Expression<T> Function($$OrderLinesTableAnnotationComposer a) f,
  ) {
    final $$OrderLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.orderLines,
      getReferencedColumn: (t) => t.orderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrderLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.orderLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$OrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrdersTable,
          Order,
          $$OrdersTableFilterComposer,
          $$OrdersTableOrderingComposer,
          $$OrdersTableAnnotationComposer,
          $$OrdersTableCreateCompanionBuilder,
          $$OrdersTableUpdateCompanionBuilder,
          (Order, $$OrdersTableReferences),
          Order,
          PrefetchHooks Function({
            bool tableId,
            bool salesRefs,
            bool orderLinesRefs,
          })
        > {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> tableId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> channel = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion(
                id: id,
                tableId: tableId,
                status: status,
                channel: channel,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> tableId = const Value.absent(),
                required String status,
                required String channel,
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrdersCompanion.insert(
                id: id,
                tableId: tableId,
                status: status,
                channel: channel,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$OrdersTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({tableId = false, salesRefs = false, orderLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (salesRefs) db.sales,
                    if (orderLinesRefs) db.orderLines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (tableId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.tableId,
                                    referencedTable: $$OrdersTableReferences
                                        ._tableIdTable(db),
                                    referencedColumn: $$OrdersTableReferences
                                        ._tableIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (salesRefs)
                        await $_getPrefetchedData<Order, $OrdersTable, Sale>(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._salesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(db, table, p0).salesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (orderLinesRefs)
                        await $_getPrefetchedData<
                          Order,
                          $OrdersTable,
                          OrderLine
                        >(
                          currentTable: table,
                          referencedTable: $$OrdersTableReferences
                              ._orderLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$OrdersTableReferences(
                                db,
                                table,
                                p0,
                              ).orderLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.orderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$OrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrdersTable,
      Order,
      $$OrdersTableFilterComposer,
      $$OrdersTableOrderingComposer,
      $$OrdersTableAnnotationComposer,
      $$OrdersTableCreateCompanionBuilder,
      $$OrdersTableUpdateCompanionBuilder,
      (Order, $$OrdersTableReferences),
      Order,
      PrefetchHooks Function({
        bool tableId,
        bool salesRefs,
        bool orderLinesRefs,
      })
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      required String id,
      required String code,
      required int date,
      required String channel,
      required String paymentMethod,
      required int subtotal,
      Value<int> discount,
      Value<int> tax,
      Value<int> serviceCharge,
      Value<int> ojolFee,
      required int total,
      required int paid,
      Value<int> change,
      Value<int> voided,
      Value<int?> voidedAt,
      Value<String?> shiftId,
      Value<String?> employeeId,
      Value<String?> customerId,
      Value<String?> orderId,
      Value<String?> splitGroupId,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<int> date,
      Value<String> channel,
      Value<String> paymentMethod,
      Value<int> subtotal,
      Value<int> discount,
      Value<int> tax,
      Value<int> serviceCharge,
      Value<int> ojolFee,
      Value<int> total,
      Value<int> paid,
      Value<int> change,
      Value<int> voided,
      Value<int?> voidedAt,
      Value<String?> shiftId,
      Value<String?> employeeId,
      Value<String?> customerId,
      Value<String?> orderId,
      Value<String?> splitGroupId,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$SalesTableReferences
    extends BaseReferences<_$AppDatabase, $SalesTable, Sale> {
  $$SalesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) => db.shifts.createAlias(
    $_aliasNameGenerator(db.sales.shiftId, db.shifts.id),
  );

  $$ShiftsTableProcessedTableManager? get shiftId {
    final $_column = $_itemColumn<String>('shift_id');
    if ($_column == null) return null;
    final manager = $$ShiftsTableTableManager(
      $_db,
      $_db.shifts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) => db.employees
      .createAlias($_aliasNameGenerator(db.sales.employeeId, db.employees.id));

  $$EmployeesTableProcessedTableManager? get employeeId {
    final $_column = $_itemColumn<String>('employee_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CustomersTable _customerIdTable(_$AppDatabase db) => db.customers
      .createAlias($_aliasNameGenerator(db.sales.customerId, db.customers.id));

  $$CustomersTableProcessedTableManager? get customerId {
    final $_column = $_itemColumn<String>('customer_id');
    if ($_column == null) return null;
    final manager = $$CustomersTableTableManager(
      $_db,
      $_db.customers,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_customerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.sales.orderId, db.orders.id),
  );

  $$OrdersTableProcessedTableManager? get orderId {
    final $_column = $_itemColumn<String>('order_id');
    if ($_column == null) return null;
    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$SaleLinesTable, List<SaleLine>>
  _saleLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.saleLines,
    aliasName: $_aliasNameGenerator(db.sales.id, db.saleLines.saleId),
  );

  $$SaleLinesTableProcessedTableManager get saleLinesRefs {
    final manager = $$SaleLinesTableTableManager(
      $_db,
      $_db.saleLines,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_saleLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SalePaymentsTable, List<SalePayment>>
  _salePaymentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.salePayments,
    aliasName: $_aliasNameGenerator(db.sales.id, db.salePayments.saleId),
  );

  $$SalePaymentsTableProcessedTableManager get salePaymentsRefs {
    final manager = $$SalePaymentsTableTableManager(
      $_db,
      $_db.salePayments,
    ).filter((f) => f.saleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_salePaymentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serviceCharge => $composableBuilder(
    column: $table.serviceCharge,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ojolFee => $composableBuilder(
    column: $table.ojolFee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get voided => $composableBuilder(
    column: $table.voided,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitGroupId => $composableBuilder(
    column: $table.splitGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftsTableFilterComposer(
            $db: $db,
            $table: $db.shifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableFilterComposer get customerId {
    final $$CustomersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableFilterComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> saleLinesRefs(
    Expression<bool> Function($$SaleLinesTableFilterComposer f) f,
  ) {
    final $$SaleLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableFilterComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> salePaymentsRefs(
    Expression<bool> Function($$SalePaymentsTableFilterComposer f) f,
  ) {
    final $$SalePaymentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salePayments,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalePaymentsTableFilterComposer(
            $db: $db,
            $table: $db.salePayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get channel => $composableBuilder(
    column: $table.channel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get subtotal => $composableBuilder(
    column: $table.subtotal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tax => $composableBuilder(
    column: $table.tax,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serviceCharge => $composableBuilder(
    column: $table.serviceCharge,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ojolFee => $composableBuilder(
    column: $table.ojolFee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get total => $composableBuilder(
    column: $table.total,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paid => $composableBuilder(
    column: $table.paid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get change => $composableBuilder(
    column: $table.change,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get voided => $composableBuilder(
    column: $table.voided,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitGroupId => $composableBuilder(
    column: $table.splitGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftsTableOrderingComposer(
            $db: $db,
            $table: $db.shifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableOrderingComposer get customerId {
    final $$CustomersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableOrderingComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get channel =>
      $composableBuilder(column: $table.channel, builder: (column) => column);

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<int> get serviceCharge => $composableBuilder(
    column: $table.serviceCharge,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ojolFee =>
      $composableBuilder(column: $table.ojolFee, builder: (column) => column);

  GeneratedColumn<int> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get paid =>
      $composableBuilder(column: $table.paid, builder: (column) => column);

  GeneratedColumn<int> get change =>
      $composableBuilder(column: $table.change, builder: (column) => column);

  GeneratedColumn<int> get voided =>
      $composableBuilder(column: $table.voided, builder: (column) => column);

  GeneratedColumn<int> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get splitGroupId => $composableBuilder(
    column: $table.splitGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftsTableAnnotationComposer(
            $db: $db,
            $table: $db.shifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CustomersTableAnnotationComposer get customerId {
    final $$CustomersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.customerId,
      referencedTable: $db.customers,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomersTableAnnotationComposer(
            $db: $db,
            $table: $db.customers,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> saleLinesRefs<T extends Object>(
    Expression<T> Function($$SaleLinesTableAnnotationComposer a) f,
  ) {
    final $$SaleLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.saleLines,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SaleLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.saleLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> salePaymentsRefs<T extends Object>(
    Expression<T> Function($$SalePaymentsTableAnnotationComposer a) f,
  ) {
    final $$SalePaymentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.salePayments,
      getReferencedColumn: (t) => t.saleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalePaymentsTableAnnotationComposer(
            $db: $db,
            $table: $db.salePayments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, $$SalesTableReferences),
          Sale,
          PrefetchHooks Function({
            bool shiftId,
            bool employeeId,
            bool customerId,
            bool orderId,
            bool saleLinesRefs,
            bool salePaymentsRefs,
          })
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> channel = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<int> subtotal = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> tax = const Value.absent(),
                Value<int> serviceCharge = const Value.absent(),
                Value<int> ojolFee = const Value.absent(),
                Value<int> total = const Value.absent(),
                Value<int> paid = const Value.absent(),
                Value<int> change = const Value.absent(),
                Value<int> voided = const Value.absent(),
                Value<int?> voidedAt = const Value.absent(),
                Value<String?> shiftId = const Value.absent(),
                Value<String?> employeeId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                Value<String?> splitGroupId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                code: code,
                date: date,
                channel: channel,
                paymentMethod: paymentMethod,
                subtotal: subtotal,
                discount: discount,
                tax: tax,
                serviceCharge: serviceCharge,
                ojolFee: ojolFee,
                total: total,
                paid: paid,
                change: change,
                voided: voided,
                voidedAt: voidedAt,
                shiftId: shiftId,
                employeeId: employeeId,
                customerId: customerId,
                orderId: orderId,
                splitGroupId: splitGroupId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required int date,
                required String channel,
                required String paymentMethod,
                required int subtotal,
                Value<int> discount = const Value.absent(),
                Value<int> tax = const Value.absent(),
                Value<int> serviceCharge = const Value.absent(),
                Value<int> ojolFee = const Value.absent(),
                required int total,
                required int paid,
                Value<int> change = const Value.absent(),
                Value<int> voided = const Value.absent(),
                Value<int?> voidedAt = const Value.absent(),
                Value<String?> shiftId = const Value.absent(),
                Value<String?> employeeId = const Value.absent(),
                Value<String?> customerId = const Value.absent(),
                Value<String?> orderId = const Value.absent(),
                Value<String?> splitGroupId = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                code: code,
                date: date,
                channel: channel,
                paymentMethod: paymentMethod,
                subtotal: subtotal,
                discount: discount,
                tax: tax,
                serviceCharge: serviceCharge,
                ojolFee: ojolFee,
                total: total,
                paid: paid,
                change: change,
                voided: voided,
                voidedAt: voidedAt,
                shiftId: shiftId,
                employeeId: employeeId,
                customerId: customerId,
                orderId: orderId,
                splitGroupId: splitGroupId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$SalesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                shiftId = false,
                employeeId = false,
                customerId = false,
                orderId = false,
                saleLinesRefs = false,
                salePaymentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (saleLinesRefs) db.saleLines,
                    if (salePaymentsRefs) db.salePayments,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (shiftId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.shiftId,
                                    referencedTable: $$SalesTableReferences
                                        ._shiftIdTable(db),
                                    referencedColumn: $$SalesTableReferences
                                        ._shiftIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (employeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.employeeId,
                                    referencedTable: $$SalesTableReferences
                                        ._employeeIdTable(db),
                                    referencedColumn: $$SalesTableReferences
                                        ._employeeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (customerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.customerId,
                                    referencedTable: $$SalesTableReferences
                                        ._customerIdTable(db),
                                    referencedColumn: $$SalesTableReferences
                                        ._customerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (orderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.orderId,
                                    referencedTable: $$SalesTableReferences
                                        ._orderIdTable(db),
                                    referencedColumn: $$SalesTableReferences
                                        ._orderIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (saleLinesRefs)
                        await $_getPrefetchedData<Sale, $SalesTable, SaleLine>(
                          currentTable: table,
                          referencedTable: $$SalesTableReferences
                              ._saleLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SalesTableReferences(
                                db,
                                table,
                                p0,
                              ).saleLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.saleId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (salePaymentsRefs)
                        await $_getPrefetchedData<
                          Sale,
                          $SalesTable,
                          SalePayment
                        >(
                          currentTable: table,
                          referencedTable: $$SalesTableReferences
                              ._salePaymentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SalesTableReferences(
                                db,
                                table,
                                p0,
                              ).salePaymentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.saleId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, $$SalesTableReferences),
      Sale,
      PrefetchHooks Function({
        bool shiftId,
        bool employeeId,
        bool customerId,
        bool orderId,
        bool saleLinesRefs,
        bool salePaymentsRefs,
      })
    >;
typedef $$SaleLinesTableCreateCompanionBuilder =
    SaleLinesCompanion Function({
      required String id,
      required String saleId,
      required String productId,
      required int qty,
      required int price,
      required int hppPerUnit,
      Value<int> discount,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$SaleLinesTableUpdateCompanionBuilder =
    SaleLinesCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> productId,
      Value<int> qty,
      Value<int> price,
      Value<int> hppPerUnit,
      Value<int> discount,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$SaleLinesTableReferences
    extends BaseReferences<_$AppDatabase, $SaleLinesTable, SaleLine> {
  $$SaleLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) => db.sales.createAlias(
    $_aliasNameGenerator(db.saleLines.saleId, db.sales.id),
  );

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<String>('sale_id')!;

    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.saleLines.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SaleLinesTableFilterComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hppPerUnit => $composableBuilder(
    column: $table.hppPerUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hppPerUnit => $composableBuilder(
    column: $table.hppPerUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get discount => $composableBuilder(
    column: $table.discount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableOrderingComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get hppPerUnit => $composableBuilder(
    column: $table.hppPerUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SaleLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleLinesTable,
          SaleLine,
          $$SaleLinesTableFilterComposer,
          $$SaleLinesTableOrderingComposer,
          $$SaleLinesTableAnnotationComposer,
          $$SaleLinesTableCreateCompanionBuilder,
          $$SaleLinesTableUpdateCompanionBuilder,
          (SaleLine, $$SaleLinesTableReferences),
          SaleLine,
          PrefetchHooks Function({bool saleId, bool productId})
        > {
  $$SaleLinesTableTableManager(_$AppDatabase db, $SaleLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int> hppPerUnit = const Value.absent(),
                Value<int> discount = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleLinesCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                qty: qty,
                price: price,
                hppPerUnit: hppPerUnit,
                discount: discount,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String productId,
                required int qty,
                required int price,
                required int hppPerUnit,
                Value<int> discount = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => SaleLinesCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                qty: qty,
                price: price,
                hppPerUnit: hppPerUnit,
                discount: discount,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SaleLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (saleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.saleId,
                                referencedTable: $$SaleLinesTableReferences
                                    ._saleIdTable(db),
                                referencedColumn: $$SaleLinesTableReferences
                                    ._saleIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$SaleLinesTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$SaleLinesTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SaleLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleLinesTable,
      SaleLine,
      $$SaleLinesTableFilterComposer,
      $$SaleLinesTableOrderingComposer,
      $$SaleLinesTableAnnotationComposer,
      $$SaleLinesTableCreateCompanionBuilder,
      $$SaleLinesTableUpdateCompanionBuilder,
      (SaleLine, $$SaleLinesTableReferences),
      SaleLine,
      PrefetchHooks Function({bool saleId, bool productId})
    >;
typedef $$SalePaymentsTableCreateCompanionBuilder =
    SalePaymentsCompanion Function({
      required String id,
      required String saleId,
      required String method,
      required int amount,
      required int processedAt,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$SalePaymentsTableUpdateCompanionBuilder =
    SalePaymentsCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> method,
      Value<int> amount,
      Value<int> processedAt,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$SalePaymentsTableReferences
    extends BaseReferences<_$AppDatabase, $SalePaymentsTable, SalePayment> {
  $$SalePaymentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SalesTable _saleIdTable(_$AppDatabase db) => db.sales.createAlias(
    $_aliasNameGenerator(db.salePayments.saleId, db.sales.id),
  );

  $$SalesTableProcessedTableManager get saleId {
    final $_column = $_itemColumn<String>('sale_id')!;

    final manager = $$SalesTableTableManager(
      $_db,
      $_db.sales,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_saleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SalePaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $SalePaymentsTable> {
  $$SalePaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$SalesTableFilterComposer get saleId {
    final $$SalesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableFilterComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalePaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $SalePaymentsTable> {
  $$SalePaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$SalesTableOrderingComposer get saleId {
    final $$SalesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableOrderingComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalePaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalePaymentsTable> {
  $$SalePaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get processedAt => $composableBuilder(
    column: $table.processedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$SalesTableAnnotationComposer get saleId {
    final $$SalesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.saleId,
      referencedTable: $db.sales,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SalesTableAnnotationComposer(
            $db: $db,
            $table: $db.sales,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SalePaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalePaymentsTable,
          SalePayment,
          $$SalePaymentsTableFilterComposer,
          $$SalePaymentsTableOrderingComposer,
          $$SalePaymentsTableAnnotationComposer,
          $$SalePaymentsTableCreateCompanionBuilder,
          $$SalePaymentsTableUpdateCompanionBuilder,
          (SalePayment, $$SalePaymentsTableReferences),
          SalePayment,
          PrefetchHooks Function({bool saleId})
        > {
  $$SalePaymentsTableTableManager(_$AppDatabase db, $SalePaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalePaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalePaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalePaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> processedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalePaymentsCompanion(
                id: id,
                saleId: saleId,
                method: method,
                amount: amount,
                processedAt: processedAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String method,
                required int amount,
                required int processedAt,
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => SalePaymentsCompanion.insert(
                id: id,
                saleId: saleId,
                method: method,
                amount: amount,
                processedAt: processedAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SalePaymentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({saleId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (saleId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.saleId,
                                referencedTable: $$SalePaymentsTableReferences
                                    ._saleIdTable(db),
                                referencedColumn: $$SalePaymentsTableReferences
                                    ._saleIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SalePaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalePaymentsTable,
      SalePayment,
      $$SalePaymentsTableFilterComposer,
      $$SalePaymentsTableOrderingComposer,
      $$SalePaymentsTableAnnotationComposer,
      $$SalePaymentsTableCreateCompanionBuilder,
      $$SalePaymentsTableUpdateCompanionBuilder,
      (SalePayment, $$SalePaymentsTableReferences),
      SalePayment,
      PrefetchHooks Function({bool saleId})
    >;
typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      required String id,
      required String name,
      required String unit,
      Value<double> stockQty,
      Value<int> avgCostMilli,
      Value<int> totalValue,
      Value<double> lowStockAt,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> unit,
      Value<double> stockQty,
      Value<int> avgCostMilli,
      Value<int> totalValue,
      Value<double> lowStockAt,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeLinesTable, List<RecipeLine>>
  _recipeLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeLines,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.recipeLines.ingredientId,
    ),
  );

  $$RecipeLinesTableProcessedTableManager get recipeLinesRefs {
    final manager = $$RecipeLinesTableTableManager(
      $_db,
      $_db.recipeLines,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockMovesTable, List<StockMove>>
  _stockMovesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockMoves,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.stockMoves.ingredientId,
    ),
  );

  $$StockMovesTableProcessedTableManager get stockMovesRefs {
    final manager = $$StockMovesTableTableManager(
      $_db,
      $_db.stockMoves,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_stockMovesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$StockOpnameLinesTable, List<StockOpnameLine>>
  _stockOpnameLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockOpnameLines,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.stockOpnameLines.ingredientId,
    ),
  );

  $$StockOpnameLinesTableProcessedTableManager get stockOpnameLinesRefs {
    final manager = $$StockOpnameLinesTableTableManager(
      $_db,
      $_db.stockOpnameLines,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stockOpnameLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get avgCostMilli => $composableBuilder(
    column: $table.avgCostMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalValue => $composableBuilder(
    column: $table.totalValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get lowStockAt => $composableBuilder(
    column: $table.lowStockAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recipeLinesRefs(
    Expression<bool> Function($$RecipeLinesTableFilterComposer f) f,
  ) {
    final $$RecipeLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeLines,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeLinesTableFilterComposer(
            $db: $db,
            $table: $db.recipeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockMovesRefs(
    Expression<bool> Function($$StockMovesTableFilterComposer f) f,
  ) {
    final $$StockMovesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMoves,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovesTableFilterComposer(
            $db: $db,
            $table: $db.stockMoves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> stockOpnameLinesRefs(
    Expression<bool> Function($$StockOpnameLinesTableFilterComposer f) f,
  ) {
    final $$StockOpnameLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockOpnameLines,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnameLinesTableFilterComposer(
            $db: $db,
            $table: $db.stockOpnameLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stockQty => $composableBuilder(
    column: $table.stockQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get avgCostMilli => $composableBuilder(
    column: $table.avgCostMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalValue => $composableBuilder(
    column: $table.totalValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get lowStockAt => $composableBuilder(
    column: $table.lowStockAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<double> get stockQty =>
      $composableBuilder(column: $table.stockQty, builder: (column) => column);

  GeneratedColumn<int> get avgCostMilli => $composableBuilder(
    column: $table.avgCostMilli,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalValue => $composableBuilder(
    column: $table.totalValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get lowStockAt => $composableBuilder(
    column: $table.lowStockAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> recipeLinesRefs<T extends Object>(
    Expression<T> Function($$RecipeLinesTableAnnotationComposer a) f,
  ) {
    final $$RecipeLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeLines,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockMovesRefs<T extends Object>(
    Expression<T> Function($$StockMovesTableAnnotationComposer a) f,
  ) {
    final $$StockMovesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockMoves,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockMovesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockMoves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> stockOpnameLinesRefs<T extends Object>(
    Expression<T> Function($$StockOpnameLinesTableAnnotationComposer a) f,
  ) {
    final $$StockOpnameLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockOpnameLines,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnameLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockOpnameLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (Ingredient, $$IngredientsTableReferences),
          Ingredient,
          PrefetchHooks Function({
            bool recipeLinesRefs,
            bool stockMovesRefs,
            bool stockOpnameLinesRefs,
          })
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<double> stockQty = const Value.absent(),
                Value<int> avgCostMilli = const Value.absent(),
                Value<int> totalValue = const Value.absent(),
                Value<double> lowStockAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                name: name,
                unit: unit,
                stockQty: stockQty,
                avgCostMilli: avgCostMilli,
                totalValue: totalValue,
                lowStockAt: lowStockAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String unit,
                Value<double> stockQty = const Value.absent(),
                Value<int> avgCostMilli = const Value.absent(),
                Value<int> totalValue = const Value.absent(),
                Value<double> lowStockAt = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion.insert(
                id: id,
                name: name,
                unit: unit,
                stockQty: stockQty,
                avgCostMilli: avgCostMilli,
                totalValue: totalValue,
                lowStockAt: lowStockAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recipeLinesRefs = false,
                stockMovesRefs = false,
                stockOpnameLinesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeLinesRefs) db.recipeLines,
                    if (stockMovesRefs) db.stockMoves,
                    if (stockOpnameLinesRefs) db.stockOpnameLines,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeLinesRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          RecipeLine
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._recipeLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockMovesRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          StockMove
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._stockMovesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockMovesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (stockOpnameLinesRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          StockOpnameLine
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._stockOpnameLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).stockOpnameLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (Ingredient, $$IngredientsTableReferences),
      Ingredient,
      PrefetchHooks Function({
        bool recipeLinesRefs,
        bool stockMovesRefs,
        bool stockOpnameLinesRefs,
      })
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      required String id,
      required String productId,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<String> id,
      Value<String> productId,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProductsTable _productIdTable(_$AppDatabase db) => db.products
      .createAlias($_aliasNameGenerator(db.recipes.productId, db.products.id));

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RecipeLinesTable, List<RecipeLine>>
  _recipeLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeLines,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.recipeLines.recipeId),
  );

  $$RecipeLinesTableProcessedTableManager get recipeLinesRefs {
    final manager = $$RecipeLinesTableTableManager(
      $_db,
      $_db.recipeLines,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recipeLinesRefs(
    Expression<bool> Function($$RecipeLinesTableFilterComposer f) f,
  ) {
    final $$RecipeLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeLines,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeLinesTableFilterComposer(
            $db: $db,
            $table: $db.recipeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recipeLinesRefs<T extends Object>(
    Expression<T> Function($$RecipeLinesTableAnnotationComposer a) f,
  ) {
    final $$RecipeLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeLines,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({bool productId, bool recipeLinesRefs})
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                productId: productId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String productId,
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                productId: productId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({productId = false, recipeLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeLinesRefs) db.recipeLines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (productId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.productId,
                                    referencedTable: $$RecipesTableReferences
                                        ._productIdTable(db),
                                    referencedColumn: $$RecipesTableReferences
                                        ._productIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeLinesRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeLine
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._recipeLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({bool productId, bool recipeLinesRefs})
    >;
typedef $$RecipeLinesTableCreateCompanionBuilder =
    RecipeLinesCompanion Function({
      required String id,
      required String recipeId,
      required String ingredientId,
      required double qty,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$RecipeLinesTableUpdateCompanionBuilder =
    RecipeLinesCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<String> ingredientId,
      Value<double> qty,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$RecipeLinesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeLinesTable, RecipeLine> {
  $$RecipeLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.recipeLines.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(db.recipeLines.ingredientId, db.ingredients.id),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeLinesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeLinesTable> {
  $$RecipeLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeLinesTable> {
  $$RecipeLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeLinesTable> {
  $$RecipeLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeLinesTable,
          RecipeLine,
          $$RecipeLinesTableFilterComposer,
          $$RecipeLinesTableOrderingComposer,
          $$RecipeLinesTableAnnotationComposer,
          $$RecipeLinesTableCreateCompanionBuilder,
          $$RecipeLinesTableUpdateCompanionBuilder,
          (RecipeLine, $$RecipeLinesTableReferences),
          RecipeLine,
          PrefetchHooks Function({bool recipeId, bool ingredientId})
        > {
  $$RecipeLinesTableTableManager(_$AppDatabase db, $RecipeLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<double> qty = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeLinesCompanion(
                id: id,
                recipeId: recipeId,
                ingredientId: ingredientId,
                qty: qty,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                required String ingredientId,
                required double qty,
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeLinesCompanion.insert(
                id: id,
                recipeId: recipeId,
                ingredientId: ingredientId,
                qty: qty,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$RecipeLinesTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$RecipeLinesTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable: $$RecipeLinesTableReferences
                                    ._ingredientIdTable(db),
                                referencedColumn: $$RecipeLinesTableReferences
                                    ._ingredientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeLinesTable,
      RecipeLine,
      $$RecipeLinesTableFilterComposer,
      $$RecipeLinesTableOrderingComposer,
      $$RecipeLinesTableAnnotationComposer,
      $$RecipeLinesTableCreateCompanionBuilder,
      $$RecipeLinesTableUpdateCompanionBuilder,
      (RecipeLine, $$RecipeLinesTableReferences),
      RecipeLine,
      PrefetchHooks Function({bool recipeId, bool ingredientId})
    >;
typedef $$StockMovesTableCreateCompanionBuilder =
    StockMovesCompanion Function({
      required String id,
      required String ingredientId,
      required int date,
      required String type,
      required double qty,
      required int unitCostMilli,
      required String refType,
      required String refId,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$StockMovesTableUpdateCompanionBuilder =
    StockMovesCompanion Function({
      Value<String> id,
      Value<String> ingredientId,
      Value<int> date,
      Value<String> type,
      Value<double> qty,
      Value<int> unitCostMilli,
      Value<String> refType,
      Value<String> refId,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$StockMovesTableReferences
    extends BaseReferences<_$AppDatabase, $StockMovesTable, StockMove> {
  $$StockMovesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(db.stockMoves.ingredientId, db.ingredients.id),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockMovesTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovesTable> {
  $$StockMovesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitCostMilli => $composableBuilder(
    column: $table.unitCostMilli,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refType => $composableBuilder(
    column: $table.refType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovesTable> {
  $$StockMovesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitCostMilli => $composableBuilder(
    column: $table.unitCostMilli,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refType => $composableBuilder(
    column: $table.refType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovesTable> {
  $$StockMovesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get unitCostMilli => $composableBuilder(
    column: $table.unitCostMilli,
    builder: (column) => column,
  );

  GeneratedColumn<String> get refType =>
      $composableBuilder(column: $table.refType, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockMovesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovesTable,
          StockMove,
          $$StockMovesTableFilterComposer,
          $$StockMovesTableOrderingComposer,
          $$StockMovesTableAnnotationComposer,
          $$StockMovesTableCreateCompanionBuilder,
          $$StockMovesTableUpdateCompanionBuilder,
          (StockMove, $$StockMovesTableReferences),
          StockMove,
          PrefetchHooks Function({bool ingredientId})
        > {
  $$StockMovesTableTableManager(_$AppDatabase db, $StockMovesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> qty = const Value.absent(),
                Value<int> unitCostMilli = const Value.absent(),
                Value<String> refType = const Value.absent(),
                Value<String> refId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovesCompanion(
                id: id,
                ingredientId: ingredientId,
                date: date,
                type: type,
                qty: qty,
                unitCostMilli: unitCostMilli,
                refType: refType,
                refId: refId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ingredientId,
                required int date,
                required String type,
                required double qty,
                required int unitCostMilli,
                required String refType,
                required String refId,
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => StockMovesCompanion.insert(
                id: id,
                ingredientId: ingredientId,
                date: date,
                type: type,
                qty: qty,
                unitCostMilli: unitCostMilli,
                refType: refType,
                refId: refId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockMovesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable: $$StockMovesTableReferences
                                    ._ingredientIdTable(db),
                                referencedColumn: $$StockMovesTableReferences
                                    ._ingredientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StockMovesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovesTable,
      StockMove,
      $$StockMovesTableFilterComposer,
      $$StockMovesTableOrderingComposer,
      $$StockMovesTableAnnotationComposer,
      $$StockMovesTableCreateCompanionBuilder,
      $$StockMovesTableUpdateCompanionBuilder,
      (StockMove, $$StockMovesTableReferences),
      StockMove,
      PrefetchHooks Function({bool ingredientId})
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      required String code,
      required String name,
      required String type,
      required String normal,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String> code,
      Value<String> name,
      Value<String> type,
      Value<String> normal,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$AccountsTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTable, Account> {
  $$AccountsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JournalLinesTable, List<JournalLine>>
  _journalLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalLines,
    aliasName: $_aliasNameGenerator(
      db.accounts.code,
      db.journalLines.accountCode,
    ),
  );

  $$JournalLinesTableProcessedTableManager get journalLinesRefs {
    final manager = $$JournalLinesTableTableManager($_db, $_db.journalLines)
        .filter(
          (f) => f.accountCode.code.sqlEquals($_itemColumn<String>('code')!),
        );

    final cache = $_typedResult.readTableOrNull(_journalLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<Expense>> _expensesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(db.accounts.code, db.expenses.accountCode),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses).filter(
      (f) => f.accountCode.code.sqlEquals($_itemColumn<String>('code')!),
    );

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normal => $composableBuilder(
    column: $table.normal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journalLinesRefs(
    Expression<bool> Function($$JournalLinesTableFilterComposer f) f,
  ) {
    final $$JournalLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.journalLines,
      getReferencedColumn: (t) => t.accountCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalLinesTableFilterComposer(
            $db: $db,
            $table: $db.journalLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.accountCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normal => $composableBuilder(
    column: $table.normal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get normal =>
      $composableBuilder(column: $table.normal, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  Expression<T> journalLinesRefs<T extends Object>(
    Expression<T> Function($$JournalLinesTableAnnotationComposer a) f,
  ) {
    final $$JournalLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.journalLines,
      getReferencedColumn: (t) => t.accountCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.code,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.accountCode,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, $$AccountsTableReferences),
          Account,
          PrefetchHooks Function({bool journalLinesRefs, bool expensesRefs})
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> normal = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                code: code,
                name: name,
                type: type,
                normal: normal,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String code,
                required String name,
                required String type,
                required String normal,
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                code: code,
                name: name,
                type: type,
                normal: normal,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({journalLinesRefs = false, expensesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (journalLinesRefs) db.journalLines,
                    if (expensesRefs) db.expenses,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (journalLinesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          JournalLine
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._journalLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).journalLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountCode == item.code,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          Account,
                          $AccountsTable,
                          Expense
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountCode == item.code,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, $$AccountsTableReferences),
      Account,
      PrefetchHooks Function({bool journalLinesRefs, bool expensesRefs})
    >;
typedef $$JournalsTableCreateCompanionBuilder =
    JournalsCompanion Function({
      required String id,
      required int date,
      required String memo,
      required String refType,
      required String refId,
      Value<String?> reversesJournalId,
      Value<int> isReversal,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$JournalsTableUpdateCompanionBuilder =
    JournalsCompanion Function({
      Value<String> id,
      Value<int> date,
      Value<String> memo,
      Value<String> refType,
      Value<String> refId,
      Value<String?> reversesJournalId,
      Value<int> isReversal,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$JournalsTableReferences
    extends BaseReferences<_$AppDatabase, $JournalsTable, Journal> {
  $$JournalsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$JournalLinesTable, List<JournalLine>>
  _journalLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.journalLines,
    aliasName: $_aliasNameGenerator(db.journals.id, db.journalLines.journalId),
  );

  $$JournalLinesTableProcessedTableManager get journalLinesRefs {
    final manager = $$JournalLinesTableTableManager(
      $_db,
      $_db.journalLines,
    ).filter((f) => f.journalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_journalLinesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$JournalsTableFilterComposer
    extends Composer<_$AppDatabase, $JournalsTable> {
  $$JournalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refType => $composableBuilder(
    column: $table.refType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reversesJournalId => $composableBuilder(
    column: $table.reversesJournalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isReversal => $composableBuilder(
    column: $table.isReversal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> journalLinesRefs(
    Expression<bool> Function($$JournalLinesTableFilterComposer f) f,
  ) {
    final $$JournalLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalLines,
      getReferencedColumn: (t) => t.journalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalLinesTableFilterComposer(
            $db: $db,
            $table: $db.journalLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JournalsTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalsTable> {
  $$JournalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refType => $composableBuilder(
    column: $table.refType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reversesJournalId => $composableBuilder(
    column: $table.reversesJournalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isReversal => $composableBuilder(
    column: $table.isReversal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$JournalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalsTable> {
  $$JournalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get refType =>
      $composableBuilder(column: $table.refType, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<String> get reversesJournalId => $composableBuilder(
    column: $table.reversesJournalId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get isReversal => $composableBuilder(
    column: $table.isReversal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  Expression<T> journalLinesRefs<T extends Object>(
    Expression<T> Function($$JournalLinesTableAnnotationComposer a) f,
  ) {
    final $$JournalLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.journalLines,
      getReferencedColumn: (t) => t.journalId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.journalLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$JournalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalsTable,
          Journal,
          $$JournalsTableFilterComposer,
          $$JournalsTableOrderingComposer,
          $$JournalsTableAnnotationComposer,
          $$JournalsTableCreateCompanionBuilder,
          $$JournalsTableUpdateCompanionBuilder,
          (Journal, $$JournalsTableReferences),
          Journal,
          PrefetchHooks Function({bool journalLinesRefs})
        > {
  $$JournalsTableTableManager(_$AppDatabase db, $JournalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> memo = const Value.absent(),
                Value<String> refType = const Value.absent(),
                Value<String> refId = const Value.absent(),
                Value<String?> reversesJournalId = const Value.absent(),
                Value<int> isReversal = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalsCompanion(
                id: id,
                date: date,
                memo: memo,
                refType: refType,
                refId: refId,
                reversesJournalId: reversesJournalId,
                isReversal: isReversal,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int date,
                required String memo,
                required String refType,
                required String refId,
                Value<String?> reversesJournalId = const Value.absent(),
                Value<int> isReversal = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => JournalsCompanion.insert(
                id: id,
                date: date,
                memo: memo,
                refType: refType,
                refId: refId,
                reversesJournalId: reversesJournalId,
                isReversal: isReversal,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JournalsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journalLinesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (journalLinesRefs) db.journalLines],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (journalLinesRefs)
                    await $_getPrefetchedData<
                      Journal,
                      $JournalsTable,
                      JournalLine
                    >(
                      currentTable: table,
                      referencedTable: $$JournalsTableReferences
                          ._journalLinesRefsTable(db),
                      managerFromTypedResult: (p0) => $$JournalsTableReferences(
                        db,
                        table,
                        p0,
                      ).journalLinesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.journalId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$JournalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalsTable,
      Journal,
      $$JournalsTableFilterComposer,
      $$JournalsTableOrderingComposer,
      $$JournalsTableAnnotationComposer,
      $$JournalsTableCreateCompanionBuilder,
      $$JournalsTableUpdateCompanionBuilder,
      (Journal, $$JournalsTableReferences),
      Journal,
      PrefetchHooks Function({bool journalLinesRefs})
    >;
typedef $$JournalLinesTableCreateCompanionBuilder =
    JournalLinesCompanion Function({
      required String id,
      required String journalId,
      required String accountCode,
      Value<int> debit,
      Value<int> credit,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$JournalLinesTableUpdateCompanionBuilder =
    JournalLinesCompanion Function({
      Value<String> id,
      Value<String> journalId,
      Value<String> accountCode,
      Value<int> debit,
      Value<int> credit,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$JournalLinesTableReferences
    extends BaseReferences<_$AppDatabase, $JournalLinesTable, JournalLine> {
  $$JournalLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $JournalsTable _journalIdTable(_$AppDatabase db) =>
      db.journals.createAlias(
        $_aliasNameGenerator(db.journalLines.journalId, db.journals.id),
      );

  $$JournalsTableProcessedTableManager get journalId {
    final $_column = $_itemColumn<String>('journal_id')!;

    final manager = $$JournalsTableTableManager(
      $_db,
      $_db.journals,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_journalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTable _accountCodeTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.journalLines.accountCode, db.accounts.code),
      );

  $$AccountsTableProcessedTableManager get accountCode {
    final $_column = $_itemColumn<String>('account_code')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$JournalLinesTableFilterComposer
    extends Composer<_$AppDatabase, $JournalLinesTable> {
  $$JournalLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$JournalsTableFilterComposer get journalId {
    final $$JournalsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalId,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalsTableFilterComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableFilterComposer get accountCode {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountCode,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $JournalLinesTable> {
  $$JournalLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get debit => $composableBuilder(
    column: $table.debit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get credit => $composableBuilder(
    column: $table.credit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$JournalsTableOrderingComposer get journalId {
    final $$JournalsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalId,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalsTableOrderingComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableOrderingComposer get accountCode {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountCode,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $JournalLinesTable> {
  $$JournalLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get debit =>
      $composableBuilder(column: $table.debit, builder: (column) => column);

  GeneratedColumn<int> get credit =>
      $composableBuilder(column: $table.credit, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$JournalsTableAnnotationComposer get journalId {
    final $$JournalsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.journalId,
      referencedTable: $db.journals,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$JournalsTableAnnotationComposer(
            $db: $db,
            $table: $db.journals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableAnnotationComposer get accountCode {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountCode,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$JournalLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $JournalLinesTable,
          JournalLine,
          $$JournalLinesTableFilterComposer,
          $$JournalLinesTableOrderingComposer,
          $$JournalLinesTableAnnotationComposer,
          $$JournalLinesTableCreateCompanionBuilder,
          $$JournalLinesTableUpdateCompanionBuilder,
          (JournalLine, $$JournalLinesTableReferences),
          JournalLine,
          PrefetchHooks Function({bool journalId, bool accountCode})
        > {
  $$JournalLinesTableTableManager(_$AppDatabase db, $JournalLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$JournalLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$JournalLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$JournalLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> journalId = const Value.absent(),
                Value<String> accountCode = const Value.absent(),
                Value<int> debit = const Value.absent(),
                Value<int> credit = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => JournalLinesCompanion(
                id: id,
                journalId: journalId,
                accountCode: accountCode,
                debit: debit,
                credit: credit,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String journalId,
                required String accountCode,
                Value<int> debit = const Value.absent(),
                Value<int> credit = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => JournalLinesCompanion.insert(
                id: id,
                journalId: journalId,
                accountCode: accountCode,
                debit: debit,
                credit: credit,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$JournalLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({journalId = false, accountCode = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (journalId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.journalId,
                                referencedTable: $$JournalLinesTableReferences
                                    ._journalIdTable(db),
                                referencedColumn: $$JournalLinesTableReferences
                                    ._journalIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (accountCode) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountCode,
                                referencedTable: $$JournalLinesTableReferences
                                    ._accountCodeTable(db),
                                referencedColumn: $$JournalLinesTableReferences
                                    ._accountCodeTable(db)
                                    .code,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$JournalLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $JournalLinesTable,
      JournalLine,
      $$JournalLinesTableFilterComposer,
      $$JournalLinesTableOrderingComposer,
      $$JournalLinesTableAnnotationComposer,
      $$JournalLinesTableCreateCompanionBuilder,
      $$JournalLinesTableUpdateCompanionBuilder,
      (JournalLine, $$JournalLinesTableReferences),
      JournalLine,
      PrefetchHooks Function({bool journalId, bool accountCode})
    >;
typedef $$PettyCashTableCreateCompanionBuilder =
    PettyCashCompanion Function({
      required String id,
      Value<String?> shiftId,
      required int date,
      required int amount,
      required String note,
      required String employeeId,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$PettyCashTableUpdateCompanionBuilder =
    PettyCashCompanion Function({
      Value<String> id,
      Value<String?> shiftId,
      Value<int> date,
      Value<int> amount,
      Value<String> note,
      Value<String> employeeId,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$PettyCashTableReferences
    extends BaseReferences<_$AppDatabase, $PettyCashTable, PettyCashRow> {
  $$PettyCashTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShiftsTable _shiftIdTable(_$AppDatabase db) => db.shifts.createAlias(
    $_aliasNameGenerator(db.pettyCash.shiftId, db.shifts.id),
  );

  $$ShiftsTableProcessedTableManager? get shiftId {
    final $_column = $_itemColumn<String>('shift_id');
    if ($_column == null) return null;
    final manager = $$ShiftsTableTableManager(
      $_db,
      $_db.shifts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.pettyCash.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PettyCashTableFilterComposer
    extends Composer<_$AppDatabase, $PettyCashTable> {
  $$PettyCashTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftsTableFilterComposer get shiftId {
    final $$ShiftsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftsTableFilterComposer(
            $db: $db,
            $table: $db.shifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PettyCashTableOrderingComposer
    extends Composer<_$AppDatabase, $PettyCashTable> {
  $$PettyCashTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftsTableOrderingComposer get shiftId {
    final $$ShiftsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftsTableOrderingComposer(
            $db: $db,
            $table: $db.shifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PettyCashTableAnnotationComposer
    extends Composer<_$AppDatabase, $PettyCashTable> {
  $$PettyCashTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$ShiftsTableAnnotationComposer get shiftId {
    final $$ShiftsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shifts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftsTableAnnotationComposer(
            $db: $db,
            $table: $db.shifts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PettyCashTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PettyCashTable,
          PettyCashRow,
          $$PettyCashTableFilterComposer,
          $$PettyCashTableOrderingComposer,
          $$PettyCashTableAnnotationComposer,
          $$PettyCashTableCreateCompanionBuilder,
          $$PettyCashTableUpdateCompanionBuilder,
          (PettyCashRow, $$PettyCashTableReferences),
          PettyCashRow,
          PrefetchHooks Function({bool shiftId, bool employeeId})
        > {
  $$PettyCashTableTableManager(_$AppDatabase db, $PettyCashTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PettyCashTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PettyCashTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PettyCashTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> shiftId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PettyCashCompanion(
                id: id,
                shiftId: shiftId,
                date: date,
                amount: amount,
                note: note,
                employeeId: employeeId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> shiftId = const Value.absent(),
                required int date,
                required int amount,
                required String note,
                required String employeeId,
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PettyCashCompanion.insert(
                id: id,
                shiftId: shiftId,
                date: date,
                amount: amount,
                note: note,
                employeeId: employeeId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PettyCashTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shiftId = false, employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shiftId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.shiftId,
                                referencedTable: $$PettyCashTableReferences
                                    ._shiftIdTable(db),
                                referencedColumn: $$PettyCashTableReferences
                                    ._shiftIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$PettyCashTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$PettyCashTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PettyCashTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PettyCashTable,
      PettyCashRow,
      $$PettyCashTableFilterComposer,
      $$PettyCashTableOrderingComposer,
      $$PettyCashTableAnnotationComposer,
      $$PettyCashTableCreateCompanionBuilder,
      $$PettyCashTableUpdateCompanionBuilder,
      (PettyCashRow, $$PettyCashTableReferences),
      PettyCashRow,
      PrefetchHooks Function({bool shiftId, bool employeeId})
    >;
typedef $$OrderLinesTableCreateCompanionBuilder =
    OrderLinesCompanion Function({
      required String id,
      required String orderId,
      required String productId,
      required int qty,
      required int price,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$OrderLinesTableUpdateCompanionBuilder =
    OrderLinesCompanion Function({
      Value<String> id,
      Value<String> orderId,
      Value<String> productId,
      Value<int> qty,
      Value<int> price,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$OrderLinesTableReferences
    extends BaseReferences<_$AppDatabase, $OrderLinesTable, OrderLine> {
  $$OrderLinesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders.createAlias(
    $_aliasNameGenerator(db.orderLines.orderId, db.orders.id),
  );

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrdersTableTableManager(
      $_db,
      $_db.orders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProductsTable _productIdTable(_$AppDatabase db) =>
      db.products.createAlias(
        $_aliasNameGenerator(db.orderLines.productId, db.products.id),
      );

  $$ProductsTableProcessedTableManager get productId {
    final $_column = $_itemColumn<String>('product_id')!;

    final manager = $$ProductsTableTableManager(
      $_db,
      $_db.products,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_productIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$OrderLinesTableFilterComposer
    extends Composer<_$AppDatabase, $OrderLinesTable> {
  $$OrderLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableFilterComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableFilterComposer get productId {
    final $$ProductsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableFilterComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderLinesTable> {
  $$OrderLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get qty => $composableBuilder(
    column: $table.qty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableOrderingComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableOrderingComposer get productId {
    final $$ProductsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableOrderingComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderLinesTable> {
  $$OrderLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get qty =>
      $composableBuilder(column: $table.qty, builder: (column) => column);

  GeneratedColumn<int> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.orderId,
      referencedTable: $db.orders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$OrdersTableAnnotationComposer(
            $db: $db,
            $table: $db.orders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProductsTableAnnotationComposer get productId {
    final $$ProductsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.productId,
      referencedTable: $db.products,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProductsTableAnnotationComposer(
            $db: $db,
            $table: $db.products,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$OrderLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OrderLinesTable,
          OrderLine,
          $$OrderLinesTableFilterComposer,
          $$OrderLinesTableOrderingComposer,
          $$OrderLinesTableAnnotationComposer,
          $$OrderLinesTableCreateCompanionBuilder,
          $$OrderLinesTableUpdateCompanionBuilder,
          (OrderLine, $$OrderLinesTableReferences),
          OrderLine,
          PrefetchHooks Function({bool orderId, bool productId})
        > {
  $$OrderLinesTableTableManager(_$AppDatabase db, $OrderLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> orderId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> qty = const Value.absent(),
                Value<int> price = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderLinesCompanion(
                id: id,
                orderId: orderId,
                productId: productId,
                qty: qty,
                price: price,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String orderId,
                required String productId,
                required int qty,
                required int price,
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OrderLinesCompanion.insert(
                id: id,
                orderId: orderId,
                productId: productId,
                qty: qty,
                price: price,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$OrderLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({orderId = false, productId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (orderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.orderId,
                                referencedTable: $$OrderLinesTableReferences
                                    ._orderIdTable(db),
                                referencedColumn: $$OrderLinesTableReferences
                                    ._orderIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (productId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.productId,
                                referencedTable: $$OrderLinesTableReferences
                                    ._productIdTable(db),
                                referencedColumn: $$OrderLinesTableReferences
                                    ._productIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$OrderLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OrderLinesTable,
      OrderLine,
      $$OrderLinesTableFilterComposer,
      $$OrderLinesTableOrderingComposer,
      $$OrderLinesTableAnnotationComposer,
      $$OrderLinesTableCreateCompanionBuilder,
      $$OrderLinesTableUpdateCompanionBuilder,
      (OrderLine, $$OrderLinesTableReferences),
      OrderLine,
      PrefetchHooks Function({bool orderId, bool productId})
    >;
typedef $$AssetsTableCreateCompanionBuilder =
    AssetsCompanion Function({
      required String id,
      required String name,
      required int purchaseDate,
      required int cost,
      required int residualValue,
      required int usefulLifeMonths,
      Value<int> accumulatedDepreciation,
      Value<String?> lastDepreciationMonth,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$AssetsTableUpdateCompanionBuilder =
    AssetsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> purchaseDate,
      Value<int> cost,
      Value<int> residualValue,
      Value<int> usefulLifeMonths,
      Value<int> accumulatedDepreciation,
      Value<String?> lastDepreciationMonth,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

class $$AssetsTableFilterComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get residualValue => $composableBuilder(
    column: $table.residualValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usefulLifeMonths => $composableBuilder(
    column: $table.usefulLifeMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get accumulatedDepreciation => $composableBuilder(
    column: $table.accumulatedDepreciation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDepreciationMonth => $composableBuilder(
    column: $table.lastDepreciationMonth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AssetsTableOrderingComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cost => $composableBuilder(
    column: $table.cost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get residualValue => $composableBuilder(
    column: $table.residualValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usefulLifeMonths => $composableBuilder(
    column: $table.usefulLifeMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get accumulatedDepreciation => $composableBuilder(
    column: $table.accumulatedDepreciation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDepreciationMonth => $composableBuilder(
    column: $table.lastDepreciationMonth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AssetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AssetsTable> {
  $$AssetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get purchaseDate => $composableBuilder(
    column: $table.purchaseDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cost =>
      $composableBuilder(column: $table.cost, builder: (column) => column);

  GeneratedColumn<int> get residualValue => $composableBuilder(
    column: $table.residualValue,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usefulLifeMonths => $composableBuilder(
    column: $table.usefulLifeMonths,
    builder: (column) => column,
  );

  GeneratedColumn<int> get accumulatedDepreciation => $composableBuilder(
    column: $table.accumulatedDepreciation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastDepreciationMonth => $composableBuilder(
    column: $table.lastDepreciationMonth,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);
}

class $$AssetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AssetsTable,
          Asset,
          $$AssetsTableFilterComposer,
          $$AssetsTableOrderingComposer,
          $$AssetsTableAnnotationComposer,
          $$AssetsTableCreateCompanionBuilder,
          $$AssetsTableUpdateCompanionBuilder,
          (Asset, BaseReferences<_$AppDatabase, $AssetsTable, Asset>),
          Asset,
          PrefetchHooks Function()
        > {
  $$AssetsTableTableManager(_$AppDatabase db, $AssetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AssetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AssetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AssetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> purchaseDate = const Value.absent(),
                Value<int> cost = const Value.absent(),
                Value<int> residualValue = const Value.absent(),
                Value<int> usefulLifeMonths = const Value.absent(),
                Value<int> accumulatedDepreciation = const Value.absent(),
                Value<String?> lastDepreciationMonth = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion(
                id: id,
                name: name,
                purchaseDate: purchaseDate,
                cost: cost,
                residualValue: residualValue,
                usefulLifeMonths: usefulLifeMonths,
                accumulatedDepreciation: accumulatedDepreciation,
                lastDepreciationMonth: lastDepreciationMonth,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int purchaseDate,
                required int cost,
                required int residualValue,
                required int usefulLifeMonths,
                Value<int> accumulatedDepreciation = const Value.absent(),
                Value<String?> lastDepreciationMonth = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AssetsCompanion.insert(
                id: id,
                name: name,
                purchaseDate: purchaseDate,
                cost: cost,
                residualValue: residualValue,
                usefulLifeMonths: usefulLifeMonths,
                accumulatedDepreciation: accumulatedDepreciation,
                lastDepreciationMonth: lastDepreciationMonth,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AssetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AssetsTable,
      Asset,
      $$AssetsTableFilterComposer,
      $$AssetsTableOrderingComposer,
      $$AssetsTableAnnotationComposer,
      $$AssetsTableCreateCompanionBuilder,
      $$AssetsTableUpdateCompanionBuilder,
      (Asset, BaseReferences<_$AppDatabase, $AssetsTable, Asset>),
      Asset,
      PrefetchHooks Function()
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      required String id,
      required int date,
      required String category,
      required int amount,
      required String accountCode,
      required String note,
      Value<String?> employeeId,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<int> date,
      Value<String> category,
      Value<int> amount,
      Value<String> accountCode,
      Value<String> note,
      Value<String?> employeeId,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, Expense> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $AccountsTable _accountCodeTable(_$AppDatabase db) =>
      db.accounts.createAlias(
        $_aliasNameGenerator(db.expenses.accountCode, db.accounts.code),
      );

  $$AccountsTableProcessedTableManager get accountCode {
    final $_column = $_itemColumn<String>('account_code')!;

    final manager = $$AccountsTableTableManager(
      $_db,
      $_db.accounts,
    ).filter((f) => f.code.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountCodeTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.expenses.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager? get employeeId {
    final $_column = $_itemColumn<String>('employee_id');
    if ($_column == null) return null;
    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableFilterComposer get accountCode {
    final $$AccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountCode,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableFilterComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableOrderingComposer get accountCode {
    final $$AccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountCode,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableOrderingComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$AccountsTableAnnotationComposer get accountCode {
    final $$AccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountCode,
      referencedTable: $db.accounts,
      getReferencedColumn: (t) => t.code,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.accounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          Expense,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (Expense, $$ExpensesTableReferences),
          Expense,
          PrefetchHooks Function({bool accountCode, bool employeeId})
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> accountCode = const Value.absent(),
                Value<String> note = const Value.absent(),
                Value<String?> employeeId = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                date: date,
                category: category,
                amount: amount,
                accountCode: accountCode,
                note: note,
                employeeId: employeeId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int date,
                required String category,
                required int amount,
                required String accountCode,
                required String note,
                Value<String?> employeeId = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                date: date,
                category: category,
                amount: amount,
                accountCode: accountCode,
                note: note,
                employeeId: employeeId,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountCode = false, employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountCode) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountCode,
                                referencedTable: $$ExpensesTableReferences
                                    ._accountCodeTable(db),
                                referencedColumn: $$ExpensesTableReferences
                                    ._accountCodeTable(db)
                                    .code,
                              )
                              as T;
                    }
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$ExpensesTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$ExpensesTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      Expense,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (Expense, $$ExpensesTableReferences),
      Expense,
      PrefetchHooks Function({bool accountCode, bool employeeId})
    >;
typedef $$AttendanceTableCreateCompanionBuilder =
    AttendanceCompanion Function({
      required String id,
      required String employeeId,
      required int date,
      Value<int?> clockIn,
      Value<int?> clockOut,
      Value<int> pinVerified,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$AttendanceTableUpdateCompanionBuilder =
    AttendanceCompanion Function({
      Value<String> id,
      Value<String> employeeId,
      Value<int> date,
      Value<int?> clockIn,
      Value<int?> clockOut,
      Value<int> pinVerified,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$AttendanceTableReferences
    extends BaseReferences<_$AppDatabase, $AttendanceTable, AttendanceRow> {
  $$AttendanceTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.attendance.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AttendanceTableFilterComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pinVerified => $composableBuilder(
    column: $table.pinVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableOrderingComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clockIn => $composableBuilder(
    column: $table.clockIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get clockOut => $composableBuilder(
    column: $table.clockOut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pinVerified => $composableBuilder(
    column: $table.pinVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableAnnotationComposer
    extends Composer<_$AppDatabase, $AttendanceTable> {
  $$AttendanceTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get clockIn =>
      $composableBuilder(column: $table.clockIn, builder: (column) => column);

  GeneratedColumn<int> get clockOut =>
      $composableBuilder(column: $table.clockOut, builder: (column) => column);

  GeneratedColumn<int> get pinVerified => $composableBuilder(
    column: $table.pinVerified,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AttendanceTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AttendanceTable,
          AttendanceRow,
          $$AttendanceTableFilterComposer,
          $$AttendanceTableOrderingComposer,
          $$AttendanceTableAnnotationComposer,
          $$AttendanceTableCreateCompanionBuilder,
          $$AttendanceTableUpdateCompanionBuilder,
          (AttendanceRow, $$AttendanceTableReferences),
          AttendanceRow,
          PrefetchHooks Function({bool employeeId})
        > {
  $$AttendanceTableTableManager(_$AppDatabase db, $AttendanceTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AttendanceTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AttendanceTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AttendanceTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int?> clockIn = const Value.absent(),
                Value<int?> clockOut = const Value.absent(),
                Value<int> pinVerified = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AttendanceCompanion(
                id: id,
                employeeId: employeeId,
                date: date,
                clockIn: clockIn,
                clockOut: clockOut,
                pinVerified: pinVerified,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String employeeId,
                required int date,
                Value<int?> clockIn = const Value.absent(),
                Value<int?> clockOut = const Value.absent(),
                Value<int> pinVerified = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => AttendanceCompanion.insert(
                id: id,
                employeeId: employeeId,
                date: date,
                clockIn: clockIn,
                clockOut: clockOut,
                pinVerified: pinVerified,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AttendanceTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$AttendanceTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$AttendanceTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AttendanceTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AttendanceTable,
      AttendanceRow,
      $$AttendanceTableFilterComposer,
      $$AttendanceTableOrderingComposer,
      $$AttendanceTableAnnotationComposer,
      $$AttendanceTableCreateCompanionBuilder,
      $$AttendanceTableUpdateCompanionBuilder,
      (AttendanceRow, $$AttendanceTableReferences),
      AttendanceRow,
      PrefetchHooks Function({bool employeeId})
    >;
typedef $$PayrollsTableCreateCompanionBuilder =
    PayrollsCompanion Function({
      required String id,
      required String employeeId,
      required String period,
      required int baseSalary,
      required int deductions,
      required int netPay,
      Value<int> additions,
      Value<String?> note,
      Value<int?> paidAt,
      required int updatedAt,
      required String deviceId,
      Value<int> rowid,
    });
typedef $$PayrollsTableUpdateCompanionBuilder =
    PayrollsCompanion Function({
      Value<String> id,
      Value<String> employeeId,
      Value<String> period,
      Value<int> baseSalary,
      Value<int> deductions,
      Value<int> netPay,
      Value<int> additions,
      Value<String?> note,
      Value<int?> paidAt,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> rowid,
    });

final class $$PayrollsTableReferences
    extends BaseReferences<_$AppDatabase, $PayrollsTable, Payroll> {
  $$PayrollsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.payrolls.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PayrollsTableFilterComposer
    extends Composer<_$AppDatabase, $PayrollsTable> {
  $$PayrollsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseSalary => $composableBuilder(
    column: $table.baseSalary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deductions => $composableBuilder(
    column: $table.deductions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get netPay => $composableBuilder(
    column: $table.netPay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get additions => $composableBuilder(
    column: $table.additions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayrollsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayrollsTable> {
  $$PayrollsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseSalary => $composableBuilder(
    column: $table.baseSalary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deductions => $composableBuilder(
    column: $table.deductions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get netPay => $composableBuilder(
    column: $table.netPay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get additions => $composableBuilder(
    column: $table.additions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paidAt => $composableBuilder(
    column: $table.paidAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayrollsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayrollsTable> {
  $$PayrollsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get baseSalary => $composableBuilder(
    column: $table.baseSalary,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deductions => $composableBuilder(
    column: $table.deductions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get netPay =>
      $composableBuilder(column: $table.netPay, builder: (column) => column);

  GeneratedColumn<int> get additions =>
      $composableBuilder(column: $table.additions, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PayrollsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayrollsTable,
          Payroll,
          $$PayrollsTableFilterComposer,
          $$PayrollsTableOrderingComposer,
          $$PayrollsTableAnnotationComposer,
          $$PayrollsTableCreateCompanionBuilder,
          $$PayrollsTableUpdateCompanionBuilder,
          (Payroll, $$PayrollsTableReferences),
          Payroll,
          PrefetchHooks Function({bool employeeId})
        > {
  $$PayrollsTableTableManager(_$AppDatabase db, $PayrollsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayrollsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayrollsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayrollsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> baseSalary = const Value.absent(),
                Value<int> deductions = const Value.absent(),
                Value<int> netPay = const Value.absent(),
                Value<int> additions = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> paidAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PayrollsCompanion(
                id: id,
                employeeId: employeeId,
                period: period,
                baseSalary: baseSalary,
                deductions: deductions,
                netPay: netPay,
                additions: additions,
                note: note,
                paidAt: paidAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String employeeId,
                required String period,
                required int baseSalary,
                required int deductions,
                required int netPay,
                Value<int> additions = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int?> paidAt = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> rowid = const Value.absent(),
              }) => PayrollsCompanion.insert(
                id: id,
                employeeId: employeeId,
                period: period,
                baseSalary: baseSalary,
                deductions: deductions,
                netPay: netPay,
                additions: additions,
                note: note,
                paidAt: paidAt,
                updatedAt: updatedAt,
                deviceId: deviceId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PayrollsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({employeeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (employeeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.employeeId,
                                referencedTable: $$PayrollsTableReferences
                                    ._employeeIdTable(db),
                                referencedColumn: $$PayrollsTableReferences
                                    ._employeeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PayrollsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayrollsTable,
      Payroll,
      $$PayrollsTableFilterComposer,
      $$PayrollsTableOrderingComposer,
      $$PayrollsTableAnnotationComposer,
      $$PayrollsTableCreateCompanionBuilder,
      $$PayrollsTableUpdateCompanionBuilder,
      (Payroll, $$PayrollsTableReferences),
      Payroll,
      PrefetchHooks Function({bool employeeId})
    >;
typedef $$StockOpnamesTableCreateCompanionBuilder =
    StockOpnamesCompanion Function({
      required String id,
      required int date,
      required String employeeId,
      required String status,
      Value<String?> note,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$StockOpnamesTableUpdateCompanionBuilder =
    StockOpnamesCompanion Function({
      Value<String> id,
      Value<int> date,
      Value<String> employeeId,
      Value<String> status,
      Value<String?> note,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$StockOpnamesTableReferences
    extends BaseReferences<_$AppDatabase, $StockOpnamesTable, StockOpname> {
  $$StockOpnamesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $EmployeesTable _employeeIdTable(_$AppDatabase db) =>
      db.employees.createAlias(
        $_aliasNameGenerator(db.stockOpnames.employeeId, db.employees.id),
      );

  $$EmployeesTableProcessedTableManager get employeeId {
    final $_column = $_itemColumn<String>('employee_id')!;

    final manager = $$EmployeesTableTableManager(
      $_db,
      $_db.employees,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_employeeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$StockOpnameLinesTable, List<StockOpnameLine>>
  _stockOpnameLinesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.stockOpnameLines,
    aliasName: $_aliasNameGenerator(
      db.stockOpnames.id,
      db.stockOpnameLines.opnameId,
    ),
  );

  $$StockOpnameLinesTableProcessedTableManager get stockOpnameLinesRefs {
    final manager = $$StockOpnameLinesTableTableManager(
      $_db,
      $_db.stockOpnameLines,
    ).filter((f) => f.opnameId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _stockOpnameLinesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$StockOpnamesTableFilterComposer
    extends Composer<_$AppDatabase, $StockOpnamesTable> {
  $$StockOpnamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$EmployeesTableFilterComposer get employeeId {
    final $$EmployeesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableFilterComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> stockOpnameLinesRefs(
    Expression<bool> Function($$StockOpnameLinesTableFilterComposer f) f,
  ) {
    final $$StockOpnameLinesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockOpnameLines,
      getReferencedColumn: (t) => t.opnameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnameLinesTableFilterComposer(
            $db: $db,
            $table: $db.stockOpnameLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StockOpnamesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockOpnamesTable> {
  $$StockOpnamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$EmployeesTableOrderingComposer get employeeId {
    final $$EmployeesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableOrderingComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockOpnamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockOpnamesTable> {
  $$StockOpnamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$EmployeesTableAnnotationComposer get employeeId {
    final $$EmployeesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.employeeId,
      referencedTable: $db.employees,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$EmployeesTableAnnotationComposer(
            $db: $db,
            $table: $db.employees,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> stockOpnameLinesRefs<T extends Object>(
    Expression<T> Function($$StockOpnameLinesTableAnnotationComposer a) f,
  ) {
    final $$StockOpnameLinesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.stockOpnameLines,
      getReferencedColumn: (t) => t.opnameId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnameLinesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockOpnameLines,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$StockOpnamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockOpnamesTable,
          StockOpname,
          $$StockOpnamesTableFilterComposer,
          $$StockOpnamesTableOrderingComposer,
          $$StockOpnamesTableAnnotationComposer,
          $$StockOpnamesTableCreateCompanionBuilder,
          $$StockOpnamesTableUpdateCompanionBuilder,
          (StockOpname, $$StockOpnamesTableReferences),
          StockOpname,
          PrefetchHooks Function({bool employeeId, bool stockOpnameLinesRefs})
        > {
  $$StockOpnamesTableTableManager(_$AppDatabase db, $StockOpnamesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockOpnamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockOpnamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockOpnamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> employeeId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockOpnamesCompanion(
                id: id,
                date: date,
                employeeId: employeeId,
                status: status,
                note: note,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int date,
                required String employeeId,
                required String status,
                Value<String?> note = const Value.absent(),
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockOpnamesCompanion.insert(
                id: id,
                date: date,
                employeeId: employeeId,
                status: status,
                note: note,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockOpnamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({employeeId = false, stockOpnameLinesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (stockOpnameLinesRefs) db.stockOpnameLines,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (employeeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.employeeId,
                                    referencedTable:
                                        $$StockOpnamesTableReferences
                                            ._employeeIdTable(db),
                                    referencedColumn:
                                        $$StockOpnamesTableReferences
                                            ._employeeIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (stockOpnameLinesRefs)
                        await $_getPrefetchedData<
                          StockOpname,
                          $StockOpnamesTable,
                          StockOpnameLine
                        >(
                          currentTable: table,
                          referencedTable: $$StockOpnamesTableReferences
                              ._stockOpnameLinesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$StockOpnamesTableReferences(
                                db,
                                table,
                                p0,
                              ).stockOpnameLinesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.opnameId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$StockOpnamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockOpnamesTable,
      StockOpname,
      $$StockOpnamesTableFilterComposer,
      $$StockOpnamesTableOrderingComposer,
      $$StockOpnamesTableAnnotationComposer,
      $$StockOpnamesTableCreateCompanionBuilder,
      $$StockOpnamesTableUpdateCompanionBuilder,
      (StockOpname, $$StockOpnamesTableReferences),
      StockOpname,
      PrefetchHooks Function({bool employeeId, bool stockOpnameLinesRefs})
    >;
typedef $$StockOpnameLinesTableCreateCompanionBuilder =
    StockOpnameLinesCompanion Function({
      required String id,
      required String opnameId,
      required String ingredientId,
      required double systemQty,
      required double actualQty,
      required double diffQty,
      required int updatedAt,
      required String deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });
typedef $$StockOpnameLinesTableUpdateCompanionBuilder =
    StockOpnameLinesCompanion Function({
      Value<String> id,
      Value<String> opnameId,
      Value<String> ingredientId,
      Value<double> systemQty,
      Value<double> actualQty,
      Value<double> diffQty,
      Value<int> updatedAt,
      Value<String> deviceId,
      Value<int> isDeleted,
      Value<int> rowid,
    });

final class $$StockOpnameLinesTableReferences
    extends
        BaseReferences<_$AppDatabase, $StockOpnameLinesTable, StockOpnameLine> {
  $$StockOpnameLinesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $StockOpnamesTable _opnameIdTable(_$AppDatabase db) =>
      db.stockOpnames.createAlias(
        $_aliasNameGenerator(db.stockOpnameLines.opnameId, db.stockOpnames.id),
      );

  $$StockOpnamesTableProcessedTableManager get opnameId {
    final $_column = $_itemColumn<String>('opname_id')!;

    final manager = $$StockOpnamesTableTableManager(
      $_db,
      $_db.stockOpnames,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_opnameIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(
          db.stockOpnameLines.ingredientId,
          db.ingredients.id,
        ),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$StockOpnameLinesTableFilterComposer
    extends Composer<_$AppDatabase, $StockOpnameLinesTable> {
  $$StockOpnameLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get systemQty => $composableBuilder(
    column: $table.systemQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get actualQty => $composableBuilder(
    column: $table.actualQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get diffQty => $composableBuilder(
    column: $table.diffQty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  $$StockOpnamesTableFilterComposer get opnameId {
    final $$StockOpnamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.opnameId,
      referencedTable: $db.stockOpnames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnamesTableFilterComposer(
            $db: $db,
            $table: $db.stockOpnames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockOpnameLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $StockOpnameLinesTable> {
  $$StockOpnameLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get systemQty => $composableBuilder(
    column: $table.systemQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get actualQty => $composableBuilder(
    column: $table.actualQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get diffQty => $composableBuilder(
    column: $table.diffQty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  $$StockOpnamesTableOrderingComposer get opnameId {
    final $$StockOpnamesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.opnameId,
      referencedTable: $db.stockOpnames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnamesTableOrderingComposer(
            $db: $db,
            $table: $db.stockOpnames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockOpnameLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockOpnameLinesTable> {
  $$StockOpnameLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get systemQty =>
      $composableBuilder(column: $table.systemQty, builder: (column) => column);

  GeneratedColumn<double> get actualQty =>
      $composableBuilder(column: $table.actualQty, builder: (column) => column);

  GeneratedColumn<double> get diffQty =>
      $composableBuilder(column: $table.diffQty, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  $$StockOpnamesTableAnnotationComposer get opnameId {
    final $$StockOpnamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.opnameId,
      referencedTable: $db.stockOpnames,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$StockOpnamesTableAnnotationComposer(
            $db: $db,
            $table: $db.stockOpnames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$StockOpnameLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockOpnameLinesTable,
          StockOpnameLine,
          $$StockOpnameLinesTableFilterComposer,
          $$StockOpnameLinesTableOrderingComposer,
          $$StockOpnameLinesTableAnnotationComposer,
          $$StockOpnameLinesTableCreateCompanionBuilder,
          $$StockOpnameLinesTableUpdateCompanionBuilder,
          (StockOpnameLine, $$StockOpnameLinesTableReferences),
          StockOpnameLine,
          PrefetchHooks Function({bool opnameId, bool ingredientId})
        > {
  $$StockOpnameLinesTableTableManager(
    _$AppDatabase db,
    $StockOpnameLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockOpnameLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockOpnameLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockOpnameLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> opnameId = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<double> systemQty = const Value.absent(),
                Value<double> actualQty = const Value.absent(),
                Value<double> diffQty = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockOpnameLinesCompanion(
                id: id,
                opnameId: opnameId,
                ingredientId: ingredientId,
                systemQty: systemQty,
                actualQty: actualQty,
                diffQty: diffQty,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String opnameId,
                required String ingredientId,
                required double systemQty,
                required double actualQty,
                required double diffQty,
                required int updatedAt,
                required String deviceId,
                Value<int> isDeleted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockOpnameLinesCompanion.insert(
                id: id,
                opnameId: opnameId,
                ingredientId: ingredientId,
                systemQty: systemQty,
                actualQty: actualQty,
                diffQty: diffQty,
                updatedAt: updatedAt,
                deviceId: deviceId,
                isDeleted: isDeleted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$StockOpnameLinesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({opnameId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (opnameId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.opnameId,
                                referencedTable:
                                    $$StockOpnameLinesTableReferences
                                        ._opnameIdTable(db),
                                referencedColumn:
                                    $$StockOpnameLinesTableReferences
                                        ._opnameIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable:
                                    $$StockOpnameLinesTableReferences
                                        ._ingredientIdTable(db),
                                referencedColumn:
                                    $$StockOpnameLinesTableReferences
                                        ._ingredientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$StockOpnameLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockOpnameLinesTable,
      StockOpnameLine,
      $$StockOpnameLinesTableFilterComposer,
      $$StockOpnameLinesTableOrderingComposer,
      $$StockOpnameLinesTableAnnotationComposer,
      $$StockOpnameLinesTableCreateCompanionBuilder,
      $$StockOpnameLinesTableUpdateCompanionBuilder,
      (StockOpnameLine, $$StockOpnameLinesTableReferences),
      StockOpnameLine,
      PrefetchHooks Function({bool opnameId, bool ingredientId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String id,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> id,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(id: id, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) =>
                  SettingsCompanion.insert(id: id, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder =
    SyncOutboxCompanion Function({
      required String id,
      required String table,
      required String rowId,
      required String operation,
      required String payload,
      required String status,
      Value<int> attempts,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$SyncOutboxTableUpdateCompanionBuilder =
    SyncOutboxCompanion Function({
      Value<String> id,
      Value<String> table,
      Value<String> rowId,
      Value<String> operation,
      Value<String> payload,
      Value<String> status,
      Value<int> attempts,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get table =>
      $composableBuilder(column: $table.table, builder: (column) => column);

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          SyncOutboxRow,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            SyncOutboxRow,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
          ),
          SyncOutboxRow,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> table = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion(
                id: id,
                table: table,
                rowId: rowId,
                operation: operation,
                payload: payload,
                status: status,
                attempts: attempts,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String table,
                required String rowId,
                required String operation,
                required String payload,
                required String status,
                Value<int> attempts = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                id: id,
                table: table,
                rowId: rowId,
                operation: operation,
                payload: payload,
                status: status,
                attempts: attempts,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      SyncOutboxRow,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        SyncOutboxRow,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, SyncOutboxRow>,
      ),
      SyncOutboxRow,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String id,
      required int lastPulledAt,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> id,
      Value<int> lastPulledAt,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get lastPulledAt => $composableBuilder(
    column: $table.lastPulledAt,
    builder: (column) => column,
  );
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateRow,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateRow,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
          ),
          SyncStateRow,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> lastPulledAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(
                id: id,
                lastPulledAt: lastPulledAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int lastPulledAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                id: id,
                lastPulledAt: lastPulledAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateRow,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateRow,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateRow>,
      ),
      SyncStateRow,
      PrefetchHooks Function()
    >;
typedef $$SyncConflictsTableCreateCompanionBuilder =
    SyncConflictsCompanion Function({
      required String id,
      required String table,
      required String rowId,
      required int localUpdatedAt,
      required int remoteUpdatedAt,
      required String localDeviceId,
      required String remoteDeviceId,
      required String reason,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$SyncConflictsTableUpdateCompanionBuilder =
    SyncConflictsCompanion Function({
      Value<String> id,
      Value<String> table,
      Value<String> rowId,
      Value<int> localUpdatedAt,
      Value<int> remoteUpdatedAt,
      Value<String> localDeviceId,
      Value<String> remoteDeviceId,
      Value<String> reason,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$SyncConflictsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get localDeviceId => $composableBuilder(
    column: $table.localDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remoteDeviceId => $composableBuilder(
    column: $table.remoteDeviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncConflictsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get table => $composableBuilder(
    column: $table.table,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rowId => $composableBuilder(
    column: $table.rowId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get localDeviceId => $composableBuilder(
    column: $table.localDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remoteDeviceId => $composableBuilder(
    column: $table.remoteDeviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncConflictsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncConflictsTable> {
  $$SyncConflictsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get table =>
      $composableBuilder(column: $table.table, builder: (column) => column);

  GeneratedColumn<String> get rowId =>
      $composableBuilder(column: $table.rowId, builder: (column) => column);

  GeneratedColumn<int> get localUpdatedAt => $composableBuilder(
    column: $table.localUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get localDeviceId => $composableBuilder(
    column: $table.localDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get remoteDeviceId => $composableBuilder(
    column: $table.remoteDeviceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncConflictsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncConflictsTable,
          SyncConflictRow,
          $$SyncConflictsTableFilterComposer,
          $$SyncConflictsTableOrderingComposer,
          $$SyncConflictsTableAnnotationComposer,
          $$SyncConflictsTableCreateCompanionBuilder,
          $$SyncConflictsTableUpdateCompanionBuilder,
          (
            SyncConflictRow,
            BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflictRow>,
          ),
          SyncConflictRow,
          PrefetchHooks Function()
        > {
  $$SyncConflictsTableTableManager(_$AppDatabase db, $SyncConflictsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncConflictsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncConflictsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncConflictsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> table = const Value.absent(),
                Value<String> rowId = const Value.absent(),
                Value<int> localUpdatedAt = const Value.absent(),
                Value<int> remoteUpdatedAt = const Value.absent(),
                Value<String> localDeviceId = const Value.absent(),
                Value<String> remoteDeviceId = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion(
                id: id,
                table: table,
                rowId: rowId,
                localUpdatedAt: localUpdatedAt,
                remoteUpdatedAt: remoteUpdatedAt,
                localDeviceId: localDeviceId,
                remoteDeviceId: remoteDeviceId,
                reason: reason,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String table,
                required String rowId,
                required int localUpdatedAt,
                required int remoteUpdatedAt,
                required String localDeviceId,
                required String remoteDeviceId,
                required String reason,
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncConflictsCompanion.insert(
                id: id,
                table: table,
                rowId: rowId,
                localUpdatedAt: localUpdatedAt,
                remoteUpdatedAt: remoteUpdatedAt,
                localDeviceId: localDeviceId,
                remoteDeviceId: remoteDeviceId,
                reason: reason,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncConflictsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncConflictsTable,
      SyncConflictRow,
      $$SyncConflictsTableFilterComposer,
      $$SyncConflictsTableOrderingComposer,
      $$SyncConflictsTableAnnotationComposer,
      $$SyncConflictsTableCreateCompanionBuilder,
      $$SyncConflictsTableUpdateCompanionBuilder,
      (
        SyncConflictRow,
        BaseReferences<_$AppDatabase, $SyncConflictsTable, SyncConflictRow>,
      ),
      SyncConflictRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$CustomersTableTableManager get customers =>
      $$CustomersTableTableManager(_db, _db.customers);
  $$PromosTableTableManager get promos =>
      $$PromosTableTableManager(_db, _db.promos);
  $$EmployeesTableTableManager get employees =>
      $$EmployeesTableTableManager(_db, _db.employees);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$ShopTablesTableTableManager get shopTables =>
      $$ShopTablesTableTableManager(_db, _db.shopTables);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleLinesTableTableManager get saleLines =>
      $$SaleLinesTableTableManager(_db, _db.saleLines);
  $$SalePaymentsTableTableManager get salePayments =>
      $$SalePaymentsTableTableManager(_db, _db.salePayments);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeLinesTableTableManager get recipeLines =>
      $$RecipeLinesTableTableManager(_db, _db.recipeLines);
  $$StockMovesTableTableManager get stockMoves =>
      $$StockMovesTableTableManager(_db, _db.stockMoves);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$JournalsTableTableManager get journals =>
      $$JournalsTableTableManager(_db, _db.journals);
  $$JournalLinesTableTableManager get journalLines =>
      $$JournalLinesTableTableManager(_db, _db.journalLines);
  $$PettyCashTableTableManager get pettyCash =>
      $$PettyCashTableTableManager(_db, _db.pettyCash);
  $$OrderLinesTableTableManager get orderLines =>
      $$OrderLinesTableTableManager(_db, _db.orderLines);
  $$AssetsTableTableManager get assets =>
      $$AssetsTableTableManager(_db, _db.assets);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$AttendanceTableTableManager get attendance =>
      $$AttendanceTableTableManager(_db, _db.attendance);
  $$PayrollsTableTableManager get payrolls =>
      $$PayrollsTableTableManager(_db, _db.payrolls);
  $$StockOpnamesTableTableManager get stockOpnames =>
      $$StockOpnamesTableTableManager(_db, _db.stockOpnames);
  $$StockOpnameLinesTableTableManager get stockOpnameLines =>
      $$StockOpnameLinesTableTableManager(_db, _db.stockOpnameLines);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
  $$SyncConflictsTableTableManager get syncConflicts =>
      $$SyncConflictsTableTableManager(_db, _db.syncConflicts);
}
