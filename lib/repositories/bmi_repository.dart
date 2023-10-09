import 'package:dioproject/model/bmi_detail.dart';

class BmiRepository {
  final List<BmiDetail> _bmiDetails = [];

  List<BmiDetail> get bmiDetails => _bmiDetails;

  void add(BmiDetail bmiDetail) {
    _bmiDetails.add(bmiDetail);
  }

  void remove(BmiDetail bmiDetail) {
    _bmiDetails.remove(bmiDetail);
  }

  void update(BmiDetail bmiDetail) {
    final index = _bmiDetails.indexWhere((element) => element.id == bmiDetail.id);
    _bmiDetails[index] = bmiDetail;
  }

  List<BmiDetail> list() {
    return _bmiDetails;
  }
}