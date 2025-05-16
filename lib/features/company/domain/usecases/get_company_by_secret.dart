import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/domain/repositories/company_repository.dart';

class GetCompanyBySecret {
  final CompanyRepository repository;

  GetCompanyBySecret(this.repository);

  Future<Company?> call(String secret) async {
    return repository.getCompanyBySecret(secret);
  }
}
