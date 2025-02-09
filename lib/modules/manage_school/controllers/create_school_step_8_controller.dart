import 'package:flutter/material.dart';

import '../../../core/utils/helpers/helper_functions.dart';
import '../models/school_model.dart';

class CreateSchoolStep8ExtracurricularDetailsController {
  final TextEditingController clubsController = TextEditingController();
  final TextEditingController societiesController = TextEditingController();
  final TextEditingController sportsTeamsController = TextEditingController();
  final TextEditingController annualEventsController = TextEditingController();
  final TextEditingController communityServiceController = TextEditingController();

  void dispose() {
    clubsController.dispose();
    societiesController.dispose();
    sportsTeamsController.dispose();
    annualEventsController.dispose();
    communityServiceController.dispose();
  }


}
