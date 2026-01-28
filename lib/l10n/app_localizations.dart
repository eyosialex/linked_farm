import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';
import 'app_localizations_om.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
    Locale('om'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Agrilead'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @sellProduce.
  ///
  /// In en, this message translates to:
  /// **'Sell Produce'**
  String get sellProduce;

  /// No description provided for @myProducts.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get myProducts;

  /// No description provided for @buyInputs.
  ///
  /// In en, this message translates to:
  /// **'Buy Agricultural Inputs'**
  String get buyInputs;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @deliveryServices.
  ///
  /// In en, this message translates to:
  /// **'Delivery Services'**
  String get deliveryServices;

  /// No description provided for @expertAdvice.
  ///
  /// In en, this message translates to:
  /// **'Expert Advice'**
  String get expertAdvice;

  /// No description provided for @landPlanner.
  ///
  /// In en, this message translates to:
  /// **'My Land Planner'**
  String get landPlanner;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBack;

  /// No description provided for @manageFarm.
  ///
  /// In en, this message translates to:
  /// **'Manage your farm and crops efficiently.'**
  String get manageFarm;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @farmerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Farmer Dashboard'**
  String get farmerDashboard;

  /// No description provided for @loginSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginSubTitle;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get emailHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Wrong password'**
  String get wrongPassword;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'User disabled'**
  String get userDisabled;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @completeProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile setup.'**
  String get completeProfileSetup;

  /// No description provided for @completeProfile.
  ///
  /// In en, this message translates to:
  /// **'Please complete your profile.'**
  String get completeProfile;

  /// No description provided for @registerSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get registerSubTitle;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get fullNameHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get phoneHint;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select your role'**
  String get selectRole;

  /// No description provided for @roleFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get roleFarmer;

  /// No description provided for @roleVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get roleVendor;

  /// No description provided for @roleAdvisor.
  ///
  /// In en, this message translates to:
  /// **'Expert Advisor'**
  String get roleAdvisor;

  /// No description provided for @roleDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get roleDelivery;

  /// No description provided for @roleShopper.
  ///
  /// In en, this message translates to:
  /// **'Shopper (Input Supplier)'**
  String get roleShopper;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmPasswordHint;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registrationSuccess;

  /// No description provided for @emailInUse.
  ///
  /// In en, this message translates to:
  /// **'Email already in use'**
  String get emailInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmailAddress;

  /// No description provided for @completeProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Complete Your Profile'**
  String get completeProfileTitle;

  /// No description provided for @userNotLoggedIn.
  ///
  /// In en, this message translates to:
  /// **'User not logged in'**
  String get userNotLoggedIn;

  /// No description provided for @userDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'User data not found'**
  String get userDataNotFound;

  /// No description provided for @profileCompletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Profile completed successfully!'**
  String get profileCompletedSuccess;

  /// No description provided for @profileCompletedFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to complete profile'**
  String get profileCompletedFailed;

  /// No description provided for @deliveryInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Information'**
  String get deliveryInfoTitle;

  /// No description provided for @yourLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Your location'**
  String get yourLocationLabel;

  /// No description provided for @carTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Car Type'**
  String get carTypeLabel;

  /// No description provided for @licenseIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Driven license id'**
  String get licenseIdLabel;

  /// No description provided for @reviewCompleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Review & Complete'**
  String get reviewCompleteTitle;

  /// No description provided for @reviewInfoLabel.
  ///
  /// In en, this message translates to:
  /// **'Review your information:'**
  String get reviewInfoLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location:'**
  String get locationLabel;

  /// No description provided for @licenseIdPrefix.
  ///
  /// In en, this message translates to:
  /// **'License ID:'**
  String get licenseIdPrefix;

  /// No description provided for @carTypePrefix.
  ///
  /// In en, this message translates to:
  /// **'Car Type:'**
  String get carTypePrefix;

  /// No description provided for @clickCompleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Click Complete to finish your profile setup.'**
  String get clickCompleteLabel;

  /// No description provided for @farmInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Farm Information'**
  String get farmInfoTitle;

  /// No description provided for @farmNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmNameLabel;

  /// No description provided for @farmLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Farm Location'**
  String get farmLocationLabel;

  /// No description provided for @farmSizeLabel.
  ///
  /// In en, this message translates to:
  /// **'Farm Size (acres)'**
  String get farmSizeLabel;

  /// No description provided for @cropsGrownLabel.
  ///
  /// In en, this message translates to:
  /// **'Crops Grown'**
  String get cropsGrownLabel;

  /// No description provided for @cropsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Coffee, Maize, Vegetables'**
  String get cropsHint;

  /// No description provided for @businessInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get businessInfoTitle;

  /// No description provided for @businessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessNameLabel;

  /// No description provided for @businessTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get businessTypeLabel;

  /// No description provided for @businessTypeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Supplier, Retailer, Wholesaler'**
  String get businessTypeHint;

  /// No description provided for @contactPersonLabel.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get contactPersonLabel;

  /// No description provided for @businessAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Address'**
  String get businessAddressLabel;

  /// No description provided for @productsServicesLabel.
  ///
  /// In en, this message translates to:
  /// **'Products/Services'**
  String get productsServicesLabel;

  /// No description provided for @productsServicesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Fertilizers, Seeds, Equipment'**
  String get productsServicesHint;

  /// No description provided for @professionalProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Professional Profile'**
  String get professionalProfileTitle;

  /// No description provided for @specializationLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specializationLabel;

  /// No description provided for @specializationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Crop Science, Animal Health'**
  String get specializationHint;

  /// No description provided for @experienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Experience (Years)'**
  String get experienceLabel;

  /// No description provided for @qualificationLabel.
  ///
  /// In en, this message translates to:
  /// **'Qualification / Degree'**
  String get qualificationLabel;

  /// No description provided for @farmerProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Farmer Profile Setup'**
  String get farmerProfileSetup;

  /// No description provided for @vendorProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Vendor Profile Setup'**
  String get vendorProfileSetup;

  /// No description provided for @advisorProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Expert Advisor Profile Setup'**
  String get advisorProfileSetup;

  /// No description provided for @shopperProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Shopper Profile Setup'**
  String get shopperProfileSetup;

  /// No description provided for @defaultProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get defaultProfileSetup;

  /// No description provided for @welcomeName.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}!'**
  String welcomeName(String name);

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Reset link sent! Check your inbox.'**
  String get resetLinkSent;

  /// No description provided for @noAccountFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get noAccountFound;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format.'**
  String get invalidEmailFormat;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your internet connection.'**
  String get networkError;

  /// No description provided for @passwordRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Recovery'**
  String get passwordRecoveryTitle;

  /// No description provided for @enterRegisteredEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your registered email'**
  String get enterRegisteredEmail;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @sendResetLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLinkButton;

  /// No description provided for @signUpAction.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpAction;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} coming soon!'**
  String comingSoon(String feature);

  /// No description provided for @productImagesTitle.
  ///
  /// In en, this message translates to:
  /// **'Product Images'**
  String get productImagesTitle;

  /// No description provided for @addPhotosTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotosTitle;

  /// No description provided for @chooseImageSource.
  ///
  /// In en, this message translates to:
  /// **'Choose image source'**
  String get chooseImageSource;

  /// No description provided for @cameraAction.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraAction;

  /// No description provided for @galleryAction.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryAction;

  /// No description provided for @photoAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Photo added successfully'**
  String get photoAddedSuccess;

  /// No description provided for @errorTakingPhoto.
  ///
  /// In en, this message translates to:
  /// **'Error taking photo'**
  String get errorTakingPhoto;

  /// No description provided for @errorSelectingImages.
  ///
  /// In en, this message translates to:
  /// **'Error selecting images'**
  String get errorSelectingImages;

  /// No description provided for @photoRemoved.
  ///
  /// In en, this message translates to:
  /// **'Photo removed'**
  String get photoRemoved;

  /// No description provided for @locationSelectedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Location selected successfully'**
  String get locationSelectedSuccess;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Please enter product name'**
  String get enterProductName;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategory;

  /// No description provided for @enterProductDescription.
  ///
  /// In en, this message translates to:
  /// **'Please enter product description'**
  String get enterProductDescription;

  /// No description provided for @enterValidPrice.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid price'**
  String get enterValidPrice;

  /// No description provided for @enterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid quantity'**
  String get enterValidQuantity;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Please select a location'**
  String get selectLocation;

  /// No description provided for @enterSellerName.
  ///
  /// In en, this message translates to:
  /// **'Please enter seller name'**
  String get enterSellerName;

  /// No description provided for @enterContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Please enter contact information'**
  String get enterContactInfo;

  /// No description provided for @addAtLeastOnePhoto.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one product photo'**
  String get addAtLeastOnePhoto;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading...'**
  String get uploading;

  /// No description provided for @uploadingImagesCount.
  ///
  /// In en, this message translates to:
  /// **'Uploading {count} new image(s)'**
  String uploadingImagesCount(int count);

  /// No description provided for @takeAMoment.
  ///
  /// In en, this message translates to:
  /// **'This may take a few moments'**
  String get takeAMoment;

  /// No description provided for @savedLocallySyncLater.
  ///
  /// In en, this message translates to:
  /// **'Saved locally! Will sync when internet is back.'**
  String get savedLocallySyncLater;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorTitle;

  /// No description provided for @okAction.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okAction;

  /// No description provided for @retryAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryAction;

  /// No description provided for @successTitle.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get successTitle;

  /// No description provided for @itemListedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} has been listed successfully!'**
  String itemListedSuccess(String name);

  /// No description provided for @imagesUploadedCloudinary.
  ///
  /// In en, this message translates to:
  /// **'{count} image(s) uploaded to Cloudinary'**
  String imagesUploadedCloudinary(int count);

  /// No description provided for @itemLiveMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Your item is now live on the marketplace.'**
  String get itemLiveMarketplace;

  /// No description provided for @addAnotherAction.
  ///
  /// In en, this message translates to:
  /// **'Add Another'**
  String get addAnotherAction;

  /// No description provided for @doneAction.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneAction;

  /// No description provided for @formCleared.
  ///
  /// In en, this message translates to:
  /// **'Form cleared'**
  String get formCleared;

  /// No description provided for @productInformation.
  ///
  /// In en, this message translates to:
  /// **'Product Information'**
  String get productInformation;

  /// No description provided for @productNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Product Name *'**
  String get productNameLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category *'**
  String get categoryLabel;

  /// No description provided for @subcategoryOptional.
  ///
  /// In en, this message translates to:
  /// **'Subcategory (Optional)'**
  String get subcategoryOptional;

  /// No description provided for @descriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Description *'**
  String get descriptionLabel;

  /// No description provided for @describeProductDetail.
  ///
  /// In en, this message translates to:
  /// **'Describe your product in detail...'**
  String get describeProductDetail;

  /// No description provided for @priceEtbLabel.
  ///
  /// In en, this message translates to:
  /// **'Price (ETB) *'**
  String get priceEtbLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity *'**
  String get quantityLabel;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @conditionLabel.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get conditionLabel;

  /// No description provided for @locationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationTitle;

  /// No description provided for @locationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Location on Map *'**
  String get locationOnMap;

  /// No description provided for @tapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Tap to select location'**
  String get tapToSelectLocation;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @sellProduceAction.
  ///
  /// In en, this message translates to:
  /// **'Sell Produce'**
  String get sellProduceAction;

  /// No description provided for @addMorePhotos.
  ///
  /// In en, this message translates to:
  /// **'Add More Photos ({count}/10)'**
  String addMorePhotos(int count);

  /// No description provided for @deleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProductTitle;

  /// No description provided for @deleteProductConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String deleteProductConfirm(String name);

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @productDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get productDeletedSuccess;

  /// No description provided for @loginToViewProducts.
  ///
  /// In en, this message translates to:
  /// **'Please login to view your products'**
  String get loginToViewProducts;

  /// No description provided for @myProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Products'**
  String get myProductsTitle;

  /// No description provided for @noProductsListed.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t listed any products yet'**
  String get noProductsListed;

  /// No description provided for @listFirstProductButton.
  ///
  /// In en, this message translates to:
  /// **'List Your First Product'**
  String get listFirstProductButton;

  /// No description provided for @editAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editAction;

  /// No description provided for @shareNearbyAction.
  ///
  /// In en, this message translates to:
  /// **'Share with Nearby'**
  String get shareNearbyAction;

  /// No description provided for @viewsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} Views'**
  String viewsLabel(int count);

  /// No description provided for @likesLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} Likes'**
  String likesLabel(int count);

  /// No description provided for @shareWifiTitle.
  ///
  /// In en, this message translates to:
  /// **'Share via Wi-Fi'**
  String get shareWifiTitle;

  /// No description provided for @enterFarmerIpLabel.
  ///
  /// In en, this message translates to:
  /// **'Enter the nearby farmer\'s IP address:'**
  String get enterFarmerIpLabel;

  /// No description provided for @propagatingToIp.
  ///
  /// In en, this message translates to:
  /// **'Propagating to {ip}...'**
  String propagatingToIp(String ip);

  /// No description provided for @propagatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Propagated successfully!'**
  String get propagatedSuccess;

  /// No description provided for @failedToConnectIp.
  ///
  /// In en, this message translates to:
  /// **'Failed to connect to {ip}'**
  String failedToConnectIp(String ip);

  /// No description provided for @sendAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendAction;

  /// No description provided for @catCereals.
  ///
  /// In en, this message translates to:
  /// **'Cereals'**
  String get catCereals;

  /// No description provided for @catPulses.
  ///
  /// In en, this message translates to:
  /// **'Pulses'**
  String get catPulses;

  /// No description provided for @catVegetables.
  ///
  /// In en, this message translates to:
  /// **'Vegetables'**
  String get catVegetables;

  /// No description provided for @catFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get catFruits;

  /// No description provided for @catSpices.
  ///
  /// In en, this message translates to:
  /// **'Spices'**
  String get catSpices;

  /// No description provided for @catCoffee.
  ///
  /// In en, this message translates to:
  /// **'Coffee'**
  String get catCoffee;

  /// No description provided for @catOilSeeds.
  ///
  /// In en, this message translates to:
  /// **'Oil Seeds'**
  String get catOilSeeds;

  /// No description provided for @catTubers.
  ///
  /// In en, this message translates to:
  /// **'Tubers'**
  String get catTubers;

  /// No description provided for @catLivestock.
  ///
  /// In en, this message translates to:
  /// **'Livestock'**
  String get catLivestock;

  /// No description provided for @catOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get catOthers;

  /// No description provided for @condFresh.
  ///
  /// In en, this message translates to:
  /// **'Fresh'**
  String get condFresh;

  /// No description provided for @condDry.
  ///
  /// In en, this message translates to:
  /// **'Dry'**
  String get condDry;

  /// No description provided for @condOrganic.
  ///
  /// In en, this message translates to:
  /// **'Organic'**
  String get condOrganic;

  /// No description provided for @condProcessed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get condProcessed;

  /// No description provided for @condFrozen.
  ///
  /// In en, this message translates to:
  /// **'Frozen'**
  String get condFrozen;

  /// No description provided for @unitKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get unitKg;

  /// No description provided for @unitQuintal.
  ///
  /// In en, this message translates to:
  /// **'quintal'**
  String get unitQuintal;

  /// No description provided for @unitTon.
  ///
  /// In en, this message translates to:
  /// **'ton'**
  String get unitTon;

  /// No description provided for @unitSack.
  ///
  /// In en, this message translates to:
  /// **'sack'**
  String get unitSack;

  /// No description provided for @unitPiece.
  ///
  /// In en, this message translates to:
  /// **'piece'**
  String get unitPiece;

  /// No description provided for @unitLiter.
  ///
  /// In en, this message translates to:
  /// **'liter'**
  String get unitLiter;

  /// No description provided for @addClearPhotosHint.
  ///
  /// In en, this message translates to:
  /// **'Add clear photos of your product from different angles'**
  String get addClearPhotosHint;

  /// No description provided for @locationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Location not found'**
  String get locationNotFound;

  /// No description provided for @unableToFindLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to find location. Please try again.'**
  String get unableToFindLocation;

  /// No description provided for @searchLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get searchLocationHint;

  /// No description provided for @selectLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocationTitle;

  /// No description provided for @draggingStatus.
  ///
  /// In en, this message translates to:
  /// **'Dragging...'**
  String get draggingStatus;

  /// No description provided for @fetchingStatus.
  ///
  /// In en, this message translates to:
  /// **'Fetching...'**
  String get fetchingStatus;

  /// No description provided for @confirmLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocationButton;

  /// No description provided for @unknownLocation.
  ///
  /// In en, this message translates to:
  /// **'Unknown Location'**
  String get unknownLocation;

  /// No description provided for @catPesticide.
  ///
  /// In en, this message translates to:
  /// **'Pesticide'**
  String get catPesticide;

  /// No description provided for @catHerbicide.
  ///
  /// In en, this message translates to:
  /// **'Herbicide'**
  String get catHerbicide;

  /// No description provided for @catFungicide.
  ///
  /// In en, this message translates to:
  /// **'Fungicide'**
  String get catFungicide;

  /// No description provided for @catFertilizer.
  ///
  /// In en, this message translates to:
  /// **'Fertilizer'**
  String get catFertilizer;

  /// No description provided for @sellInputs.
  ///
  /// In en, this message translates to:
  /// **'Sell Agricultural Inputs'**
  String get sellInputs;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// No description provided for @synced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get synced;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en', 'om'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
    case 'om':
      return AppLocalizationsOm();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
