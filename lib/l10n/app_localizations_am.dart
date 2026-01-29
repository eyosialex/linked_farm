// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appTitle => 'አግሪሊድ';

  @override
  String get home => 'መነሻ';

  @override
  String get sellProduce => 'ምርት ይሽጡ';

  @override
  String get myProducts => 'የእኔ ምርቶች';

  @override
  String get sellInputs => 'የግብርና ግብዓቶችን ይሽጡ';

  @override
  String stockLevel(int count, String unit) {
    return 'ክምችት መጠን፡ $count $unit';
  }

  @override
  String get outOfStock => 'ያለቀ';

  @override
  String get lowStock => 'አነስተኛ ክምችት!';

  @override
  String get updateStock => 'ክምችት አዘምን';

  @override
  String get quantityUpdated => 'መጠኑ በትክክል ተዘምኗል';

  @override
  String get stock => 'ክምችት';

  @override
  String get buyInputs => 'የግብርና ግብዓቶችን ይግዙ';

  @override
  String get marketPrices => 'የገበያ ዋጋ';

  @override
  String get messages => 'መልዕክቶች';

  @override
  String get deliveryServices => 'የማጓጓዣ አገልግሎቶች';

  @override
  String get expertAdvice => 'የባለሙያ ምክር';

  @override
  String get landPlanner => 'የመሬት እቅድ አውጪ';

  @override
  String get welcomeBack => 'እንኳን ደህና መጡ!';

  @override
  String get manageFarm => 'እርሻዎን እና ሰብሎችዎን በብቃት ያስተዳድሩ።';

  @override
  String get selectLanguage => 'ቋንቋ ይምረጡ';

  @override
  String get farmerDashboard => 'የአርሶ አደር ዳሽቦርድ';

  @override
  String get loginSubTitle => 'ወደ መለያዎ ይግቡ';

  @override
  String get emailHint => 'ኢሜልዎን ያስገቡ';

  @override
  String get passwordHint => 'የይለፍ ቃልዎን ያስገቡ';

  @override
  String get loginButton => 'ግባ';

  @override
  String get noAccount => 'መለያ የለዎትም? ';

  @override
  String get registerAction => 'ይመዝገቡ';

  @override
  String get forgotPassword => 'የይለፍ ቃል ረስተዋል?';

  @override
  String get fillAllFields => 'እባክዎ ሁሉንም መስኮች ይሙሉ';

  @override
  String get userNotFound => 'ተጠቃሚ አልተገኘም';

  @override
  String get wrongPassword => 'የተሳሳተ የይለፍ ቃል';

  @override
  String get invalidEmail => 'የተሳሳተ ኢሜል';

  @override
  String get userDisabled => 'ተጠቃሚው ታግዷል';

  @override
  String get somethingWentWrong => 'ችግር ተፈጥሯል';

  @override
  String get completeProfileSetup => 'እባክዎ የመለያዎን ዝግጅት ያጠናቅቁ።';

  @override
  String get completeProfile => 'እባክዎ መገለጫዎን ያጠናቅቁ።';

  @override
  String get registerSubTitle => 'መለያዎን ይፍጠሩ';

  @override
  String get fullNameHint => 'ሙሉ ስምዎን ያስገቡ';

  @override
  String get phoneHint => 'የስልክ ቁጥርዎን ያስገቡ';

  @override
  String get selectRole => 'ሚናዎን ይምረጡ';

  @override
  String get roleFarmer => 'አርሶ አደር';

  @override
  String get roleVendor => 'ነጋዴ';

  @override
  String get roleAdvisor => 'አማካሪ ባለሙያ';

  @override
  String get roleDelivery => 'አቅራቢ/መልእክተኛ';

  @override
  String get roleShopper => 'ሾፐር (ግብዓት አቅራቢ)';

  @override
  String get confirmPasswordHint => 'የይለፍ ቃልዎን ያረጋግጡ';

  @override
  String get registerButton => 'ይመዝገቡ';

  @override
  String get alreadyHaveAccount => 'ቀድሞውኑ መለያ አለዎት? ';

  @override
  String get passwordsNotMatch => 'የይለፍ ቃላት አይዛመዱም';

  @override
  String get passwordTooShort => 'የይለፍ ቃል ቢያንስ 6 ቁምፊዎች መሆን አለበት';

  @override
  String get registrationSuccess => 'ምዝገባው በተሳካ ሁኔታ ተጠናቅቋል!';

  @override
  String get emailInUse => 'ኢሜል አስቀድሞ ጥቅም ላይ ውሏል';

  @override
  String get weakPassword => 'የይለፍ ቃሉ በጣም ደካማ ነው';

  @override
  String get invalidEmailAddress => 'የተሳሳተ የኢሜል አድራሻ';

  @override
  String get completeProfileTitle => 'መገለጫዎን ያጠናቅቁ';

  @override
  String get userNotLoggedIn => 'ተጠቃሚ አልገባም';

  @override
  String get userDataNotFound => 'የተጠቃሚ ውሂብ አልተገኘም';

  @override
  String get profileCompletedSuccess => 'መገለጫ በተሳካ ሁኔታ ተጠናቅቋል!';

  @override
  String get profileCompletedFailed => 'መገለጫውን ማጠናቀቅ አልተቻለም';

  @override
  String get deliveryInfoTitle => 'የማድረሻ መረጃ';

  @override
  String get yourLocationLabel => 'የእርስዎ አካባቢ';

  @override
  String get carTypeLabel => 'የመኪና ዓይነት';

  @override
  String get licenseIdLabel => 'የመንጃ ፍቃድ መታወቂያ';

  @override
  String get reviewCompleteTitle => 'ይገምግሙ እና ያጠናቅቁ';

  @override
  String get reviewInfoLabel => 'መረጃዎን ይገምግሙ፡';

  @override
  String get locationLabel => 'አካባቢ፡';

  @override
  String get licenseIdPrefix => 'የፍቃድ መታወቂያ፡';

  @override
  String get carTypePrefix => 'የመኪና ዓይነት፡';

  @override
  String get clickCompleteLabel => 'የመገለጫ ዝግጅትዎን ለማጠናቀቅ አጠናቅቅ የሚለውን ይጫኑ።';

  @override
  String get farmInfoTitle => 'የእርሻ መረጃ';

  @override
  String get farmNameLabel => 'የእርሻ ስም';

  @override
  String get farmLocationLabel => 'የእርሻ ቦታ';

  @override
  String get farmSizeLabel => 'የእርሻ መጠን (በኤከር)';

  @override
  String get cropsGrownLabel => 'የሚመረቱ ሰብሎች';

  @override
  String get cropsHint => 'ለምሳሌ፡ ቡና፣ በቆሎ፣ አትክልት';

  @override
  String get businessInfoTitle => 'የንግድ መረጃ';

  @override
  String get businessNameLabel => 'የንግድ ስም';

  @override
  String get businessTypeLabel => 'የንግድ ዓይነት';

  @override
  String get businessTypeHint => 'ለምሳሌ፡ አቅራቢ፣ ቸርቻሪ፣ ጅምላ ሻጭ';

  @override
  String get contactPersonLabel => 'ተጠሪ ሰው';

  @override
  String get businessAddressLabel => 'የንግድ አድራሻ';

  @override
  String get productsServicesLabel => 'ምርቶች/አገልግሎቶች';

  @override
  String get productsServicesHint => 'ለምሳሌ፡ ማዳበሪያ፣ ዘር፣ መሳሪያዎች';

  @override
  String get professionalProfileTitle => 'የሙያ መገለጫ';

  @override
  String get specializationLabel => 'ልዩ ሙያ';

  @override
  String get specializationHint => 'ለምሳሌ፡ የሰብል ሳይንስ፣ የእንስሳት ጤና';

  @override
  String get experienceLabel => 'ልምድ (በዓመታት)';

  @override
  String get qualificationLabel => 'ደረጃ / ዲግሪ';

  @override
  String get farmerProfileSetup => 'የአርሶ አደር መገለጫ ዝግጅት';

  @override
  String get vendorProfileSetup => 'የነጋዴ መገለጫ ዝግጅት';

  @override
  String get advisorProfileSetup => 'የአማካሪ ባለሙያ መገለጫ ዝግጅት';

  @override
  String get shopperProfileSetup => 'የሾፐር መገለጫ ዝግጅት';

  @override
  String get defaultProfileSetup => 'የመገለጫ ዝግጅት';

  @override
  String welcomeName(String name) {
    return 'እንኳን ደህና መጡ፣ $name!';
  }

  @override
  String get resetLinkSent => 'የይለፍ ቃል መቀየሪያ ሊንክ ተልኳል! ኢሜልዎን ይፈትሹ።';

  @override
  String get noAccountFound => 'በዚህ ኢሜል የተመዘገበ መለያ አልተገኘም።';

  @override
  String get invalidEmailFormat => 'የተሳሳተ የኢሜል ፎርማት።';

  @override
  String get networkError => 'የኔትወርክ ስህተት። እባክዎ ኢንተርኔትዎን ያረጋግጡ።';

  @override
  String get passwordRecoveryTitle => 'የይለፍ ቃል መልሶ ማግኛ';

  @override
  String get enterRegisteredEmail => 'የተመዘገበ ኢሜልዎን ያስገቡ';

  @override
  String get emailAddressLabel => 'የኢሜል አድራሻ';

  @override
  String get sendResetLinkButton => 'ሊንክ ላክ';

  @override
  String get signUpAction => 'ይመዝገቡ';

  @override
  String comingSoon(String feature) {
    return '$feature በቅርቡ ይቀርባል!';
  }

  @override
  String get productImagesTitle => 'የምርት ምስሎች';

  @override
  String get addPhotosTitle => 'ምስሎችን ያክሉ';

  @override
  String get chooseImageSource => 'የምስል ምንጭ ይምረጡ';

  @override
  String get cameraAction => 'ካሜራ';

  @override
  String get galleryAction => 'ጋለሪ';

  @override
  String get photoAddedSuccess => 'ምስል በተሳካ ሁኔታ ተጨምሯል';

  @override
  String get errorTakingPhoto => 'ፎቶ በማንሳት ላይ ስህተት ተከስቷል';

  @override
  String get errorSelectingImages => 'ምስሎችን በመምረጥ ላይ ስህተት ተከስቷል';

  @override
  String get photoRemoved => 'ምስል ተወግዷል';

  @override
  String get locationSelectedSuccess => 'ቦታ በተሳካ ሁኔታ ተመርጧል';

  @override
  String get enterProductName => 'እባክዎ የምርት ስም ያስገቡ';

  @override
  String get selectCategory => 'እባክዎ ምድብ ይምረጡ';

  @override
  String get enterProductDescription => 'እባክዎ የምርት መግለጫ ያስገቡ';

  @override
  String get enterValidPrice => 'እባክዎ ትክክለኛ ዋጋ ያስገቡ';

  @override
  String get enterValidQuantity => 'እባክዎ ትክክለኛ መጠን ያስገቡ';

  @override
  String get selectLocation => 'እባክዎ ቦታ ይምረጡ';

  @override
  String get enterSellerName => 'እባክዎ የሻጭ ስም ያስገቡ';

  @override
  String get enterContactInfo => 'እባክዎ የመገናኛ መረጃ ያስገቡ';

  @override
  String get addAtLeastOnePhoto => 'እባክዎ ቢያንስ አንድ የምርት ፎቶ ያክሉ';

  @override
  String get uploading => 'በመጫን ላይ...';

  @override
  String uploadingImagesCount(int count) {
    return '$count አዲስ ምስሎችን በመጫን ላይ';
  }

  @override
  String get takeAMoment => 'ይህ ጥቂት ጊዜ ሊወስድ ይችላል';

  @override
  String get savedLocallySyncLater => 'በአካባቢው ተቀምጧል! ኢንተርኔት ሲኖር ይላካል።';

  @override
  String get errorTitle => 'ስህተት';

  @override
  String get okAction => 'እሺ';

  @override
  String get retryAction => 'እንደገና ይሞክሩ';

  @override
  String get successTitle => 'ተሳክቷል!';

  @override
  String itemListedSuccess(String name) {
    return '$name በተሳካ ሁኔታ ለገበያ ቀርቧል!';
  }

  @override
  String imagesUploadedCloudinary(int count) {
    return '$count ምስሎች ተጭነዋል';
  }

  @override
  String get itemLiveMarketplace => 'ምርትዎ አሁን በገበያ ላይ ይገኛል።';

  @override
  String get addAnotherAction => 'ሌላ ጨምር';

  @override
  String get doneAction => 'ተጠናቀቀ';

  @override
  String get formCleared => 'ቅጹ ጸድቷል';

  @override
  String get productInformation => 'የምርት መረጃ';

  @override
  String get productNameLabel => 'የምርት ስም *';

  @override
  String get categoryLabel => 'ምድብ *';

  @override
  String get subcategoryOptional => 'ንዑስ ምድብ (አማራጭ)';

  @override
  String get descriptionLabel => 'መግለጫ *';

  @override
  String get describeProductDetail => 'ስለ ምርቱ ዝርዝር መግለጫ ይስጡ...';

  @override
  String get priceEtbLabel => 'ዋጋ (በብር) *';

  @override
  String get quantityLabel => 'መጠን *';

  @override
  String get unitLabel => 'መመዘኛ';

  @override
  String get conditionLabel => 'ሁኔታ';

  @override
  String get locationTitle => 'ቦታ';

  @override
  String get locationOnMap => 'ቦታ በካርታ ላይ *';

  @override
  String get tapToSelectLocation => 'ቦታ ለመምረጥ ይጫኑ';

  @override
  String get editProduct => 'ምርት ይቀይሩ';

  @override
  String get sellProduceAction => 'ምርት ይሽጡ';

  @override
  String addMorePhotos(int count) {
    return 'ተጨማሪ ምስሎችን ያክሉ ($count/10)';
  }

  @override
  String get deleteProductTitle => 'ምርት ይሰርዙ';

  @override
  String deleteProductConfirm(String name) {
    return '\"$name\" መሰረዝዎን እርግጠኛ ነዎት?';
  }

  @override
  String get cancelAction => 'አይሁን';

  @override
  String get deleteAction => 'ሰርዝ';

  @override
  String get productDeletedSuccess => 'ምርት በተሳካ ሁኔታ ተሰርዟል';

  @override
  String get loginToViewProducts => 'ምርቶችዎን ለማየት እባክዎ ይግቡ';

  @override
  String get myProductsTitle => 'የእኔ ምርቶች';

  @override
  String get noProductsListed => 'እስካሁን ምንም ምርት አላቀረቡም';

  @override
  String get listFirstProductButton => 'የመጀመሪያ ምርትዎን ያቅርቡ';

  @override
  String get editAction => 'አስተካክል';

  @override
  String get shareNearbyAction => 'ለአቅራቢያ ያካፍሉ';

  @override
  String viewsLabel(int count) {
    return '$count እይታዎች';
  }

  @override
  String likesLabel(int count) {
    return '$count ተወዳጅነት';
  }

  @override
  String get shareWifiTitle => 'በዋይፋይ ያካፍሉ';

  @override
  String get enterFarmerIpLabel => 'የአቅራቢያ አርሶ አደር IP አድራሻ ያስገቡ፡';

  @override
  String propagatingToIp(String ip) {
    return 'ወደ $ip በመላክ ላይ...';
  }

  @override
  String get propagatedSuccess => 'በተሳካ ሁኔታ ተልኳል!';

  @override
  String failedToConnectIp(String ip) {
    return 'ከ $ip ጋር መገናኘት አልተቻለም';
  }

  @override
  String get sendAction => 'ላክ';

  @override
  String get catCereals => 'ጥራጥሬዎች';

  @override
  String get catPulses => 'አተርና ባቄላ';

  @override
  String get catVegetables => 'አትክልቶች';

  @override
  String get catFruits => 'ፍራፍሬዎች';

  @override
  String get catSpices => 'ቅመማ ቅመሞች';

  @override
  String get catCoffee => 'ቡና';

  @override
  String get catOilSeeds => 'የቅባት እህሎች';

  @override
  String get catTubers => 'ስርወ ምድሮች';

  @override
  String get catLivestock => 'የከብት እርባታ';

  @override
  String get catOthers => 'ሌሎች';

  @override
  String get condFresh => 'ትኩስ';

  @override
  String get condDry => 'ደረቅ';

  @override
  String get condOrganic => 'ተፈጥሯዊ';

  @override
  String get condProcessed => 'የተቀነባበረ';

  @override
  String get condFrozen => 'የበረዶ';

  @override
  String get unitKg => 'ኪሎ';

  @override
  String get unitQuintal => 'ኩንታል';

  @override
  String get unitTon => 'ቶን';

  @override
  String get unitSack => 'ጆንያ';

  @override
  String get unitPiece => 'ፍሬ';

  @override
  String get unitLiter => 'ሊትር';

  @override
  String get addClearPhotosHint => 'ስለ ምርቱ ግልጽ ፎቶዎችን ከተለያዩ አቅጣጫዎች ያክሉ';

  @override
  String get locationNotFound => 'ቦታው አልተገኘም';

  @override
  String get unableToFindLocation => 'ቦታውን ለማግኘት አልተቻለም። እባክዎ እንደገና ይሞክሩ።';

  @override
  String get searchLocationHint => 'ቦታ ይፈልጉ...';

  @override
  String get selectLocationTitle => 'ቦታ ይምረጡ';

  @override
  String get draggingStatus => 'በመጎተት ላይ...';

  @override
  String get fetchingStatus => 'በመፈለግ ላይ...';

  @override
  String get confirmLocationButton => 'ቦታውን አረጋግጥ';

  @override
  String get unknownLocation => 'ያልታወቀ ቦታ';

  @override
  String get catPesticide => 'ፀረ-ተባይ';

  @override
  String get catHerbicide => 'ፀረ-አረም';

  @override
  String get catFungicide => 'ፀረ-ፈንገስ';

  @override
  String get catFertilizer => 'ማዳበሪያ';

  @override
  String get offline => 'ከመስመር ውጭ';

  @override
  String get synced => 'ተ синхሮናይዝድ';
}
