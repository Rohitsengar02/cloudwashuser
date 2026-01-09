import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_user/core/models/banner_model.dart';
import 'package:cloud_user/core/models/category_model.dart';
import 'package:cloud_user/core/models/sub_category_model.dart';
import 'package:cloud_user/core/models/service_model.dart';
import 'package:cloud_user/features/home/data/about_us_model.dart';
import 'package:cloud_user/features/home/data/hero_section_model.dart';
import 'package:cloud_user/features/home/data/stats_model.dart';
import 'package:cloud_user/features/home/data/testimonial_model.dart';
import 'package:cloud_user/features/home/data/why_choose_us_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_home_repository.g.dart';

@Riverpod(keepAlive: true)
FirebaseHomeRepository firebaseHomeRepository(FirebaseHomeRepositoryRef ref) {
  return FirebaseHomeRepository(FirebaseFirestore.instance);
}

class FirebaseHomeRepository {
  final FirebaseFirestore _firestore;

  FirebaseHomeRepository(this._firestore);

  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return CategoryModel(
          id: doc.id,
          name: data['name'] ?? '',
          description: data['description'] ?? '',
          price: (data['price'] ?? 0).toDouble(),
          imageUrl: data['imageUrl'] ?? '',
          isActive: data['isActive'] ?? true,
        );
      }).toList();
    } catch (e) {
      print('Firebase Error (Categories): $e');
      rethrow;
    }
  }

  Future<List<ServiceModel>> getServices({
    String? categoryId,
    String? subCategoryId,
  }) async {
    try {
      Query query = _firestore.collection('services');
      if (categoryId != null)
        query = query.where('category', isEqualTo: categoryId);
      if (subCategoryId != null)
        query = query.where('subCategory', isEqualTo: subCategoryId);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return ServiceModel.fromJson({'_id': doc.id, ...data});
      }).toList();
    } catch (e) {
      print('Firebase Error (Services): $e');
      return [];
    }
  }

  Future<List<BannerModel>> getBanners() async {
    try {
      final snapshot = await _firestore.collection('banners').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return BannerModel(
          id: doc.id,
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          position: data['position'] ?? 'home',
          isActive: data['isActive'] ?? true,
          imageUrl: data['imageUrl'] ?? '',
          displayOrder: data['displayOrder'] ?? 0,
        );
      }).toList();
    } catch (e) {
      print('Firebase Error (Banners): $e');
      return [];
    }
  }

  Future<List<SubCategoryModel>> getSubCategories({String? categoryId}) async {
    try {
      Query query = _firestore.collection('subCategories');
      if (categoryId != null)
        query = query.where('categoryId', isEqualTo: categoryId);

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return SubCategoryModel.fromJson({'_id': doc.id, ...data});
      }).toList();
    } catch (e) {
      print('Firebase Error (SubCategories): $e');
      return [];
    }
  }

  Future<HeroSectionModel?> getHeroSection() async {
    try {
      final snapshot = await _firestore
          .collection('web_landing')
          .doc('hero')
          .get();
      if (snapshot.exists) {
        final data = snapshot.data()!;
        return HeroSectionModel.fromJson({'_id': snapshot.id, ...data});
      }
      return null;
    } catch (e) {
      print('Firebase Error (Hero): $e');
      return null;
    }
  }

  Future<AboutUsModel?> getAboutUs() async {
    try {
      final snapshot = await _firestore
          .collection('web_landing')
          .doc('about')
          .get();
      if (snapshot.exists) {
        return AboutUsModel.fromJson({'_id': snapshot.id, ...snapshot.data()!});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<StatsModel?> getStats() async {
    try {
      final snapshot = await _firestore
          .collection('web_landing')
          .doc('stats')
          .get();
      if (snapshot.exists) {
        return StatsModel.fromJson({'_id': snapshot.id, ...snapshot.data()!});
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<TestimonialModel>> getTestimonials() async {
    try {
      final snapshot = await _firestore.collection('testimonials').get();
      return snapshot.docs
          .map(
            (doc) => TestimonialModel.fromJson({'_id': doc.id, ...doc.data()}),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<WhyChooseUsModel>> getWhyChooseUs() async {
    try {
      final snapshot = await _firestore.collection('whyChooseUs').get();
      return snapshot.docs
          .map(
            (doc) => WhyChooseUsModel.fromJson({'_id': doc.id, ...doc.data()}),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }
}
