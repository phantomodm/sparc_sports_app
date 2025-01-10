part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  final Map<String, dynamic> userDetails;
  const CheckoutState({this.userDetails = const {}});

  @override
  List<Object> get props => [userDetails];

  CheckoutState copyWith({
    Map<String, dynamic>? userDetails,
  });
}

class CheckoutLoaded extends CheckoutState {
  final CustomerAddress billingAddress;
  final CustomerAddress shippingAddress;
  final bool hasDifferentShippingAddress;
  final bool rememberDetails;
  final bool valRememberDetails;
  final int activeTabIndex;

  const CheckoutLoaded({
    required this.billingAddress,
    required this.shippingAddress,
    this.hasDifferentShippingAddress = false,
    this.rememberDetails = true,
    this.valRememberDetails = true,
    this.activeTabIndex = 0,
  });

  @override
  List<Object> get props => [
        billingAddress,
        shippingAddress,
        hasDifferentShippingAddress,
        rememberDetails,
        valRememberDetails,
        activeTabIndex
      ];

  @override
  CheckoutLoaded copyWith({
    Map<String, dynamic>? userDetails,
    CustomerAddress? billingAddress,
    CustomerAddress? shippingAddress,
    Map<dynamic, dynamic>? userProfile,
    bool? hasDifferentShippingAddress,
    bool? rememberDetails,
    bool? valRememberDetails,
    int? activeTabIndex,
  }) {
    return CheckoutLoaded(
      billingAddress: billingAddress ?? this.billingAddress,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      hasDifferentShippingAddress:
          hasDifferentShippingAddress ?? this.hasDifferentShippingAddress,
      rememberDetails: rememberDetails ?? this.rememberDetails,
      valRememberDetails: valRememberDetails ?? this.valRememberDetails,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
    );
  }
}

class CheckoutInitial extends CheckoutState {
  
  const CheckoutInitial({super.userDetails});@override
  CheckoutState copyWith({
    Map<String, dynamic>? userDetails,
    CustomerAddress? billingAddress,
    CustomerAddress? shippingAddress,
    Map<dynamic, dynamic>? userProfile,
    bool? hasDifferentShippingAddress,
    bool? rememberDetails,
    bool? valRememberDetails,
    int? activeTabIndex,
  }) {
    return CheckoutInitial(
      userDetails: userDetails ?? this.userDetails,
    );
  }
}

class UpdateBillingCountry extends CheckoutState {
  final CustomerCountry country;
  const UpdateBillingCountry(this.country);
  @override
  List<Object> get props => [country];

  @override
  CheckoutState copyWith({
    Map<String, dynamic>? userDetails,
  }) {
    return UpdateBillingCountry(country);
  }
}

class CheckoutShipping extends CheckoutState {
  final List<dynamic> shippingMethods;
  const CheckoutShipping({
    this.shippingMethods = const [],
  });

  @override
  List<Object> get props => [shippingMethods];

  @override
  CheckoutState copyWith({
    Map<String, dynamic>? userDetails,
  }) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }
}