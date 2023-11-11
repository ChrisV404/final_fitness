// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_page.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

class User extends _User with RealmEntity, RealmObjectBase, RealmObject {
  User(
    ObjectId id,
    String firstName,
    String lastName,
    String email,
    String password, {
    UserTracked? tracked,
  }) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'firstName', firstName);
    RealmObjectBase.set(this, 'lastName', lastName);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'password', password);
    RealmObjectBase.set(this, 'tracked', tracked);
  }

  User._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get firstName =>
      RealmObjectBase.get<String>(this, 'firstName') as String;
  @override
  set firstName(String value) => RealmObjectBase.set(this, 'firstName', value);

  @override
  String get lastName =>
      RealmObjectBase.get<String>(this, 'lastName') as String;
  @override
  set lastName(String value) => RealmObjectBase.set(this, 'lastName', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get password =>
      RealmObjectBase.get<String>(this, 'password') as String;
  @override
  set password(String value) => RealmObjectBase.set(this, 'password', value);

  @override
  UserTracked? get tracked =>
      RealmObjectBase.get<UserTracked>(this, 'tracked') as UserTracked?;
  @override
  set tracked(covariant UserTracked? value) =>
      RealmObjectBase.set(this, 'tracked', value);

  @override
  Stream<RealmObjectChanges<User>> get changes =>
      RealmObjectBase.getChanges<User>(this);

  @override
  User freeze() => RealmObjectBase.freezeObject<User>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(User._);
    return const SchemaObject(ObjectType.realmObject, User, 'user', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('firstName', RealmPropertyType.string),
      SchemaProperty('lastName', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('password', RealmPropertyType.string),
      SchemaProperty('tracked', RealmPropertyType.object,
          optional: true, linkTarget: 'user_tracked'),
    ]);
  }
}

class UserTracked extends _UserTracked
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  UserTracked({
    String? calories,
    String? carbs,
    String? fat,
    String? protein,
    String? steps,
    String? water,
  }) {
    RealmObjectBase.set(this, 'calories', calories);
    RealmObjectBase.set(this, 'carbs', carbs);
    RealmObjectBase.set(this, 'fat', fat);
    RealmObjectBase.set(this, 'protein', protein);
    RealmObjectBase.set(this, 'steps', steps);
    RealmObjectBase.set(this, 'water', water);
  }

  UserTracked._();

  @override
  String? get calories =>
      RealmObjectBase.get<String>(this, 'calories') as String?;
  @override
  set calories(String? value) => RealmObjectBase.set(this, 'calories', value);

  @override
  String? get carbs => RealmObjectBase.get<String>(this, 'carbs') as String?;
  @override
  set carbs(String? value) => RealmObjectBase.set(this, 'carbs', value);

  @override
  String? get fat => RealmObjectBase.get<String>(this, 'fat') as String?;
  @override
  set fat(String? value) => RealmObjectBase.set(this, 'fat', value);

  @override
  String? get protein =>
      RealmObjectBase.get<String>(this, 'protein') as String?;
  @override
  set protein(String? value) => RealmObjectBase.set(this, 'protein', value);

  @override
  String? get steps => RealmObjectBase.get<String>(this, 'steps') as String?;
  @override
  set steps(String? value) => RealmObjectBase.set(this, 'steps', value);

  @override
  String? get water => RealmObjectBase.get<String>(this, 'water') as String?;
  @override
  set water(String? value) => RealmObjectBase.set(this, 'water', value);

  @override
  Stream<RealmObjectChanges<UserTracked>> get changes =>
      RealmObjectBase.getChanges<UserTracked>(this);

  @override
  UserTracked freeze() => RealmObjectBase.freezeObject<UserTracked>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;
  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(UserTracked._);
    return const SchemaObject(
        ObjectType.embeddedObject, UserTracked, 'user_tracked', [
      SchemaProperty('calories', RealmPropertyType.string, optional: true),
      SchemaProperty('carbs', RealmPropertyType.string, optional: true),
      SchemaProperty('fat', RealmPropertyType.string, optional: true),
      SchemaProperty('protein', RealmPropertyType.string, optional: true),
      SchemaProperty('steps', RealmPropertyType.string, optional: true),
      SchemaProperty('water', RealmPropertyType.string, optional: true),
    ]);
  }
}
