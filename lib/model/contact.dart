import 'dart:convert';

import 'package:flutter/widgets.dart';

class Contact {
  int? id;
  final String nama;
  final String email;
  final String alamat;
  final String no_telpon;
  String? gambar;
  Contact({
    this.id,
    required this.nama,
    required this.email,
    required this.alamat,
    required this.no_telpon,
    this.gambar,
  });

  Contact copyWith({
    ValueGetter<int?>? id,
    String? nama,
    String? email,
    String? alamat,
    String? no_telpon,
    ValueGetter<String?>? gambar,
  }) {
    return Contact(
      id: id != null ? id() : this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      alamat: alamat ?? this.alamat,
      no_telpon: no_telpon ?? this.no_telpon,
      gambar: gambar != null ? gambar() : this.gambar,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'alamat': alamat,
      'no_telpon': no_telpon,
      'gambar': gambar,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id']?.toInt(),
      nama: map['nama'] ?? '',
      email: map['email'] ?? '',
      alamat: map['alamat'] ?? '',
      no_telpon: map['no_telpon'] ?? '',
      gambar: map['gambar'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Contact(id: $id, nama: $nama, email: $email, alamat: $alamat, no_telpon: $no_telpon, gambar: $gambar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Contact &&
        other.id == id &&
        other.nama == nama &&
        other.email == email &&
        other.alamat == alamat &&
        other.no_telpon == no_telpon &&
        other.gambar == gambar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nama.hashCode ^
        email.hashCode ^
        alamat.hashCode ^
        no_telpon.hashCode ^
        gambar.hashCode;
  }
}
