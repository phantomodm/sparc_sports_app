import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sparc_sports_app/src/store/models/checkout_session.dart';
import 'package:sparc_sports_app/src/store/models/customer_address.dart';
import 'package:sparc_sports_app/src/store/models/customer_country.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  CheckoutBloc() : super(const CheckoutInitial()) {
    on<InitializeCheckout>((event, emit) {
      // Initialize checkout session and customer details
      CheckoutSession.getInstance.initSession();
      final billingDetails = CheckoutSession.getInstance.billingDetails!;
      emit(CheckoutLoaded(
        billingAddress: billingDetails.billingAddress ?? CustomerAddress(), // Provide a default value
        shippingAddress: billingDetails.shippingAddress ?? CustomerAddress(),
        hasDifferentShippingAddress: CheckoutSession.getInstance.shipToDifferentAddress ?? false,
        rememberDetails: billingDetails.rememberDetails ?? true
      ));
    });

    // In your CheckoutBloc's on<CheckoutEvent> method:
    on<UpdateUserDetails>((event, emit) {
      final updatedUserDetails = {
        'firstName': event.firstName,
        'lastName': event.lastName,
        'email': event.email,
        'address': event.address,
        'city': event.city,
        'state': event.state,
        'zipCode': event.zipCode,
      };
      emit(state.copyWith(userDetails: updatedUserDetails));
    });

    on<UpdateBillingAddress>((event, emit) {
      if (state is CheckoutLoaded) {
        final currentState = state as CheckoutLoaded;
        emit(currentState.copyWith(billingAddress: event.address));
      }
    });

    on<UpdateShippingAddress>((event, emit) {
      if (state is CheckoutLoaded) {
        final currentState = state as CheckoutLoaded;
        emit(currentState.copyWith(shippingAddress: event.address));
      }
    });

    on<ToggleDifferentShippingAddress>((event, emit) {
      if (state is CheckoutLoaded) {
        final currentState = state as CheckoutLoaded;
        emit(currentState.copyWith(hasDifferentShippingAddress: event.hasDifferentShippingAddress));
      }
    });

    on<ToggleRememberDetails>((event, emit) {
      if (state is CheckoutLoaded) {
        final currentState = state as CheckoutLoaded;
        emit(currentState.copyWith(rememberDetails: event.rememberDetails));
      }
    });

    on<ProceedToShipping>((event, emit) async {
      // Validate and save addresses
      // ...

      // Fetch shipping methods
      // ...

      emit(const CheckoutShipping(
        shippingMethods: [], // Replace with fetched shipping methods
      ));
    });

    // ... add more event handlers for other checkout steps ...
  }

  
  
}

