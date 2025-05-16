import 'package:stockpro/core/errors/exception.dart';
import 'package:stockpro/features/company/data/datasources/company_remote_data_source.dart';
import 'package:stockpro/features/company/data/models/company_model.dart';
import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final CompanyRemoteDataSource remoteDataSource;

  CompanyRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createCompany(Company company) async {
    try {
      String? uploadedImageUrl;

      try {
        uploadedImageUrl =
            await remoteDataSource.uploadImageAndGetUrl(company.imageUrl);
      } catch (e) {
        print("⚠️ PhotoUrl upload failed: $e");
        uploadedImageUrl = null;
      }
      final updatedCompany = company.copyWith(imageUrl: uploadedImageUrl);
      final CompanyModel model = CompanyModel.fromEntity(updatedCompany);
      await remoteDataSource.createCompany(model);
    } on ServerException catch (e) {
      print("Error adding company: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Stream<Company> getCompanyById(String id) {
    return remoteDataSource.getCompanyById(id);
  }

  @override
  Future<Company?> getCompanyBySecret(String secret) {
    return remoteDataSource.getCompanyBySecret(secret);
  }

  @override
  Future<void> updateCompany(Company company) async {
    try {
      String? uploadedImageUrl;

      try {
        uploadedImageUrl =
            await remoteDataSource.uploadImageAndGetUrl(company.imageUrl);
      } catch (e) {
        print("⚠️ PhotoUrl upload failed: $e");
        uploadedImageUrl = company.imageUrl; // Keep the existing URL on failure
      }
      final updatedCompany = company.copyWith(imageUrl: uploadedImageUrl);
      final CompanyModel model = CompanyModel.fromEntity(updatedCompany);
      await remoteDataSource.updateCompany(model);
    } on ServerException catch (e) {
      print("Error updating company: ${e.toString()}");
      rethrow;
    }
  }
}
