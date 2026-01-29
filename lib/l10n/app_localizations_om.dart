// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oromo (`om`).
class AppLocalizationsOm extends AppLocalizations {
  AppLocalizationsOm([String locale = 'om']) : super(locale);

  @override
  String get appTitle => 'Agrilead';

  @override
  String get home => 'Mana';

  @override
  String get sellProduce => 'Omiisha Gurguri';

  @override
  String get myProducts => 'Omiishawwan koo';

  @override
  String get sellInputs => 'Meeshaalee Qonnaa Gurguri';

  @override
  String stockLevel(int count, String unit) {
    return 'Sadarkaa Gufuu: $count $unit';
  }

  @override
  String get outOfStock => 'Dhumateera';

  @override
  String get lowStock => 'Gufuu Diqqaa!';

  @override
  String get updateStock => 'Gufuu Haaromsi';

  @override
  String get quantityUpdated => 'Baay\'inni sirriitti haaromfameera';

  @override
  String get stock => 'Gufuu';

  @override
  String get buyInputs => 'Meeshaalee Qonnaa Bitadhu';

  @override
  String get marketPrices => 'Gatiwwan Gabaa';

  @override
  String get messages => 'Ergaawwan';

  @override
  String get deliveryServices => 'Tajaajila Geejjibaa';

  @override
  String get expertAdvice => 'Gorsa Ekspeertii';

  @override
  String get landPlanner => 'Karoorsituu Lafaa';

  @override
  String get welcomeBack => 'Baga nagaan dhuftan!';

  @override
  String get manageFarm => 'Qubannaa fi callaa keessan haala gaariin bulchaa.';

  @override
  String get selectLanguage => 'Afaan Filadhu';

  @override
  String get farmerDashboard => 'Daashboordii Qonnaan Bulaa';

  @override
  String get loginSubTitle => 'Gara herrega keetti seeni';

  @override
  String get emailHint => 'Iimeelii kee galchi';

  @override
  String get passwordHint => 'Jecha icciitii kee galchi';

  @override
  String get loginButton => 'Seeni';

  @override
  String get noAccount => 'Herrega hin qabduu? ';

  @override
  String get registerAction => 'Galmaa\'i';

  @override
  String get forgotPassword => 'Jecha icciitii dagattee?';

  @override
  String get fillAllFields => 'Maaloo bakka hundaa guuti';

  @override
  String get userNotFound => 'Fayyadamaa hin argamne';

  @override
  String get wrongPassword => 'Jecha icciitii dogoggoraa';

  @override
  String get invalidEmail => 'Iimeelii dogoggoraa';

  @override
  String get userDisabled => 'Fayyadamaa dhorkame';

  @override
  String get somethingWentWrong => 'Wanti tokko dogoggoreera';

  @override
  String get completeProfileSetup =>
      'Maaloo qindaa\'ina piroofaayila kee xumuri.';

  @override
  String get completeProfile => 'Maaloo piroofaayila kee xumuri.';

  @override
  String get registerSubTitle => 'Herrega kee uumi';

  @override
  String get fullNameHint => 'Maqaa kee guutuu galchi';

  @override
  String get phoneHint => 'Lakkoofsa bilbilaa kee galchi';

  @override
  String get selectRole => 'Gahee kee filadhu';

  @override
  String get roleFarmer => 'Qonnaan Bulaa';

  @override
  String get roleVendor => 'Daldalaa';

  @override
  String get roleAdvisor => 'Gorsa Ekspeertii';

  @override
  String get roleDelivery => 'Geejjibaa';

  @override
  String get roleShopper => 'Shopper (Dhiyeessaa Meeshaa)';

  @override
  String get confirmPasswordHint => 'Jecha icciitii mirkaneessi';

  @override
  String get registerButton => 'Galmaa\'i';

  @override
  String get alreadyHaveAccount => 'Duraan herrega qabdaa? ';

  @override
  String get passwordsNotMatch => 'Jechi icciitii wal hin fudhatu';

  @override
  String get passwordTooShort =>
      'Jechi icciitii yoo xiqqaate mallattoo 6 ta\'uu qaba';

  @override
  String get registrationSuccess => 'Galmeen milkaa\'inaan xumurameera!';

  @override
  String get emailInUse => 'Iimeeliin duraan itti fayyadameera';

  @override
  String get weakPassword => 'Jechi icciitii baay\'ee laafaadha';

  @override
  String get invalidEmailAddress => 'Teessoo iimeelii dogoggoraa';

  @override
  String get completeProfileTitle => 'Piroofaayila kee guuti';

  @override
  String get userNotLoggedIn => 'Fayyadamaan hin seenne';

  @override
  String get userDataNotFound => 'Wanti fayyadamaa hin argamne';

  @override
  String get profileCompletedSuccess =>
      'Piroofaayilli milkaa\'inaan xumurameera!';

  @override
  String get profileCompletedFailed => 'Piroofaayila xumuruun hin danda\'amne';

  @override
  String get deliveryInfoTitle => 'Odeeffannoo Geejjibaa';

  @override
  String get yourLocationLabel => 'Bakka kee';

  @override
  String get carTypeLabel => 'Gosa Konkolaataa';

  @override
  String get licenseIdLabel => 'Id eeyyama konkolaachisummaa';

  @override
  String get reviewCompleteTitle => 'Irra deebi\'ii ilaali & Xumuri';

  @override
  String get reviewInfoLabel => 'Odeeffannoo kee irra deebi\'ii ilaali:';

  @override
  String get locationLabel => 'Bakka:';

  @override
  String get licenseIdPrefix => 'Id Eeyyamaa:';

  @override
  String get carTypePrefix => 'Gosa Konkolaataa:';

  @override
  String get clickCompleteLabel =>
      'Qindaa\'ina piroofaayila kee xumuruuf Xumuri kan jedhu cuqaasi.';

  @override
  String get farmInfoTitle => 'Odeeffannoo Qubannaa';

  @override
  String get farmNameLabel => 'Maqaa Qubannaa';

  @override
  String get farmLocationLabel => 'Bakka Qubannaa';

  @override
  String get farmSizeLabel => 'Bal\'ina Qubannaa (acres)';

  @override
  String get cropsGrownLabel => 'Callaa Omishamu';

  @override
  String get cropsHint => 'fkn, Buna, Boqqoolloo, Kuduraa';

  @override
  String get businessInfoTitle => 'Odeeffannoo Daldalaa';

  @override
  String get businessNameLabel => 'Maqaa Daldalaa';

  @override
  String get businessTypeLabel => 'Gosa Daldalaa';

  @override
  String get businessTypeHint => 'fkn, Dhiyeessaa, Reetaayilaa, Tooraa';

  @override
  String get contactPersonLabel => 'Nama Qunnamamu';

  @override
  String get businessAddressLabel => 'Teessoo Daldalaa';

  @override
  String get productsServicesLabel => 'Omiishaalee/Tajaajilaalee';

  @override
  String get productsServicesHint => 'fkn, xaa\'oo, sanyii, meeshaalee';

  @override
  String get professionalProfileTitle => 'Piroofaayila Ogummaa';

  @override
  String get specializationLabel => 'Lutuubummaa';

  @override
  String get specializationHint => 'fkn, Saayinsii Callaa, Fayyaa Neefka';

  @override
  String get experienceLabel => 'Muuxannoo (Waggaa)';

  @override
  String get qualificationLabel => 'Sadarkaa / Digrii';

  @override
  String get farmerProfileSetup => 'Qindaa\'ina Piroofaayila Qonnaan Bulaa';

  @override
  String get vendorProfileSetup => 'Qindaa\'ina Piroofaayila Daldalaa';

  @override
  String get advisorProfileSetup => 'Qindaa\'ina Piroofaayila Gorsa Ekspeertii';

  @override
  String get shopperProfileSetup => 'Qindaa\'ina Piroofaayila Shopper';

  @override
  String get defaultProfileSetup => 'Qindaa\'ina Piroofaayilaa';

  @override
  String welcomeName(String name) {
    return 'Baga nagaan dhuftan, $name!';
  }

  @override
  String get resetLinkSent => 'Reset link sent! Check your inbox.';

  @override
  String get noAccountFound => 'No account found with this email.';

  @override
  String get invalidEmailFormat => 'Invalid email format.';

  @override
  String get networkError =>
      'Dogoggora netwoorkii. Maaloo interneetii kee mirkaneessi.';

  @override
  String get passwordRecoveryTitle => 'Password Recovery';

  @override
  String get enterRegisteredEmail => 'Enter your registered email';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get sendResetLinkButton => 'Send Reset Link';

  @override
  String get signUpAction => 'Galmaa\'i';

  @override
  String comingSoon(String feature) {
    return '$feature dhiyootti ni dhufa!';
  }

  @override
  String get productImagesTitle => 'Fakkiiwwan Omiishaa';

  @override
  String get addPhotosTitle => 'Fakkiiwwan Dabali';

  @override
  String get chooseImageSource => 'Madda fakkii filadhu';

  @override
  String get cameraAction => 'Kaameeraa';

  @override
  String get galleryAction => 'Gaalarii';

  @override
  String get photoAddedSuccess => 'Fakkii milkaa\'inaan dabaleera';

  @override
  String get errorTakingPhoto => 'Fakkii kaasuuf rakkon uumameera';

  @override
  String get errorSelectingImages => 'Fakkiiwwan filachuuf rakkon uumameera';

  @override
  String get photoRemoved => 'Fakkii haqameera';

  @override
  String get locationSelectedSuccess => 'Bakki milkaa\'inaan filatameera';

  @override
  String get enterProductName => 'Maaloo maqaa omiishaa galchi';

  @override
  String get selectCategory => 'Maaloo gosa omiishaa filadhu';

  @override
  String get enterProductDescription => 'Maaloo ibsa omiishaa galchi';

  @override
  String get enterValidPrice => 'Maaloo gatii sirrii galchi';

  @override
  String get enterValidQuantity => 'Maaloo baay\'ina sirrii galchi';

  @override
  String get selectLocation => 'Maaloo bakka filadhu';

  @override
  String get enterSellerName => 'Maaloo maqaa gurguraa galchi';

  @override
  String get enterContactInfo => 'Maaloo odeeffannoo qunnamtii galchi';

  @override
  String get addAtLeastOnePhoto =>
      'Maaloo yoo xiqqaate fakkii omiishaa tokko dabali';

  @override
  String get uploading => 'Olif fe\'amaa jira...';

  @override
  String uploadingImagesCount(int count) {
    return 'Fakkiiwwan haaraa $count ol fe\'amaa jira';
  }

  @override
  String get takeAMoment => 'Kun yeroo murasase fudhachuu danda\'a';

  @override
  String get savedLocallySyncLater =>
      'Bakka kanatti kuufameera! Yeroo interneetiin deebi\'u ni fe\'ama.';

  @override
  String get errorTitle => 'Dogoggora';

  @override
  String get okAction => 'Tole';

  @override
  String get retryAction => 'Irra deebi\'ii yaali';

  @override
  String get successTitle => 'Milkaa\'eera!';

  @override
  String itemListedSuccess(String name) {
    return '$name milkaa\'inaan gabaaf dhiyaateera!';
  }

  @override
  String imagesUploadedCloudinary(int count) {
    return 'Fakkiiwwan $count ol fe\'amaniiru';
  }

  @override
  String get itemLiveMarketplace => 'Omiishni kee ammas gabaa irratti argama.';

  @override
  String get addAnotherAction => 'Kan biraa dabali';

  @override
  String get doneAction => 'Xumurameera';

  @override
  String get formCleared => 'Unki qulqulleeffameera';

  @override
  String get productInformation => 'Odeeffannoo Omiishaa';

  @override
  String get productNameLabel => 'Maqaa Omiishaa *';

  @override
  String get categoryLabel => 'Gosa Omiishaa *';

  @override
  String get subcategoryOptional => 'Gosa xiqqaa (Filaannoo)';

  @override
  String get descriptionLabel => 'Ibsa *';

  @override
  String get describeProductDetail => 'Ibsa omiishaa kee bal\'inaan galchi...';

  @override
  String get priceEtbLabel => 'Gatii (ETB) *';

  @override
  String get quantityLabel => 'Baay\'ina *';

  @override
  String get unitLabel => 'Safara';

  @override
  String get conditionLabel => 'Haala';

  @override
  String get locationTitle => 'Bakka';

  @override
  String get locationOnMap => 'Bakka Kaartaa irratti *';

  @override
  String get tapToSelectLocation => 'Bakka filachuuf cuqaasi';

  @override
  String get editProduct => 'Omiishaa Gulaali';

  @override
  String get sellProduceAction => 'Omiishaa Gurguri';

  @override
  String addMorePhotos(int count) {
    return 'Fakkiiwwan dabalataa dabali ($count/10)';
  }

  @override
  String get deleteProductTitle => 'Omiishaa Haqi';

  @override
  String deleteProductConfirm(String name) {
    return '\"$name\" haquu kee mirkaneessiteettaa?';
  }

  @override
  String get cancelAction => 'Dhiisi';

  @override
  String get deleteAction => 'Haqi';

  @override
  String get productDeletedSuccess => 'Omiishni milkaa\'inaan haqameera';

  @override
  String get loginToViewProducts => 'Maaloo omiishawwan kee arguuf seeni';

  @override
  String get myProductsTitle => 'Omiishawwan koo';

  @override
  String get noProductsListed =>
      'Hamma amማatti omiishaa tokko illee hin gabaasne';

  @override
  String get listFirstProductButton => 'Omiishaa kee isa jalqabaa gabaasi';

  @override
  String get editAction => 'Gulaali';

  @override
  String get shareNearbyAction => 'Warra dhiyoo jiraniif qoodi';

  @override
  String viewsLabel(int count) {
    return '$count Daawwatamaniiru';
  }

  @override
  String likesLabel(int count) {
    return '$count Jaallatama';
  }

  @override
  String get shareWifiTitle => 'Wi-Fi\'n qoodi';

  @override
  String get enterFarmerIpLabel =>
      'Teessoo IP qonnaan bulaa dhiyoo jiru galchi:';

  @override
  String propagatingToIp(String ip) {
    return 'Gara $ip ergamaa jira...';
  }

  @override
  String get propagatedSuccess => 'Milkaa\'inaan ergameera!';

  @override
  String failedToConnectIp(String ip) {
    return '$ip qunnamuun hin danda\'amne';
  }

  @override
  String get sendAction => 'Ergi';

  @override
  String get catCereals => 'Midhaan';

  @override
  String get catPulses => 'Omiishaalee';

  @override
  String get catVegetables => 'Kuduraalee';

  @override
  String get catFruits => 'Muduraalee';

  @override
  String get catSpices => 'Ushuratoota';

  @override
  String get catCoffee => 'Buna';

  @override
  String get catOilSeeds => 'Sanyiiwwan Zayitaa';

  @override
  String get catTubers => 'Tubers';

  @override
  String get catLivestock => 'Horsiisa Beeyladaa';

  @override
  String get catOthers => 'Kan biraa';

  @override
  String get condFresh => 'Haaraa';

  @override
  String get condDry => 'Gogogaa';

  @override
  String get condOrganic => 'Orgaanikii';

  @override
  String get condProcessed => 'Kan qophaa\'e';

  @override
  String get condFrozen => 'Ciddaa';

  @override
  String get unitKg => 'kg';

  @override
  String get unitQuintal => 'quintal';

  @override
  String get unitTon => 'ton';

  @override
  String get unitSack => 'shoroobaa';

  @override
  String get unitPiece => 'cipha';

  @override
  String get unitLiter => 'liter';

  @override
  String get addClearPhotosHint =>
      'Fakkiiwwan omiishaa kee kallattii garagaraan qulqulleessii dabali';

  @override
  String get locationNotFound => 'Bakki hin argamne';

  @override
  String get unableToFindLocation =>
      'Bakka argachuun hin danda\'amne. Maaloo irra deebi\'ii yaali.';

  @override
  String get searchLocationHint => 'Bakka barbaadi...';

  @override
  String get selectLocationTitle => 'Bakka filadhu';

  @override
  String get draggingStatus => 'Harkifamaa jira...';

  @override
  String get fetchingStatus => 'Fidamaa jira...';

  @override
  String get confirmLocationButton => 'Bakka mirkaneessi';

  @override
  String get unknownLocation => 'Bakka hin beekamne';

  @override
  String get catPesticide => 'Qoricha Arrii';

  @override
  String get catHerbicide => 'Qoricha Aramaa';

  @override
  String get catFungicide => 'Qoricha Fangasii';

  @override
  String get catFertilizer => 'Xaa\'oo';

  @override
  String get offline => 'Offline';

  @override
  String get synced => 'Synced';
}
