// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FoodsTable extends Foods with TableInfo<$FoodsTable, FoodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _brandMeta = const VerificationMeta('brand');
  @override
  late final GeneratedColumn<String> brand = GeneratedColumn<String>(
    'brand',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  @override
  late final GeneratedColumnWithTypeConverter<FoodSource, int> source =
      GeneratedColumn<int>(
        'source',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<FoodSource>($FoodsTable.$convertersource);
  @override
  late final GeneratedColumnWithTypeConverter<NutrientBasis, int> basis =
      GeneratedColumn<int>(
        'basis',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<NutrientBasis>($FoodsTable.$converterbasis);
  @override
  late final GeneratedColumnWithTypeConverter<Nutrients, String> nutrients =
      GeneratedColumn<String>(
        'nutrients',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Nutrients>($FoodsTable.$converternutrients);
  static const VerificationMeta _servingSizeMetricMeta = const VerificationMeta(
    'servingSizeMetric',
  );
  @override
  late final GeneratedColumn<double> servingSizeMetric =
      GeneratedColumn<double>(
        'serving_size_metric',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  @override
  late final GeneratedColumnWithTypeConverter<ServingUnit?, int> servingUnit =
      GeneratedColumn<int>(
        'serving_unit',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<ServingUnit?>($FoodsTable.$converterservingUnitn);
  static const VerificationMeta _householdMeasureMeta = const VerificationMeta(
    'householdMeasure',
  );
  @override
  late final GeneratedColumn<String> householdMeasure = GeneratedColumn<String>(
    'household_measure',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _energyIsManualMeta = const VerificationMeta(
    'energyIsManual',
  );
  @override
  late final GeneratedColumn<bool> energyIsManual = GeneratedColumn<bool>(
    'energy_is_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("energy_is_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($FoodsTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($FoodsTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    brand,
    barcode,
    source,
    basis,
    nutrients,
    servingSizeMetric,
    servingUnit,
    householdMeasure,
    energyIsManual,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'foods';
  @override
  VerificationContext validateIntegrity(
    Insertable<FoodRow> instance, {
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
    if (data.containsKey('brand')) {
      context.handle(
        _brandMeta,
        brand.isAcceptableOrUnknown(data['brand']!, _brandMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('serving_size_metric')) {
      context.handle(
        _servingSizeMetricMeta,
        servingSizeMetric.isAcceptableOrUnknown(
          data['serving_size_metric']!,
          _servingSizeMetricMeta,
        ),
      );
    }
    if (data.containsKey('household_measure')) {
      context.handle(
        _householdMeasureMeta,
        householdMeasure.isAcceptableOrUnknown(
          data['household_measure']!,
          _householdMeasureMeta,
        ),
      );
    }
    if (data.containsKey('energy_is_manual')) {
      context.handle(
        _energyIsManualMeta,
        energyIsManual.isAcceptableOrUnknown(
          data['energy_is_manual']!,
          _energyIsManualMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      brand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}brand'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      source: $FoodsTable.$convertersource.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}source'],
        )!,
      ),
      basis: $FoodsTable.$converterbasis.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}basis'],
        )!,
      ),
      nutrients: $FoodsTable.$converternutrients.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}nutrients'],
        )!,
      ),
      servingSizeMetric: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}serving_size_metric'],
      ),
      servingUnit: $FoodsTable.$converterservingUnitn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}serving_unit'],
        ),
      ),
      householdMeasure: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}household_measure'],
      ),
      energyIsManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}energy_is_manual'],
      )!,
      createdAt: $FoodsTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $FoodsTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $FoodsTable createAlias(String alias) {
    return $FoodsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<FoodSource, int, int> $convertersource =
      const EnumIndexConverter<FoodSource>(FoodSource.values);
  static JsonTypeConverter2<NutrientBasis, int, int> $converterbasis =
      const EnumIndexConverter<NutrientBasis>(NutrientBasis.values);
  static TypeConverter<Nutrients, String> $converternutrients =
      const NutrientsConverter();
  static JsonTypeConverter2<ServingUnit, int, int> $converterservingUnit =
      const EnumIndexConverter<ServingUnit>(ServingUnit.values);
  static JsonTypeConverter2<ServingUnit?, int?, int?> $converterservingUnitn =
      JsonTypeConverter2.asNullable($converterservingUnit);
  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeMillisConverter();
}

class FoodRow extends DataClass implements Insertable<FoodRow> {
  final String id;
  final String name;
  final String? brand;
  final String? barcode;
  final FoodSource source;
  final NutrientBasis basis;
  final Nutrients nutrients;
  final double? servingSizeMetric;
  final ServingUnit? servingUnit;
  final String? householdMeasure;
  final bool energyIsManual;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FoodRow({
    required this.id,
    required this.name,
    this.brand,
    this.barcode,
    required this.source,
    required this.basis,
    required this.nutrients,
    this.servingSizeMetric,
    this.servingUnit,
    this.householdMeasure,
    required this.energyIsManual,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || brand != null) {
      map['brand'] = Variable<String>(brand);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    {
      map['source'] = Variable<int>($FoodsTable.$convertersource.toSql(source));
    }
    {
      map['basis'] = Variable<int>($FoodsTable.$converterbasis.toSql(basis));
    }
    {
      map['nutrients'] = Variable<String>(
        $FoodsTable.$converternutrients.toSql(nutrients),
      );
    }
    if (!nullToAbsent || servingSizeMetric != null) {
      map['serving_size_metric'] = Variable<double>(servingSizeMetric);
    }
    if (!nullToAbsent || servingUnit != null) {
      map['serving_unit'] = Variable<int>(
        $FoodsTable.$converterservingUnitn.toSql(servingUnit),
      );
    }
    if (!nullToAbsent || householdMeasure != null) {
      map['household_measure'] = Variable<String>(householdMeasure);
    }
    map['energy_is_manual'] = Variable<bool>(energyIsManual);
    {
      map['created_at'] = Variable<int>(
        $FoodsTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $FoodsTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    return map;
  }

  FoodsCompanion toCompanion(bool nullToAbsent) {
    return FoodsCompanion(
      id: Value(id),
      name: Value(name),
      brand: brand == null && nullToAbsent
          ? const Value.absent()
          : Value(brand),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      source: Value(source),
      basis: Value(basis),
      nutrients: Value(nutrients),
      servingSizeMetric: servingSizeMetric == null && nullToAbsent
          ? const Value.absent()
          : Value(servingSizeMetric),
      servingUnit: servingUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(servingUnit),
      householdMeasure: householdMeasure == null && nullToAbsent
          ? const Value.absent()
          : Value(householdMeasure),
      energyIsManual: Value(energyIsManual),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FoodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      brand: serializer.fromJson<String?>(json['brand']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      source: $FoodsTable.$convertersource.fromJson(
        serializer.fromJson<int>(json['source']),
      ),
      basis: $FoodsTable.$converterbasis.fromJson(
        serializer.fromJson<int>(json['basis']),
      ),
      nutrients: serializer.fromJson<Nutrients>(json['nutrients']),
      servingSizeMetric: serializer.fromJson<double?>(
        json['servingSizeMetric'],
      ),
      servingUnit: $FoodsTable.$converterservingUnitn.fromJson(
        serializer.fromJson<int?>(json['servingUnit']),
      ),
      householdMeasure: serializer.fromJson<String?>(json['householdMeasure']),
      energyIsManual: serializer.fromJson<bool>(json['energyIsManual']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'brand': serializer.toJson<String?>(brand),
      'barcode': serializer.toJson<String?>(barcode),
      'source': serializer.toJson<int>(
        $FoodsTable.$convertersource.toJson(source),
      ),
      'basis': serializer.toJson<int>(
        $FoodsTable.$converterbasis.toJson(basis),
      ),
      'nutrients': serializer.toJson<Nutrients>(nutrients),
      'servingSizeMetric': serializer.toJson<double?>(servingSizeMetric),
      'servingUnit': serializer.toJson<int?>(
        $FoodsTable.$converterservingUnitn.toJson(servingUnit),
      ),
      'householdMeasure': serializer.toJson<String?>(householdMeasure),
      'energyIsManual': serializer.toJson<bool>(energyIsManual),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FoodRow copyWith({
    String? id,
    String? name,
    Value<String?> brand = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    FoodSource? source,
    NutrientBasis? basis,
    Nutrients? nutrients,
    Value<double?> servingSizeMetric = const Value.absent(),
    Value<ServingUnit?> servingUnit = const Value.absent(),
    Value<String?> householdMeasure = const Value.absent(),
    bool? energyIsManual,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FoodRow(
    id: id ?? this.id,
    name: name ?? this.name,
    brand: brand.present ? brand.value : this.brand,
    barcode: barcode.present ? barcode.value : this.barcode,
    source: source ?? this.source,
    basis: basis ?? this.basis,
    nutrients: nutrients ?? this.nutrients,
    servingSizeMetric: servingSizeMetric.present
        ? servingSizeMetric.value
        : this.servingSizeMetric,
    servingUnit: servingUnit.present ? servingUnit.value : this.servingUnit,
    householdMeasure: householdMeasure.present
        ? householdMeasure.value
        : this.householdMeasure,
    energyIsManual: energyIsManual ?? this.energyIsManual,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FoodRow copyWithCompanion(FoodsCompanion data) {
    return FoodRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      brand: data.brand.present ? data.brand.value : this.brand,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      source: data.source.present ? data.source.value : this.source,
      basis: data.basis.present ? data.basis.value : this.basis,
      nutrients: data.nutrients.present ? data.nutrients.value : this.nutrients,
      servingSizeMetric: data.servingSizeMetric.present
          ? data.servingSizeMetric.value
          : this.servingSizeMetric,
      servingUnit: data.servingUnit.present
          ? data.servingUnit.value
          : this.servingUnit,
      householdMeasure: data.householdMeasure.present
          ? data.householdMeasure.value
          : this.householdMeasure,
      energyIsManual: data.energyIsManual.present
          ? data.energyIsManual.value
          : this.energyIsManual,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('barcode: $barcode, ')
          ..write('source: $source, ')
          ..write('basis: $basis, ')
          ..write('nutrients: $nutrients, ')
          ..write('servingSizeMetric: $servingSizeMetric, ')
          ..write('servingUnit: $servingUnit, ')
          ..write('householdMeasure: $householdMeasure, ')
          ..write('energyIsManual: $energyIsManual, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    brand,
    barcode,
    source,
    basis,
    nutrients,
    servingSizeMetric,
    servingUnit,
    householdMeasure,
    energyIsManual,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.brand == this.brand &&
          other.barcode == this.barcode &&
          other.source == this.source &&
          other.basis == this.basis &&
          other.nutrients == this.nutrients &&
          other.servingSizeMetric == this.servingSizeMetric &&
          other.servingUnit == this.servingUnit &&
          other.householdMeasure == this.householdMeasure &&
          other.energyIsManual == this.energyIsManual &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FoodsCompanion extends UpdateCompanion<FoodRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> brand;
  final Value<String?> barcode;
  final Value<FoodSource> source;
  final Value<NutrientBasis> basis;
  final Value<Nutrients> nutrients;
  final Value<double?> servingSizeMetric;
  final Value<ServingUnit?> servingUnit;
  final Value<String?> householdMeasure;
  final Value<bool> energyIsManual;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FoodsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.brand = const Value.absent(),
    this.barcode = const Value.absent(),
    this.source = const Value.absent(),
    this.basis = const Value.absent(),
    this.nutrients = const Value.absent(),
    this.servingSizeMetric = const Value.absent(),
    this.servingUnit = const Value.absent(),
    this.householdMeasure = const Value.absent(),
    this.energyIsManual = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FoodsCompanion.insert({
    required String id,
    required String name,
    this.brand = const Value.absent(),
    this.barcode = const Value.absent(),
    required FoodSource source,
    required NutrientBasis basis,
    required Nutrients nutrients,
    this.servingSizeMetric = const Value.absent(),
    this.servingUnit = const Value.absent(),
    this.householdMeasure = const Value.absent(),
    this.energyIsManual = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       source = Value(source),
       basis = Value(basis),
       nutrients = Value(nutrients),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FoodRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? brand,
    Expression<String>? barcode,
    Expression<int>? source,
    Expression<int>? basis,
    Expression<String>? nutrients,
    Expression<double>? servingSizeMetric,
    Expression<int>? servingUnit,
    Expression<String>? householdMeasure,
    Expression<bool>? energyIsManual,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (brand != null) 'brand': brand,
      if (barcode != null) 'barcode': barcode,
      if (source != null) 'source': source,
      if (basis != null) 'basis': basis,
      if (nutrients != null) 'nutrients': nutrients,
      if (servingSizeMetric != null) 'serving_size_metric': servingSizeMetric,
      if (servingUnit != null) 'serving_unit': servingUnit,
      if (householdMeasure != null) 'household_measure': householdMeasure,
      if (energyIsManual != null) 'energy_is_manual': energyIsManual,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FoodsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? brand,
    Value<String?>? barcode,
    Value<FoodSource>? source,
    Value<NutrientBasis>? basis,
    Value<Nutrients>? nutrients,
    Value<double?>? servingSizeMetric,
    Value<ServingUnit?>? servingUnit,
    Value<String?>? householdMeasure,
    Value<bool>? energyIsManual,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FoodsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      barcode: barcode ?? this.barcode,
      source: source ?? this.source,
      basis: basis ?? this.basis,
      nutrients: nutrients ?? this.nutrients,
      servingSizeMetric: servingSizeMetric ?? this.servingSizeMetric,
      servingUnit: servingUnit ?? this.servingUnit,
      householdMeasure: householdMeasure ?? this.householdMeasure,
      energyIsManual: energyIsManual ?? this.energyIsManual,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (brand.present) {
      map['brand'] = Variable<String>(brand.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (source.present) {
      map['source'] = Variable<int>(
        $FoodsTable.$convertersource.toSql(source.value),
      );
    }
    if (basis.present) {
      map['basis'] = Variable<int>(
        $FoodsTable.$converterbasis.toSql(basis.value),
      );
    }
    if (nutrients.present) {
      map['nutrients'] = Variable<String>(
        $FoodsTable.$converternutrients.toSql(nutrients.value),
      );
    }
    if (servingSizeMetric.present) {
      map['serving_size_metric'] = Variable<double>(servingSizeMetric.value);
    }
    if (servingUnit.present) {
      map['serving_unit'] = Variable<int>(
        $FoodsTable.$converterservingUnitn.toSql(servingUnit.value),
      );
    }
    if (householdMeasure.present) {
      map['household_measure'] = Variable<String>(householdMeasure.value);
    }
    if (energyIsManual.present) {
      map['energy_is_manual'] = Variable<bool>(energyIsManual.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $FoodsTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $FoodsTable.$converterupdatedAt.toSql(updatedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('brand: $brand, ')
          ..write('barcode: $barcode, ')
          ..write('source: $source, ')
          ..write('basis: $basis, ')
          ..write('nutrients: $nutrients, ')
          ..write('servingSizeMetric: $servingSizeMetric, ')
          ..write('servingUnit: $servingUnit, ')
          ..write('householdMeasure: $householdMeasure, ')
          ..write('energyIsManual: $energyIsManual, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, RecipeRow> {
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yieldServingsMeta = const VerificationMeta(
    'yieldServings',
  );
  @override
  late final GeneratedColumn<double> yieldServings = GeneratedColumn<double>(
    'yield_servings',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> createdAt =
      GeneratedColumn<int>(
        'created_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RecipesTable.$convertercreatedAt);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> updatedAt =
      GeneratedColumn<int>(
        'updated_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($RecipesTable.$converterupdatedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    yieldServings,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeRow> instance, {
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
    if (data.containsKey('yield_servings')) {
      context.handle(
        _yieldServingsMeta,
        yieldServings.isAcceptableOrUnknown(
          data['yield_servings']!,
          _yieldServingsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_yieldServingsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      yieldServings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}yield_servings'],
      )!,
      createdAt: $RecipesTable.$convertercreatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}created_at'],
        )!,
      ),
      updatedAt: $RecipesTable.$converterupdatedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}updated_at'],
        )!,
      ),
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $convertercreatedAt =
      const DateTimeMillisConverter();
  static TypeConverter<DateTime, int> $converterupdatedAt =
      const DateTimeMillisConverter();
}

class RecipeRow extends DataClass implements Insertable<RecipeRow> {
  final String id;
  final String name;
  final double yieldServings;
  final DateTime createdAt;
  final DateTime updatedAt;
  const RecipeRow({
    required this.id,
    required this.name,
    required this.yieldServings,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['yield_servings'] = Variable<double>(yieldServings);
    {
      map['created_at'] = Variable<int>(
        $RecipesTable.$convertercreatedAt.toSql(createdAt),
      );
    }
    {
      map['updated_at'] = Variable<int>(
        $RecipesTable.$converterupdatedAt.toSql(updatedAt),
      );
    }
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      yieldServings: Value(yieldServings),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory RecipeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      yieldServings: serializer.fromJson<double>(json['yieldServings']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'yieldServings': serializer.toJson<double>(yieldServings),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  RecipeRow copyWith({
    String? id,
    String? name,
    double? yieldServings,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => RecipeRow(
    id: id ?? this.id,
    name: name ?? this.name,
    yieldServings: yieldServings ?? this.yieldServings,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  RecipeRow copyWithCompanion(RecipesCompanion data) {
    return RecipeRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      yieldServings: data.yieldServings.present
          ? data.yieldServings.value
          : this.yieldServings,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('yieldServings: $yieldServings, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, yieldServings, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.yieldServings == this.yieldServings &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class RecipesCompanion extends UpdateCompanion<RecipeRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> yieldServings;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.yieldServings = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String name,
    required double yieldServings,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       yieldServings = Value(yieldServings),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<RecipeRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? yieldServings,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (yieldServings != null) 'yield_servings': yieldServings,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<double>? yieldServings,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      yieldServings: yieldServings ?? this.yieldServings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
    if (yieldServings.present) {
      map['yield_servings'] = Variable<double>(yieldServings.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(
        $RecipesTable.$convertercreatedAt.toSql(createdAt.value),
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(
        $RecipesTable.$converterupdatedAt.toSql(updatedAt.value),
      );
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
          ..write('name: $name, ')
          ..write('yieldServings: $yieldServings, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTable extends RecipeIngredients
    with TableInfo<$RecipeIngredientsTable, RecipeIngredientRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _foodIdMeta = const VerificationMeta('foodId');
  @override
  late final GeneratedColumn<String> foodId = GeneratedColumn<String>(
    'food_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES foods (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _quantityAmountMeta = const VerificationMeta(
    'quantityAmount',
  );
  @override
  late final GeneratedColumn<double> quantityAmount = GeneratedColumn<double>(
    'quantity_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuantityMeasure, int>
  quantityMeasure =
      GeneratedColumn<int>(
        'quantity_measure',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<QuantityMeasure>(
        $RecipeIngredientsTable.$converterquantityMeasure,
      );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    foodId,
    quantityAmount,
    quantityMeasure,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeIngredientRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('food_id')) {
      context.handle(
        _foodIdMeta,
        foodId.isAcceptableOrUnknown(data['food_id']!, _foodIdMeta),
      );
    } else if (isInserting) {
      context.missing(_foodIdMeta);
    }
    if (data.containsKey('quantity_amount')) {
      context.handle(
        _quantityAmountMeta,
        quantityAmount.isAcceptableOrUnknown(
          data['quantity_amount']!,
          _quantityAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityAmountMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeIngredientRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredientRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      foodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}food_id'],
      )!,
      quantityAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_amount'],
      )!,
      quantityMeasure: $RecipeIngredientsTable.$converterquantityMeasure
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}quantity_measure'],
            )!,
          ),
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $RecipeIngredientsTable createAlias(String alias) {
    return $RecipeIngredientsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<QuantityMeasure, int, int>
  $converterquantityMeasure = const EnumIndexConverter<QuantityMeasure>(
    QuantityMeasure.values,
  );
}

class RecipeIngredientRow extends DataClass
    implements Insertable<RecipeIngredientRow> {
  final int id;
  final String recipeId;
  final String foodId;
  final double quantityAmount;
  final QuantityMeasure quantityMeasure;
  final int position;
  const RecipeIngredientRow({
    required this.id,
    required this.recipeId,
    required this.foodId,
    required this.quantityAmount,
    required this.quantityMeasure,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['food_id'] = Variable<String>(foodId);
    map['quantity_amount'] = Variable<double>(quantityAmount);
    {
      map['quantity_measure'] = Variable<int>(
        $RecipeIngredientsTable.$converterquantityMeasure.toSql(
          quantityMeasure,
        ),
      );
    }
    map['position'] = Variable<int>(position);
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      foodId: Value(foodId),
      quantityAmount: Value(quantityAmount),
      quantityMeasure: Value(quantityMeasure),
      position: Value(position),
    );
  }

  factory RecipeIngredientRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredientRow(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      foodId: serializer.fromJson<String>(json['foodId']),
      quantityAmount: serializer.fromJson<double>(json['quantityAmount']),
      quantityMeasure: $RecipeIngredientsTable.$converterquantityMeasure
          .fromJson(serializer.fromJson<int>(json['quantityMeasure'])),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'foodId': serializer.toJson<String>(foodId),
      'quantityAmount': serializer.toJson<double>(quantityAmount),
      'quantityMeasure': serializer.toJson<int>(
        $RecipeIngredientsTable.$converterquantityMeasure.toJson(
          quantityMeasure,
        ),
      ),
      'position': serializer.toJson<int>(position),
    };
  }

  RecipeIngredientRow copyWith({
    int? id,
    String? recipeId,
    String? foodId,
    double? quantityAmount,
    QuantityMeasure? quantityMeasure,
    int? position,
  }) => RecipeIngredientRow(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    foodId: foodId ?? this.foodId,
    quantityAmount: quantityAmount ?? this.quantityAmount,
    quantityMeasure: quantityMeasure ?? this.quantityMeasure,
    position: position ?? this.position,
  );
  RecipeIngredientRow copyWithCompanion(RecipeIngredientsCompanion data) {
    return RecipeIngredientRow(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      foodId: data.foodId.present ? data.foodId.value : this.foodId,
      quantityAmount: data.quantityAmount.present
          ? data.quantityAmount.value
          : this.quantityAmount,
      quantityMeasure: data.quantityMeasure.present
          ? data.quantityMeasure.value
          : this.quantityMeasure,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientRow(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('foodId: $foodId, ')
          ..write('quantityAmount: $quantityAmount, ')
          ..write('quantityMeasure: $quantityMeasure, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    foodId,
    quantityAmount,
    quantityMeasure,
    position,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredientRow &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.foodId == this.foodId &&
          other.quantityAmount == this.quantityAmount &&
          other.quantityMeasure == this.quantityMeasure &&
          other.position == this.position);
}

class RecipeIngredientsCompanion extends UpdateCompanion<RecipeIngredientRow> {
  final Value<int> id;
  final Value<String> recipeId;
  final Value<String> foodId;
  final Value<double> quantityAmount;
  final Value<QuantityMeasure> quantityMeasure;
  final Value<int> position;
  const RecipeIngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.foodId = const Value.absent(),
    this.quantityAmount = const Value.absent(),
    this.quantityMeasure = const Value.absent(),
    this.position = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    this.id = const Value.absent(),
    required String recipeId,
    required String foodId,
    required double quantityAmount,
    required QuantityMeasure quantityMeasure,
    required int position,
  }) : recipeId = Value(recipeId),
       foodId = Value(foodId),
       quantityAmount = Value(quantityAmount),
       quantityMeasure = Value(quantityMeasure),
       position = Value(position);
  static Insertable<RecipeIngredientRow> custom({
    Expression<int>? id,
    Expression<String>? recipeId,
    Expression<String>? foodId,
    Expression<double>? quantityAmount,
    Expression<int>? quantityMeasure,
    Expression<int>? position,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (foodId != null) 'food_id': foodId,
      if (quantityAmount != null) 'quantity_amount': quantityAmount,
      if (quantityMeasure != null) 'quantity_measure': quantityMeasure,
      if (position != null) 'position': position,
    });
  }

  RecipeIngredientsCompanion copyWith({
    Value<int>? id,
    Value<String>? recipeId,
    Value<String>? foodId,
    Value<double>? quantityAmount,
    Value<QuantityMeasure>? quantityMeasure,
    Value<int>? position,
  }) {
    return RecipeIngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      foodId: foodId ?? this.foodId,
      quantityAmount: quantityAmount ?? this.quantityAmount,
      quantityMeasure: quantityMeasure ?? this.quantityMeasure,
      position: position ?? this.position,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (foodId.present) {
      map['food_id'] = Variable<String>(foodId.value);
    }
    if (quantityAmount.present) {
      map['quantity_amount'] = Variable<double>(quantityAmount.value);
    }
    if (quantityMeasure.present) {
      map['quantity_measure'] = Variable<int>(
        $RecipeIngredientsTable.$converterquantityMeasure.toSql(
          quantityMeasure.value,
        ),
      );
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('foodId: $foodId, ')
          ..write('quantityAmount: $quantityAmount, ')
          ..write('quantityMeasure: $quantityMeasure, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }
}

class $MealSlotsTable extends MealSlots
    with TableInfo<$MealSlotsTable, MealSlotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealSlotsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, position];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_slots';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealSlotRow> instance, {
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
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealSlotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealSlotRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $MealSlotsTable createAlias(String alias) {
    return $MealSlotsTable(attachedDatabase, alias);
  }
}

class MealSlotRow extends DataClass implements Insertable<MealSlotRow> {
  final String id;
  final String name;
  final int position;
  const MealSlotRow({
    required this.id,
    required this.name,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['position'] = Variable<int>(position);
    return map;
  }

  MealSlotsCompanion toCompanion(bool nullToAbsent) {
    return MealSlotsCompanion(
      id: Value(id),
      name: Value(name),
      position: Value(position),
    );
  }

  factory MealSlotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealSlotRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      position: serializer.fromJson<int>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'position': serializer.toJson<int>(position),
    };
  }

  MealSlotRow copyWith({String? id, String? name, int? position}) =>
      MealSlotRow(
        id: id ?? this.id,
        name: name ?? this.name,
        position: position ?? this.position,
      );
  MealSlotRow copyWithCompanion(MealSlotsCompanion data) {
    return MealSlotRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealSlotRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealSlotRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.position == this.position);
}

class MealSlotsCompanion extends UpdateCompanion<MealSlotRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> position;
  final Value<int> rowid;
  const MealSlotsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealSlotsCompanion.insert({
    required String id,
    required String name,
    required int position,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       position = Value(position);
  static Insertable<MealSlotRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealSlotsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? position,
    Value<int>? rowid,
  }) {
    return MealSlotsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
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
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealSlotsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DiaryEntriesTable extends DiaryEntries
    with TableInfo<$DiaryEntriesTable, DiaryEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DiaryEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> day =
      GeneratedColumn<int>(
        'day',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($DiaryEntriesTable.$converterday);
  static const VerificationMeta _mealSlotIdMeta = const VerificationMeta(
    'mealSlotId',
  );
  @override
  late final GeneratedColumn<String> mealSlotId = GeneratedColumn<String>(
    'meal_slot_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES meal_slots (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<DiaryReferenceKind, int>
  referenceKind =
      GeneratedColumn<int>(
        'reference_kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DiaryReferenceKind>(
        $DiaryEntriesTable.$converterreferenceKind,
      );
  static const VerificationMeta _referenceIdMeta = const VerificationMeta(
    'referenceId',
  );
  @override
  late final GeneratedColumn<String> referenceId = GeneratedColumn<String>(
    'reference_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityAmountMeta = const VerificationMeta(
    'quantityAmount',
  );
  @override
  late final GeneratedColumn<double> quantityAmount = GeneratedColumn<double>(
    'quantity_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<QuantityMeasure, int>
  quantityMeasure =
      GeneratedColumn<int>(
        'quantity_measure',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<QuantityMeasure>(
        $DiaryEntriesTable.$converterquantityMeasure,
      );
  @override
  late final GeneratedColumnWithTypeConverter<Nutrients, String> nutrients =
      GeneratedColumn<String>(
        'nutrients',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Nutrients>($DiaryEntriesTable.$converternutrients);
  @override
  late final GeneratedColumnWithTypeConverter<DateTime, int> loggedAt =
      GeneratedColumn<int>(
        'logged_at',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<DateTime>($DiaryEntriesTable.$converterloggedAt);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    day,
    mealSlotId,
    referenceKind,
    referenceId,
    label,
    quantityAmount,
    quantityMeasure,
    nutrients,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'diary_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DiaryEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('meal_slot_id')) {
      context.handle(
        _mealSlotIdMeta,
        mealSlotId.isAcceptableOrUnknown(
          data['meal_slot_id']!,
          _mealSlotIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_mealSlotIdMeta);
    }
    if (data.containsKey('reference_id')) {
      context.handle(
        _referenceIdMeta,
        referenceId.isAcceptableOrUnknown(
          data['reference_id']!,
          _referenceIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referenceIdMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('quantity_amount')) {
      context.handle(
        _quantityAmountMeta,
        quantityAmount.isAcceptableOrUnknown(
          data['quantity_amount']!,
          _quantityAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantityAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DiaryEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DiaryEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      day: $DiaryEntriesTable.$converterday.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}day'],
        )!,
      ),
      mealSlotId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_slot_id'],
      )!,
      referenceKind: $DiaryEntriesTable.$converterreferenceKind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}reference_kind'],
        )!,
      ),
      referenceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reference_id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      quantityAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity_amount'],
      )!,
      quantityMeasure: $DiaryEntriesTable.$converterquantityMeasure.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}quantity_measure'],
        )!,
      ),
      nutrients: $DiaryEntriesTable.$converternutrients.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}nutrients'],
        )!,
      ),
      loggedAt: $DiaryEntriesTable.$converterloggedAt.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}logged_at'],
        )!,
      ),
    );
  }

  @override
  $DiaryEntriesTable createAlias(String alias) {
    return $DiaryEntriesTable(attachedDatabase, alias);
  }

  static TypeConverter<DateTime, int> $converterday =
      const DateTimeMillisConverter();
  static JsonTypeConverter2<DiaryReferenceKind, int, int>
  $converterreferenceKind = const EnumIndexConverter<DiaryReferenceKind>(
    DiaryReferenceKind.values,
  );
  static JsonTypeConverter2<QuantityMeasure, int, int>
  $converterquantityMeasure = const EnumIndexConverter<QuantityMeasure>(
    QuantityMeasure.values,
  );
  static TypeConverter<Nutrients, String> $converternutrients =
      const NutrientsConverter();
  static TypeConverter<DateTime, int> $converterloggedAt =
      const DateTimeMillisConverter();
}

class DiaryEntryRow extends DataClass implements Insertable<DiaryEntryRow> {
  final String id;
  final DateTime day;
  final String mealSlotId;
  final DiaryReferenceKind referenceKind;
  final String referenceId;
  final String label;
  final double quantityAmount;
  final QuantityMeasure quantityMeasure;
  final Nutrients nutrients;
  final DateTime loggedAt;
  const DiaryEntryRow({
    required this.id,
    required this.day,
    required this.mealSlotId,
    required this.referenceKind,
    required this.referenceId,
    required this.label,
    required this.quantityAmount,
    required this.quantityMeasure,
    required this.nutrients,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['day'] = Variable<int>($DiaryEntriesTable.$converterday.toSql(day));
    }
    map['meal_slot_id'] = Variable<String>(mealSlotId);
    {
      map['reference_kind'] = Variable<int>(
        $DiaryEntriesTable.$converterreferenceKind.toSql(referenceKind),
      );
    }
    map['reference_id'] = Variable<String>(referenceId);
    map['label'] = Variable<String>(label);
    map['quantity_amount'] = Variable<double>(quantityAmount);
    {
      map['quantity_measure'] = Variable<int>(
        $DiaryEntriesTable.$converterquantityMeasure.toSql(quantityMeasure),
      );
    }
    {
      map['nutrients'] = Variable<String>(
        $DiaryEntriesTable.$converternutrients.toSql(nutrients),
      );
    }
    {
      map['logged_at'] = Variable<int>(
        $DiaryEntriesTable.$converterloggedAt.toSql(loggedAt),
      );
    }
    return map;
  }

  DiaryEntriesCompanion toCompanion(bool nullToAbsent) {
    return DiaryEntriesCompanion(
      id: Value(id),
      day: Value(day),
      mealSlotId: Value(mealSlotId),
      referenceKind: Value(referenceKind),
      referenceId: Value(referenceId),
      label: Value(label),
      quantityAmount: Value(quantityAmount),
      quantityMeasure: Value(quantityMeasure),
      nutrients: Value(nutrients),
      loggedAt: Value(loggedAt),
    );
  }

  factory DiaryEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DiaryEntryRow(
      id: serializer.fromJson<String>(json['id']),
      day: serializer.fromJson<DateTime>(json['day']),
      mealSlotId: serializer.fromJson<String>(json['mealSlotId']),
      referenceKind: $DiaryEntriesTable.$converterreferenceKind.fromJson(
        serializer.fromJson<int>(json['referenceKind']),
      ),
      referenceId: serializer.fromJson<String>(json['referenceId']),
      label: serializer.fromJson<String>(json['label']),
      quantityAmount: serializer.fromJson<double>(json['quantityAmount']),
      quantityMeasure: $DiaryEntriesTable.$converterquantityMeasure.fromJson(
        serializer.fromJson<int>(json['quantityMeasure']),
      ),
      nutrients: serializer.fromJson<Nutrients>(json['nutrients']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'day': serializer.toJson<DateTime>(day),
      'mealSlotId': serializer.toJson<String>(mealSlotId),
      'referenceKind': serializer.toJson<int>(
        $DiaryEntriesTable.$converterreferenceKind.toJson(referenceKind),
      ),
      'referenceId': serializer.toJson<String>(referenceId),
      'label': serializer.toJson<String>(label),
      'quantityAmount': serializer.toJson<double>(quantityAmount),
      'quantityMeasure': serializer.toJson<int>(
        $DiaryEntriesTable.$converterquantityMeasure.toJson(quantityMeasure),
      ),
      'nutrients': serializer.toJson<Nutrients>(nutrients),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  DiaryEntryRow copyWith({
    String? id,
    DateTime? day,
    String? mealSlotId,
    DiaryReferenceKind? referenceKind,
    String? referenceId,
    String? label,
    double? quantityAmount,
    QuantityMeasure? quantityMeasure,
    Nutrients? nutrients,
    DateTime? loggedAt,
  }) => DiaryEntryRow(
    id: id ?? this.id,
    day: day ?? this.day,
    mealSlotId: mealSlotId ?? this.mealSlotId,
    referenceKind: referenceKind ?? this.referenceKind,
    referenceId: referenceId ?? this.referenceId,
    label: label ?? this.label,
    quantityAmount: quantityAmount ?? this.quantityAmount,
    quantityMeasure: quantityMeasure ?? this.quantityMeasure,
    nutrients: nutrients ?? this.nutrients,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  DiaryEntryRow copyWithCompanion(DiaryEntriesCompanion data) {
    return DiaryEntryRow(
      id: data.id.present ? data.id.value : this.id,
      day: data.day.present ? data.day.value : this.day,
      mealSlotId: data.mealSlotId.present
          ? data.mealSlotId.value
          : this.mealSlotId,
      referenceKind: data.referenceKind.present
          ? data.referenceKind.value
          : this.referenceKind,
      referenceId: data.referenceId.present
          ? data.referenceId.value
          : this.referenceId,
      label: data.label.present ? data.label.value : this.label,
      quantityAmount: data.quantityAmount.present
          ? data.quantityAmount.value
          : this.quantityAmount,
      quantityMeasure: data.quantityMeasure.present
          ? data.quantityMeasure.value
          : this.quantityMeasure,
      nutrients: data.nutrients.present ? data.nutrients.value : this.nutrients,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntryRow(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('referenceKind: $referenceKind, ')
          ..write('referenceId: $referenceId, ')
          ..write('label: $label, ')
          ..write('quantityAmount: $quantityAmount, ')
          ..write('quantityMeasure: $quantityMeasure, ')
          ..write('nutrients: $nutrients, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    day,
    mealSlotId,
    referenceKind,
    referenceId,
    label,
    quantityAmount,
    quantityMeasure,
    nutrients,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DiaryEntryRow &&
          other.id == this.id &&
          other.day == this.day &&
          other.mealSlotId == this.mealSlotId &&
          other.referenceKind == this.referenceKind &&
          other.referenceId == this.referenceId &&
          other.label == this.label &&
          other.quantityAmount == this.quantityAmount &&
          other.quantityMeasure == this.quantityMeasure &&
          other.nutrients == this.nutrients &&
          other.loggedAt == this.loggedAt);
}

class DiaryEntriesCompanion extends UpdateCompanion<DiaryEntryRow> {
  final Value<String> id;
  final Value<DateTime> day;
  final Value<String> mealSlotId;
  final Value<DiaryReferenceKind> referenceKind;
  final Value<String> referenceId;
  final Value<String> label;
  final Value<double> quantityAmount;
  final Value<QuantityMeasure> quantityMeasure;
  final Value<Nutrients> nutrients;
  final Value<DateTime> loggedAt;
  final Value<int> rowid;
  const DiaryEntriesCompanion({
    this.id = const Value.absent(),
    this.day = const Value.absent(),
    this.mealSlotId = const Value.absent(),
    this.referenceKind = const Value.absent(),
    this.referenceId = const Value.absent(),
    this.label = const Value.absent(),
    this.quantityAmount = const Value.absent(),
    this.quantityMeasure = const Value.absent(),
    this.nutrients = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DiaryEntriesCompanion.insert({
    required String id,
    required DateTime day,
    required String mealSlotId,
    required DiaryReferenceKind referenceKind,
    required String referenceId,
    required String label,
    required double quantityAmount,
    required QuantityMeasure quantityMeasure,
    required Nutrients nutrients,
    required DateTime loggedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       day = Value(day),
       mealSlotId = Value(mealSlotId),
       referenceKind = Value(referenceKind),
       referenceId = Value(referenceId),
       label = Value(label),
       quantityAmount = Value(quantityAmount),
       quantityMeasure = Value(quantityMeasure),
       nutrients = Value(nutrients),
       loggedAt = Value(loggedAt);
  static Insertable<DiaryEntryRow> custom({
    Expression<String>? id,
    Expression<int>? day,
    Expression<String>? mealSlotId,
    Expression<int>? referenceKind,
    Expression<String>? referenceId,
    Expression<String>? label,
    Expression<double>? quantityAmount,
    Expression<int>? quantityMeasure,
    Expression<String>? nutrients,
    Expression<int>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (day != null) 'day': day,
      if (mealSlotId != null) 'meal_slot_id': mealSlotId,
      if (referenceKind != null) 'reference_kind': referenceKind,
      if (referenceId != null) 'reference_id': referenceId,
      if (label != null) 'label': label,
      if (quantityAmount != null) 'quantity_amount': quantityAmount,
      if (quantityMeasure != null) 'quantity_measure': quantityMeasure,
      if (nutrients != null) 'nutrients': nutrients,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DiaryEntriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? day,
    Value<String>? mealSlotId,
    Value<DiaryReferenceKind>? referenceKind,
    Value<String>? referenceId,
    Value<String>? label,
    Value<double>? quantityAmount,
    Value<QuantityMeasure>? quantityMeasure,
    Value<Nutrients>? nutrients,
    Value<DateTime>? loggedAt,
    Value<int>? rowid,
  }) {
    return DiaryEntriesCompanion(
      id: id ?? this.id,
      day: day ?? this.day,
      mealSlotId: mealSlotId ?? this.mealSlotId,
      referenceKind: referenceKind ?? this.referenceKind,
      referenceId: referenceId ?? this.referenceId,
      label: label ?? this.label,
      quantityAmount: quantityAmount ?? this.quantityAmount,
      quantityMeasure: quantityMeasure ?? this.quantityMeasure,
      nutrients: nutrients ?? this.nutrients,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (day.present) {
      map['day'] = Variable<int>(
        $DiaryEntriesTable.$converterday.toSql(day.value),
      );
    }
    if (mealSlotId.present) {
      map['meal_slot_id'] = Variable<String>(mealSlotId.value);
    }
    if (referenceKind.present) {
      map['reference_kind'] = Variable<int>(
        $DiaryEntriesTable.$converterreferenceKind.toSql(referenceKind.value),
      );
    }
    if (referenceId.present) {
      map['reference_id'] = Variable<String>(referenceId.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (quantityAmount.present) {
      map['quantity_amount'] = Variable<double>(quantityAmount.value);
    }
    if (quantityMeasure.present) {
      map['quantity_measure'] = Variable<int>(
        $DiaryEntriesTable.$converterquantityMeasure.toSql(
          quantityMeasure.value,
        ),
      );
    }
    if (nutrients.present) {
      map['nutrients'] = Variable<String>(
        $DiaryEntriesTable.$converternutrients.toSql(nutrients.value),
      );
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<int>(
        $DiaryEntriesTable.$converterloggedAt.toSql(loggedAt.value),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DiaryEntriesCompanion(')
          ..write('id: $id, ')
          ..write('day: $day, ')
          ..write('mealSlotId: $mealSlotId, ')
          ..write('referenceKind: $referenceKind, ')
          ..write('referenceId: $referenceId, ')
          ..write('label: $label, ')
          ..write('quantityAmount: $quantityAmount, ')
          ..write('quantityMeasure: $quantityMeasure, ')
          ..write('nutrients: $nutrients, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsRowsTable extends AppSettingsRows
    with TableInfo<$AppSettingsRowsTable, AppSettingsRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<UnitSystem, int> unitSystem =
      GeneratedColumn<int>(
        'unit_system',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<UnitSystem>($AppSettingsRowsTable.$converterunitSystem);
  @override
  late final GeneratedColumnWithTypeConverter<VdRegion, int> vdRegion =
      GeneratedColumn<int>(
        'vd_region',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<VdRegion>($AppSettingsRowsTable.$convertervdRegion);
  static const VerificationMeta _languageCodeMeta = const VerificationMeta(
    'languageCode',
  );
  @override
  late final GeneratedColumn<String> languageCode = GeneratedColumn<String>(
    'language_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Nutrients?, String> dailyTarget =
      GeneratedColumn<String>(
        'daily_target',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Nutrients?>($AppSettingsRowsTable.$converterdailyTargetn);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    unitSystem,
    vdRegion,
    languageCode,
    dailyTarget,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingsRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language_code')) {
      context.handle(
        _languageCodeMeta,
        languageCode.isAcceptableOrUnknown(
          data['language_code']!,
          _languageCodeMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppSettingsRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingsRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      unitSystem: $AppSettingsRowsTable.$converterunitSystem.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}unit_system'],
        )!,
      ),
      vdRegion: $AppSettingsRowsTable.$convertervdRegion.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}vd_region'],
        )!,
      ),
      languageCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language_code'],
      ),
      dailyTarget: $AppSettingsRowsTable.$converterdailyTargetn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}daily_target'],
        ),
      ),
    );
  }

  @override
  $AppSettingsRowsTable createAlias(String alias) {
    return $AppSettingsRowsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<UnitSystem, int, int> $converterunitSystem =
      const EnumIndexConverter<UnitSystem>(UnitSystem.values);
  static JsonTypeConverter2<VdRegion, int, int> $convertervdRegion =
      const EnumIndexConverter<VdRegion>(VdRegion.values);
  static TypeConverter<Nutrients, String> $converterdailyTarget =
      const NutrientsConverter();
  static TypeConverter<Nutrients?, String?> $converterdailyTargetn =
      NullAwareTypeConverter.wrap($converterdailyTarget);
}

class AppSettingsRow extends DataClass implements Insertable<AppSettingsRow> {
  final int id;
  final UnitSystem unitSystem;
  final VdRegion vdRegion;
  final String? languageCode;
  final Nutrients? dailyTarget;
  const AppSettingsRow({
    required this.id,
    required this.unitSystem,
    required this.vdRegion,
    this.languageCode,
    this.dailyTarget,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['unit_system'] = Variable<int>(
        $AppSettingsRowsTable.$converterunitSystem.toSql(unitSystem),
      );
    }
    {
      map['vd_region'] = Variable<int>(
        $AppSettingsRowsTable.$convertervdRegion.toSql(vdRegion),
      );
    }
    if (!nullToAbsent || languageCode != null) {
      map['language_code'] = Variable<String>(languageCode);
    }
    if (!nullToAbsent || dailyTarget != null) {
      map['daily_target'] = Variable<String>(
        $AppSettingsRowsTable.$converterdailyTargetn.toSql(dailyTarget),
      );
    }
    return map;
  }

  AppSettingsRowsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsRowsCompanion(
      id: Value(id),
      unitSystem: Value(unitSystem),
      vdRegion: Value(vdRegion),
      languageCode: languageCode == null && nullToAbsent
          ? const Value.absent()
          : Value(languageCode),
      dailyTarget: dailyTarget == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyTarget),
    );
  }

  factory AppSettingsRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingsRow(
      id: serializer.fromJson<int>(json['id']),
      unitSystem: $AppSettingsRowsTable.$converterunitSystem.fromJson(
        serializer.fromJson<int>(json['unitSystem']),
      ),
      vdRegion: $AppSettingsRowsTable.$convertervdRegion.fromJson(
        serializer.fromJson<int>(json['vdRegion']),
      ),
      languageCode: serializer.fromJson<String?>(json['languageCode']),
      dailyTarget: serializer.fromJson<Nutrients?>(json['dailyTarget']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'unitSystem': serializer.toJson<int>(
        $AppSettingsRowsTable.$converterunitSystem.toJson(unitSystem),
      ),
      'vdRegion': serializer.toJson<int>(
        $AppSettingsRowsTable.$convertervdRegion.toJson(vdRegion),
      ),
      'languageCode': serializer.toJson<String?>(languageCode),
      'dailyTarget': serializer.toJson<Nutrients?>(dailyTarget),
    };
  }

  AppSettingsRow copyWith({
    int? id,
    UnitSystem? unitSystem,
    VdRegion? vdRegion,
    Value<String?> languageCode = const Value.absent(),
    Value<Nutrients?> dailyTarget = const Value.absent(),
  }) => AppSettingsRow(
    id: id ?? this.id,
    unitSystem: unitSystem ?? this.unitSystem,
    vdRegion: vdRegion ?? this.vdRegion,
    languageCode: languageCode.present ? languageCode.value : this.languageCode,
    dailyTarget: dailyTarget.present ? dailyTarget.value : this.dailyTarget,
  );
  AppSettingsRow copyWithCompanion(AppSettingsRowsCompanion data) {
    return AppSettingsRow(
      id: data.id.present ? data.id.value : this.id,
      unitSystem: data.unitSystem.present
          ? data.unitSystem.value
          : this.unitSystem,
      vdRegion: data.vdRegion.present ? data.vdRegion.value : this.vdRegion,
      languageCode: data.languageCode.present
          ? data.languageCode.value
          : this.languageCode,
      dailyTarget: data.dailyTarget.present
          ? data.dailyTarget.value
          : this.dailyTarget,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRow(')
          ..write('id: $id, ')
          ..write('unitSystem: $unitSystem, ')
          ..write('vdRegion: $vdRegion, ')
          ..write('languageCode: $languageCode, ')
          ..write('dailyTarget: $dailyTarget')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, unitSystem, vdRegion, languageCode, dailyTarget);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingsRow &&
          other.id == this.id &&
          other.unitSystem == this.unitSystem &&
          other.vdRegion == this.vdRegion &&
          other.languageCode == this.languageCode &&
          other.dailyTarget == this.dailyTarget);
}

class AppSettingsRowsCompanion extends UpdateCompanion<AppSettingsRow> {
  final Value<int> id;
  final Value<UnitSystem> unitSystem;
  final Value<VdRegion> vdRegion;
  final Value<String?> languageCode;
  final Value<Nutrients?> dailyTarget;
  const AppSettingsRowsCompanion({
    this.id = const Value.absent(),
    this.unitSystem = const Value.absent(),
    this.vdRegion = const Value.absent(),
    this.languageCode = const Value.absent(),
    this.dailyTarget = const Value.absent(),
  });
  AppSettingsRowsCompanion.insert({
    this.id = const Value.absent(),
    required UnitSystem unitSystem,
    required VdRegion vdRegion,
    this.languageCode = const Value.absent(),
    this.dailyTarget = const Value.absent(),
  }) : unitSystem = Value(unitSystem),
       vdRegion = Value(vdRegion);
  static Insertable<AppSettingsRow> custom({
    Expression<int>? id,
    Expression<int>? unitSystem,
    Expression<int>? vdRegion,
    Expression<String>? languageCode,
    Expression<String>? dailyTarget,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (unitSystem != null) 'unit_system': unitSystem,
      if (vdRegion != null) 'vd_region': vdRegion,
      if (languageCode != null) 'language_code': languageCode,
      if (dailyTarget != null) 'daily_target': dailyTarget,
    });
  }

  AppSettingsRowsCompanion copyWith({
    Value<int>? id,
    Value<UnitSystem>? unitSystem,
    Value<VdRegion>? vdRegion,
    Value<String?>? languageCode,
    Value<Nutrients?>? dailyTarget,
  }) {
    return AppSettingsRowsCompanion(
      id: id ?? this.id,
      unitSystem: unitSystem ?? this.unitSystem,
      vdRegion: vdRegion ?? this.vdRegion,
      languageCode: languageCode ?? this.languageCode,
      dailyTarget: dailyTarget ?? this.dailyTarget,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (unitSystem.present) {
      map['unit_system'] = Variable<int>(
        $AppSettingsRowsTable.$converterunitSystem.toSql(unitSystem.value),
      );
    }
    if (vdRegion.present) {
      map['vd_region'] = Variable<int>(
        $AppSettingsRowsTable.$convertervdRegion.toSql(vdRegion.value),
      );
    }
    if (languageCode.present) {
      map['language_code'] = Variable<String>(languageCode.value);
    }
    if (dailyTarget.present) {
      map['daily_target'] = Variable<String>(
        $AppSettingsRowsTable.$converterdailyTargetn.toSql(dailyTarget.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsRowsCompanion(')
          ..write('id: $id, ')
          ..write('unitSystem: $unitSystem, ')
          ..write('vdRegion: $vdRegion, ')
          ..write('languageCode: $languageCode, ')
          ..write('dailyTarget: $dailyTarget')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FoodsTable foods = $FoodsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeIngredientsTable recipeIngredients =
      $RecipeIngredientsTable(this);
  late final $MealSlotsTable mealSlots = $MealSlotsTable(this);
  late final $DiaryEntriesTable diaryEntries = $DiaryEntriesTable(this);
  late final $AppSettingsRowsTable appSettingsRows = $AppSettingsRowsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    foods,
    recipes,
    recipeIngredients,
    mealSlots,
    diaryEntries,
    appSettingsRows,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recipe_ingredients', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$FoodsTableCreateCompanionBuilder =
    FoodsCompanion Function({
      required String id,
      required String name,
      Value<String?> brand,
      Value<String?> barcode,
      required FoodSource source,
      required NutrientBasis basis,
      required Nutrients nutrients,
      Value<double?> servingSizeMetric,
      Value<ServingUnit?> servingUnit,
      Value<String?> householdMeasure,
      Value<bool> energyIsManual,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FoodsTableUpdateCompanionBuilder =
    FoodsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> brand,
      Value<String?> barcode,
      Value<FoodSource> source,
      Value<NutrientBasis> basis,
      Value<Nutrients> nutrients,
      Value<double?> servingSizeMetric,
      Value<ServingUnit?> servingUnit,
      Value<String?> householdMeasure,
      Value<bool> energyIsManual,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$FoodsTableReferences
    extends BaseReferences<_$AppDatabase, $FoodsTable, FoodRow> {
  $$FoodsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredientRow>>
  _recipeIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeIngredients,
        aliasName: 'foods__id__recipe_ingredients__food_id',
      );

  $$RecipeIngredientsTableProcessedTableManager get recipeIngredientsRefs {
    final manager = $$RecipeIngredientsTableTableManager(
      $_db,
      $_db.recipeIngredients,
    ).filter((f) => f.foodId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FoodsTableFilterComposer extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableFilterComposer({
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

  ColumnFilters<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<FoodSource, FoodSource, int> get source =>
      $composableBuilder(
        column: $table.source,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<NutrientBasis, NutrientBasis, int> get basis =>
      $composableBuilder(
        column: $table.basis,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Nutrients, Nutrients, String> get nutrients =>
      $composableBuilder(
        column: $table.nutrients,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<double> get servingSizeMetric => $composableBuilder(
    column: $table.servingSizeMetric,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ServingUnit?, ServingUnit, int>
  get servingUnit => $composableBuilder(
    column: $table.servingUnit,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get householdMeasure => $composableBuilder(
    column: $table.householdMeasure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get energyIsManual => $composableBuilder(
    column: $table.energyIsManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> recipeIngredientsRefs(
    Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f,
  ) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeIngredients,
      getReferencedColumn: (t) => t.foodId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.recipeIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FoodsTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableOrderingComposer({
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

  ColumnOrderings<String> get brand => $composableBuilder(
    column: $table.brand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get basis => $composableBuilder(
    column: $table.basis,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutrients => $composableBuilder(
    column: $table.nutrients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servingSizeMetric => $composableBuilder(
    column: $table.servingSizeMetric,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servingUnit => $composableBuilder(
    column: $table.servingUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get householdMeasure => $composableBuilder(
    column: $table.householdMeasure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get energyIsManual => $composableBuilder(
    column: $table.energyIsManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FoodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodsTable> {
  $$FoodsTableAnnotationComposer({
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

  GeneratedColumn<String> get brand =>
      $composableBuilder(column: $table.brand, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FoodSource, int> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumnWithTypeConverter<NutrientBasis, int> get basis =>
      $composableBuilder(column: $table.basis, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Nutrients, String> get nutrients =>
      $composableBuilder(column: $table.nutrients, builder: (column) => column);

  GeneratedColumn<double> get servingSizeMetric => $composableBuilder(
    column: $table.servingSizeMetric,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<ServingUnit?, int> get servingUnit =>
      $composableBuilder(
        column: $table.servingUnit,
        builder: (column) => column,
      );

  GeneratedColumn<String> get householdMeasure => $composableBuilder(
    column: $table.householdMeasure,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get energyIsManual => $composableBuilder(
    column: $table.energyIsManual,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recipeIngredientsRefs<T extends Object>(
    Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f,
  ) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeIngredients,
          getReferencedColumn: (t) => t.foodId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FoodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FoodsTable,
          FoodRow,
          $$FoodsTableFilterComposer,
          $$FoodsTableOrderingComposer,
          $$FoodsTableAnnotationComposer,
          $$FoodsTableCreateCompanionBuilder,
          $$FoodsTableUpdateCompanionBuilder,
          (FoodRow, $$FoodsTableReferences),
          FoodRow,
          PrefetchHooks Function({bool recipeIngredientsRefs})
        > {
  $$FoodsTableTableManager(_$AppDatabase db, $FoodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> brand = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<FoodSource> source = const Value.absent(),
                Value<NutrientBasis> basis = const Value.absent(),
                Value<Nutrients> nutrients = const Value.absent(),
                Value<double?> servingSizeMetric = const Value.absent(),
                Value<ServingUnit?> servingUnit = const Value.absent(),
                Value<String?> householdMeasure = const Value.absent(),
                Value<bool> energyIsManual = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion(
                id: id,
                name: name,
                brand: brand,
                barcode: barcode,
                source: source,
                basis: basis,
                nutrients: nutrients,
                servingSizeMetric: servingSizeMetric,
                servingUnit: servingUnit,
                householdMeasure: householdMeasure,
                energyIsManual: energyIsManual,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> brand = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                required FoodSource source,
                required NutrientBasis basis,
                required Nutrients nutrients,
                Value<double?> servingSizeMetric = const Value.absent(),
                Value<ServingUnit?> servingUnit = const Value.absent(),
                Value<String?> householdMeasure = const Value.absent(),
                Value<bool> energyIsManual = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FoodsCompanion.insert(
                id: id,
                name: name,
                brand: brand,
                barcode: barcode,
                source: source,
                basis: basis,
                nutrients: nutrients,
                servingSizeMetric: servingSizeMetric,
                servingUnit: servingUnit,
                householdMeasure: householdMeasure,
                energyIsManual: energyIsManual,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$FoodsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({recipeIngredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recipeIngredientsRefs) db.recipeIngredients,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeIngredientsRefs)
                    await $_getPrefetchedData<
                      FoodRow,
                      $FoodsTable,
                      RecipeIngredientRow
                    >(
                      currentTable: table,
                      referencedTable: $$FoodsTableReferences
                          ._recipeIngredientsRefsTable(db),
                      managerFromTypedResult: (p0) => $$FoodsTableReferences(
                        db,
                        table,
                        p0,
                      ).recipeIngredientsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.foodId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$FoodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FoodsTable,
      FoodRow,
      $$FoodsTableFilterComposer,
      $$FoodsTableOrderingComposer,
      $$FoodsTableAnnotationComposer,
      $$FoodsTableCreateCompanionBuilder,
      $$FoodsTableUpdateCompanionBuilder,
      (FoodRow, $$FoodsTableReferences),
      FoodRow,
      PrefetchHooks Function({bool recipeIngredientsRefs})
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      required String id,
      required String name,
      required double yieldServings,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<double> yieldServings,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, RecipeRow> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredientRow>>
  _recipeIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeIngredients,
        aliasName: 'recipes__id__recipe_ingredients__recipe_id',
      );

  $$RecipeIngredientsTableProcessedTableManager get recipeIngredientsRefs {
    final manager = $$RecipeIngredientsTableTableManager(
      $_db,
      $_db.recipeIngredients,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeIngredientsRefsTable($_db),
    );
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

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get yieldServings => $composableBuilder(
    column: $table.yieldServings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get createdAt =>
      $composableBuilder(
        column: $table.createdAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get updatedAt =>
      $composableBuilder(
        column: $table.updatedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  Expression<bool> recipeIngredientsRefs(
    Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f,
  ) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeIngredients,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.recipeIngredients,
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

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get yieldServings => $composableBuilder(
    column: $table.yieldServings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
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

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get yieldServings => $composableBuilder(
    column: $table.yieldServings,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<DateTime, int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recipeIngredientsRefs<T extends Object>(
    Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f,
  ) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeIngredients,
          getReferencedColumn: (t) => t.recipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeIngredients,
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
          RecipeRow,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (RecipeRow, $$RecipesTableReferences),
          RecipeRow,
          PrefetchHooks Function({bool recipeIngredientsRefs})
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
                Value<String> name = const Value.absent(),
                Value<double> yieldServings = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                name: name,
                yieldServings: yieldServings,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required double yieldServings,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                name: name,
                yieldServings: yieldServings,
                createdAt: createdAt,
                updatedAt: updatedAt,
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
          prefetchHooksCallback: ({recipeIngredientsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (recipeIngredientsRefs) db.recipeIngredients,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (recipeIngredientsRefs)
                    await $_getPrefetchedData<
                      RecipeRow,
                      $RecipesTable,
                      RecipeIngredientRow
                    >(
                      currentTable: table,
                      referencedTable: $$RecipesTableReferences
                          ._recipeIngredientsRefsTable(db),
                      managerFromTypedResult: (p0) => $$RecipesTableReferences(
                        db,
                        table,
                        p0,
                      ).recipeIngredientsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.recipeId == item.id),
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
      RecipeRow,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (RecipeRow, $$RecipesTableReferences),
      RecipeRow,
      PrefetchHooks Function({bool recipeIngredientsRefs})
    >;
typedef $$RecipeIngredientsTableCreateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<int> id,
      required String recipeId,
      required String foodId,
      required double quantityAmount,
      required QuantityMeasure quantityMeasure,
      required int position,
    });
typedef $$RecipeIngredientsTableUpdateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<int> id,
      Value<String> recipeId,
      Value<String> foodId,
      Value<double> quantityAmount,
      Value<QuantityMeasure> quantityMeasure,
      Value<int> position,
    });

final class $$RecipeIngredientsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredientRow
        > {
  $$RecipeIngredientsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias('recipe_ingredients__recipe_id__recipes__id');

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

  static $FoodsTable _foodIdTable(_$AppDatabase db) =>
      db.foods.createAlias('recipe_ingredients__food_id__foods__id');

  $$FoodsTableProcessedTableManager get foodId {
    final $_column = $_itemColumn<String>('food_id')!;

    final manager = $$FoodsTableTableManager(
      $_db,
      $_db.foods,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_foodIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityAmount => $composableBuilder(
    column: $table.quantityAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuantityMeasure, QuantityMeasure, int>
  get quantityMeasure => $composableBuilder(
    column: $table.quantityMeasure,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
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

  $$FoodsTableFilterComposer get foodId {
    final $$FoodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableFilterComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityAmount => $composableBuilder(
    column: $table.quantityAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityMeasure => $composableBuilder(
    column: $table.quantityMeasure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
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

  $$FoodsTableOrderingComposer get foodId {
    final $$FoodsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableOrderingComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantityAmount => $composableBuilder(
    column: $table.quantityAmount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QuantityMeasure, int> get quantityMeasure =>
      $composableBuilder(
        column: $table.quantityMeasure,
        builder: (column) => column,
      );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

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

  $$FoodsTableAnnotationComposer get foodId {
    final $$FoodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.foodId,
      referencedTable: $db.foods,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FoodsTableAnnotationComposer(
            $db: $db,
            $table: $db.foods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredientRow,
          $$RecipeIngredientsTableFilterComposer,
          $$RecipeIngredientsTableOrderingComposer,
          $$RecipeIngredientsTableAnnotationComposer,
          $$RecipeIngredientsTableCreateCompanionBuilder,
          $$RecipeIngredientsTableUpdateCompanionBuilder,
          (RecipeIngredientRow, $$RecipeIngredientsTableReferences),
          RecipeIngredientRow,
          PrefetchHooks Function({bool recipeId, bool foodId})
        > {
  $$RecipeIngredientsTableTableManager(
    _$AppDatabase db,
    $RecipeIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<String> foodId = const Value.absent(),
                Value<double> quantityAmount = const Value.absent(),
                Value<QuantityMeasure> quantityMeasure = const Value.absent(),
                Value<int> position = const Value.absent(),
              }) => RecipeIngredientsCompanion(
                id: id,
                recipeId: recipeId,
                foodId: foodId,
                quantityAmount: quantityAmount,
                quantityMeasure: quantityMeasure,
                position: position,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String recipeId,
                required String foodId,
                required double quantityAmount,
                required QuantityMeasure quantityMeasure,
                required int position,
              }) => RecipeIngredientsCompanion.insert(
                id: id,
                recipeId: recipeId,
                foodId: foodId,
                quantityAmount: quantityAmount,
                quantityMeasure: quantityMeasure,
                position: position,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeIngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false, foodId = false}) {
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
                                referencedTable:
                                    $$RecipeIngredientsTableReferences
                                        ._recipeIdTable(db),
                                referencedColumn:
                                    $$RecipeIngredientsTableReferences
                                        ._recipeIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (foodId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.foodId,
                                referencedTable:
                                    $$RecipeIngredientsTableReferences
                                        ._foodIdTable(db),
                                referencedColumn:
                                    $$RecipeIngredientsTableReferences
                                        ._foodIdTable(db)
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

typedef $$RecipeIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeIngredientsTable,
      RecipeIngredientRow,
      $$RecipeIngredientsTableFilterComposer,
      $$RecipeIngredientsTableOrderingComposer,
      $$RecipeIngredientsTableAnnotationComposer,
      $$RecipeIngredientsTableCreateCompanionBuilder,
      $$RecipeIngredientsTableUpdateCompanionBuilder,
      (RecipeIngredientRow, $$RecipeIngredientsTableReferences),
      RecipeIngredientRow,
      PrefetchHooks Function({bool recipeId, bool foodId})
    >;
typedef $$MealSlotsTableCreateCompanionBuilder =
    MealSlotsCompanion Function({
      required String id,
      required String name,
      required int position,
      Value<int> rowid,
    });
typedef $$MealSlotsTableUpdateCompanionBuilder =
    MealSlotsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> position,
      Value<int> rowid,
    });

final class $$MealSlotsTableReferences
    extends BaseReferences<_$AppDatabase, $MealSlotsTable, MealSlotRow> {
  $$MealSlotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DiaryEntriesTable, List<DiaryEntryRow>>
  _diaryEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.diaryEntries,
    aliasName: 'meal_slots__id__diary_entries__meal_slot_id',
  );

  $$DiaryEntriesTableProcessedTableManager get diaryEntriesRefs {
    final manager = $$DiaryEntriesTableTableManager(
      $_db,
      $_db.diaryEntries,
    ).filter((f) => f.mealSlotId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_diaryEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$MealSlotsTableFilterComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableFilterComposer({
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

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> diaryEntriesRefs(
    Expression<bool> Function($$DiaryEntriesTableFilterComposer f) f,
  ) {
    final $$DiaryEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.mealSlotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableFilterComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealSlotsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableOrderingComposer({
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

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealSlotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealSlotsTable> {
  $$MealSlotsTableAnnotationComposer({
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

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  Expression<T> diaryEntriesRefs<T extends Object>(
    Expression<T> Function($$DiaryEntriesTableAnnotationComposer a) f,
  ) {
    final $$DiaryEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.diaryEntries,
      getReferencedColumn: (t) => t.mealSlotId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DiaryEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.diaryEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$MealSlotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealSlotsTable,
          MealSlotRow,
          $$MealSlotsTableFilterComposer,
          $$MealSlotsTableOrderingComposer,
          $$MealSlotsTableAnnotationComposer,
          $$MealSlotsTableCreateCompanionBuilder,
          $$MealSlotsTableUpdateCompanionBuilder,
          (MealSlotRow, $$MealSlotsTableReferences),
          MealSlotRow,
          PrefetchHooks Function({bool diaryEntriesRefs})
        > {
  $$MealSlotsTableTableManager(_$AppDatabase db, $MealSlotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealSlotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealSlotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealSlotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealSlotsCompanion(
                id: id,
                name: name,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int position,
                Value<int> rowid = const Value.absent(),
              }) => MealSlotsCompanion.insert(
                id: id,
                name: name,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MealSlotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({diaryEntriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (diaryEntriesRefs) db.diaryEntries],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (diaryEntriesRefs)
                    await $_getPrefetchedData<
                      MealSlotRow,
                      $MealSlotsTable,
                      DiaryEntryRow
                    >(
                      currentTable: table,
                      referencedTable: $$MealSlotsTableReferences
                          ._diaryEntriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$MealSlotsTableReferences(
                            db,
                            table,
                            p0,
                          ).diaryEntriesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.mealSlotId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$MealSlotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealSlotsTable,
      MealSlotRow,
      $$MealSlotsTableFilterComposer,
      $$MealSlotsTableOrderingComposer,
      $$MealSlotsTableAnnotationComposer,
      $$MealSlotsTableCreateCompanionBuilder,
      $$MealSlotsTableUpdateCompanionBuilder,
      (MealSlotRow, $$MealSlotsTableReferences),
      MealSlotRow,
      PrefetchHooks Function({bool diaryEntriesRefs})
    >;
typedef $$DiaryEntriesTableCreateCompanionBuilder =
    DiaryEntriesCompanion Function({
      required String id,
      required DateTime day,
      required String mealSlotId,
      required DiaryReferenceKind referenceKind,
      required String referenceId,
      required String label,
      required double quantityAmount,
      required QuantityMeasure quantityMeasure,
      required Nutrients nutrients,
      required DateTime loggedAt,
      Value<int> rowid,
    });
typedef $$DiaryEntriesTableUpdateCompanionBuilder =
    DiaryEntriesCompanion Function({
      Value<String> id,
      Value<DateTime> day,
      Value<String> mealSlotId,
      Value<DiaryReferenceKind> referenceKind,
      Value<String> referenceId,
      Value<String> label,
      Value<double> quantityAmount,
      Value<QuantityMeasure> quantityMeasure,
      Value<Nutrients> nutrients,
      Value<DateTime> loggedAt,
      Value<int> rowid,
    });

final class $$DiaryEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $DiaryEntriesTable, DiaryEntryRow> {
  $$DiaryEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $MealSlotsTable _mealSlotIdTable(_$AppDatabase db) =>
      db.mealSlots.createAlias('diary_entries__meal_slot_id__meal_slots__id');

  $$MealSlotsTableProcessedTableManager get mealSlotId {
    final $_column = $_itemColumn<String>('meal_slot_id')!;

    final manager = $$MealSlotsTableTableManager(
      $_db,
      $_db.mealSlots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mealSlotIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DiaryEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableFilterComposer({
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

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get day =>
      $composableBuilder(
        column: $table.day,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DiaryReferenceKind, DiaryReferenceKind, int>
  get referenceKind => $composableBuilder(
    column: $table.referenceKind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantityAmount => $composableBuilder(
    column: $table.quantityAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<QuantityMeasure, QuantityMeasure, int>
  get quantityMeasure => $composableBuilder(
    column: $table.quantityMeasure,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Nutrients, Nutrients, String> get nutrients =>
      $composableBuilder(
        column: $table.nutrients,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<DateTime, DateTime, int> get loggedAt =>
      $composableBuilder(
        column: $table.loggedAt,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$MealSlotsTableFilterComposer get mealSlotId {
    final $$MealSlotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableFilterComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referenceKind => $composableBuilder(
    column: $table.referenceKind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantityAmount => $composableBuilder(
    column: $table.quantityAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantityMeasure => $composableBuilder(
    column: $table.quantityMeasure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nutrients => $composableBuilder(
    column: $table.nutrients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$MealSlotsTableOrderingComposer get mealSlotId {
    final $$MealSlotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableOrderingComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DiaryEntriesTable> {
  $$DiaryEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DiaryReferenceKind, int> get referenceKind =>
      $composableBuilder(
        column: $table.referenceKind,
        builder: (column) => column,
      );

  GeneratedColumn<String> get referenceId => $composableBuilder(
    column: $table.referenceId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<double> get quantityAmount => $composableBuilder(
    column: $table.quantityAmount,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<QuantityMeasure, int> get quantityMeasure =>
      $composableBuilder(
        column: $table.quantityMeasure,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Nutrients, String> get nutrients =>
      $composableBuilder(column: $table.nutrients, builder: (column) => column);

  GeneratedColumnWithTypeConverter<DateTime, int> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);

  $$MealSlotsTableAnnotationComposer get mealSlotId {
    final $$MealSlotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.mealSlotId,
      referencedTable: $db.mealSlots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealSlotsTableAnnotationComposer(
            $db: $db,
            $table: $db.mealSlots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DiaryEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DiaryEntriesTable,
          DiaryEntryRow,
          $$DiaryEntriesTableFilterComposer,
          $$DiaryEntriesTableOrderingComposer,
          $$DiaryEntriesTableAnnotationComposer,
          $$DiaryEntriesTableCreateCompanionBuilder,
          $$DiaryEntriesTableUpdateCompanionBuilder,
          (DiaryEntryRow, $$DiaryEntriesTableReferences),
          DiaryEntryRow,
          PrefetchHooks Function({bool mealSlotId})
        > {
  $$DiaryEntriesTableTableManager(_$AppDatabase db, $DiaryEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DiaryEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DiaryEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DiaryEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> day = const Value.absent(),
                Value<String> mealSlotId = const Value.absent(),
                Value<DiaryReferenceKind> referenceKind = const Value.absent(),
                Value<String> referenceId = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<double> quantityAmount = const Value.absent(),
                Value<QuantityMeasure> quantityMeasure = const Value.absent(),
                Value<Nutrients> nutrients = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DiaryEntriesCompanion(
                id: id,
                day: day,
                mealSlotId: mealSlotId,
                referenceKind: referenceKind,
                referenceId: referenceId,
                label: label,
                quantityAmount: quantityAmount,
                quantityMeasure: quantityMeasure,
                nutrients: nutrients,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime day,
                required String mealSlotId,
                required DiaryReferenceKind referenceKind,
                required String referenceId,
                required String label,
                required double quantityAmount,
                required QuantityMeasure quantityMeasure,
                required Nutrients nutrients,
                required DateTime loggedAt,
                Value<int> rowid = const Value.absent(),
              }) => DiaryEntriesCompanion.insert(
                id: id,
                day: day,
                mealSlotId: mealSlotId,
                referenceKind: referenceKind,
                referenceId: referenceId,
                label: label,
                quantityAmount: quantityAmount,
                quantityMeasure: quantityMeasure,
                nutrients: nutrients,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DiaryEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({mealSlotId = false}) {
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
                    if (mealSlotId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.mealSlotId,
                                referencedTable: $$DiaryEntriesTableReferences
                                    ._mealSlotIdTable(db),
                                referencedColumn: $$DiaryEntriesTableReferences
                                    ._mealSlotIdTable(db)
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

typedef $$DiaryEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DiaryEntriesTable,
      DiaryEntryRow,
      $$DiaryEntriesTableFilterComposer,
      $$DiaryEntriesTableOrderingComposer,
      $$DiaryEntriesTableAnnotationComposer,
      $$DiaryEntriesTableCreateCompanionBuilder,
      $$DiaryEntriesTableUpdateCompanionBuilder,
      (DiaryEntryRow, $$DiaryEntriesTableReferences),
      DiaryEntryRow,
      PrefetchHooks Function({bool mealSlotId})
    >;
typedef $$AppSettingsRowsTableCreateCompanionBuilder =
    AppSettingsRowsCompanion Function({
      Value<int> id,
      required UnitSystem unitSystem,
      required VdRegion vdRegion,
      Value<String?> languageCode,
      Value<Nutrients?> dailyTarget,
    });
typedef $$AppSettingsRowsTableUpdateCompanionBuilder =
    AppSettingsRowsCompanion Function({
      Value<int> id,
      Value<UnitSystem> unitSystem,
      Value<VdRegion> vdRegion,
      Value<String?> languageCode,
      Value<Nutrients?> dailyTarget,
    });

class $$AppSettingsRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<UnitSystem, UnitSystem, int> get unitSystem =>
      $composableBuilder(
        column: $table.unitSystem,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<VdRegion, VdRegion, int> get vdRegion =>
      $composableBuilder(
        column: $table.vdRegion,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Nutrients?, Nutrients, String>
  get dailyTarget => $composableBuilder(
    column: $table.dailyTarget,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$AppSettingsRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitSystem => $composableBuilder(
    column: $table.unitSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get vdRegion => $composableBuilder(
    column: $table.vdRegion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dailyTarget => $composableBuilder(
    column: $table.dailyTarget,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsRowsTable> {
  $$AppSettingsRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<UnitSystem, int> get unitSystem =>
      $composableBuilder(
        column: $table.unitSystem,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<VdRegion, int> get vdRegion =>
      $composableBuilder(column: $table.vdRegion, builder: (column) => column);

  GeneratedColumn<String> get languageCode => $composableBuilder(
    column: $table.languageCode,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Nutrients?, String> get dailyTarget =>
      $composableBuilder(
        column: $table.dailyTarget,
        builder: (column) => column,
      );
}

class $$AppSettingsRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsRowsTable,
          AppSettingsRow,
          $$AppSettingsRowsTableFilterComposer,
          $$AppSettingsRowsTableOrderingComposer,
          $$AppSettingsRowsTableAnnotationComposer,
          $$AppSettingsRowsTableCreateCompanionBuilder,
          $$AppSettingsRowsTableUpdateCompanionBuilder,
          (
            AppSettingsRow,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsRowsTable,
              AppSettingsRow
            >,
          ),
          AppSettingsRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsRowsTableTableManager(
    _$AppDatabase db,
    $AppSettingsRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<UnitSystem> unitSystem = const Value.absent(),
                Value<VdRegion> vdRegion = const Value.absent(),
                Value<String?> languageCode = const Value.absent(),
                Value<Nutrients?> dailyTarget = const Value.absent(),
              }) => AppSettingsRowsCompanion(
                id: id,
                unitSystem: unitSystem,
                vdRegion: vdRegion,
                languageCode: languageCode,
                dailyTarget: dailyTarget,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required UnitSystem unitSystem,
                required VdRegion vdRegion,
                Value<String?> languageCode = const Value.absent(),
                Value<Nutrients?> dailyTarget = const Value.absent(),
              }) => AppSettingsRowsCompanion.insert(
                id: id,
                unitSystem: unitSystem,
                vdRegion: vdRegion,
                languageCode: languageCode,
                dailyTarget: dailyTarget,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsRowsTable,
      AppSettingsRow,
      $$AppSettingsRowsTableFilterComposer,
      $$AppSettingsRowsTableOrderingComposer,
      $$AppSettingsRowsTableAnnotationComposer,
      $$AppSettingsRowsTableCreateCompanionBuilder,
      $$AppSettingsRowsTableUpdateCompanionBuilder,
      (
        AppSettingsRow,
        BaseReferences<_$AppDatabase, $AppSettingsRowsTable, AppSettingsRow>,
      ),
      AppSettingsRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FoodsTableTableManager get foods =>
      $$FoodsTableTableManager(_db, _db.foods);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeIngredientsTableTableManager get recipeIngredients =>
      $$RecipeIngredientsTableTableManager(_db, _db.recipeIngredients);
  $$MealSlotsTableTableManager get mealSlots =>
      $$MealSlotsTableTableManager(_db, _db.mealSlots);
  $$DiaryEntriesTableTableManager get diaryEntries =>
      $$DiaryEntriesTableTableManager(_db, _db.diaryEntries);
  $$AppSettingsRowsTableTableManager get appSettingsRows =>
      $$AppSettingsRowsTableTableManager(_db, _db.appSettingsRows);
}
