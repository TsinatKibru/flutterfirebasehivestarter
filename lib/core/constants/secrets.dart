class Secrets {
  static const String cloudinaryCloudName = 'dbcuyckat';
  static const String cloudinaryApiKey = '848143656821748';
  static const String cloudinaryApiSecret = 'jb23YSIikpzNLqI_PEQLtcHhaJ0';
  static const String cloudinaryuploadpreset = 'qdtbnlwn';

  static String get cloudinaryUrl =>
      "cloudinary://$cloudinaryApiKey:$cloudinaryApiSecret@$cloudinaryCloudName";
}
