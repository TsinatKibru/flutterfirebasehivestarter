import 'package:stockpro/features/company/domain/entities/company.dart';

abstract class CompanyRepository {
  Future<void> createCompany(Company company);
  Stream<Company> getCompanyById(String id);
  Future<Company?> getCompanyBySecret(String secret);
  Future<void> updateCompany(Company company);
}
