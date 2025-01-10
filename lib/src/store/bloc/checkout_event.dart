part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object> get props => [];
}

class FetchUserDetails extends CheckoutEvent {

}

class UpdatedBillingCountry extends CheckoutEvent {
  final CustomerCountry country;
  const UpdatedBillingCountry(this.country);
  @override
  List<Object> get props => [country];
}

class UpdateShippingCountry extends CheckoutEvent {
  final CustomerCountry country;
  const UpdateShippingCountry(this.country);
  @override
  List<Object> get props => [country];
}

// Define the UpdateUserDetails event
class UpdateUserDetails extends CheckoutEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String address;
  final String city;
  final String state;
  final String zipCode;

  const UpdateUserDetails({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  @override
  List<Object> get props => [
        firstName,
        lastName,
        email,
        address,
        city,
        state,
        zipCode,
      ];
}

class InitializeCheckout extends CheckoutEvent {} 
class UpdateBillingAddress extends CheckoutEvent {
  final CustomerAddress address;
  const UpdateBillingAddress(this.address);
}
class UpdateShippingAddress extends CheckoutEvent {
  final CustomerAddress address;
  const UpdateShippingAddress(this.address);
}
class ToggleDifferentShippingAddress extends CheckoutEvent {
  final bool hasDifferentShippingAddress;
  const ToggleDifferentShippingAddress(this.hasDifferentShippingAddress);
}
class ToggleRememberDetails extends CheckoutEvent {
  final bool rememberDetails;
  const ToggleRememberDetails(this.rememberDetails);
}
class ProceedToShipping extends CheckoutEvent {}
class ProceedToPayment extends CheckoutEvent {}
class ProceedToReview extends CheckoutEvent {}
class ProceedToConfirmation extends CheckoutEvent {}
class CancelCheckout extends CheckoutEvent {}
class PlaceOrder extends CheckoutEvent {}
class OrderPlaced extends CheckoutEvent {}
class OrderFailed extends CheckoutEvent {
  final String error;
  const OrderFailed(this.error);
}
class OrderCancelled extends CheckoutEvent {}
class OrderConfirmed extends CheckoutEvent {}
