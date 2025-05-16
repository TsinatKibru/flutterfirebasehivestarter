import 'package:stockpro/features/company/domain/entities/company.dart';
import 'package:stockpro/features/company/domain/repositories/company_repository.dart';

class GetCompanyById {
  final CompanyRepository repository;

  GetCompanyById(this.repository);

  Stream<Company> call(String id) {
    return repository.getCompanyById(id);
  }
}
