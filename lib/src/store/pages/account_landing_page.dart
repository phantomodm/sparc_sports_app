//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/models/user.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_widgets.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_classes.dart';

import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:sparc_sports_app/src/store/widgets/buttons.dart';
import 'package:sparc_sports_app/src/store/widgets/woosignal_ui.dart';

import 'package:wp_json_api/exceptions/incorrect_password_exception.dart';
import 'package:wp_json_api/exceptions/invalid_email_exception.dart';
import 'package:wp_json_api/exceptions/invalid_nonce_exception.dart';
import 'package:wp_json_api/exceptions/invalid_username_exception.dart';
import 'package:wp_json_api/models/responses/wp_user_login_response.dart';
import 'package:wp_json_api/wp_json_api.dart';

class AccountLandingPage extends StatefulWidget {
  final bool showBackButton;
  final appTranslations = locator<AppTranslations>();
  AccountLandingPage({this.showBackButton = true});
  
  @override
  _AccountLandingPageState createState() => _AccountLandingPageState();
}

class _AccountLandingPageState extends SparcState<AccountLandingPage> {
  final TextEditingController _tfEmailController = TextEditingController(),
      _tfPasswordController = TextEditingController();
  final appTranslations = locator<AppTranslations>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const StoreLogo(height: 100),
                  Flexible(
                    child: Container(
                      height: 70,
                      padding: const EdgeInsets.only(bottom: 20),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        appTranslations.trans(context, "Login"),
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow:
                          (Theme.of(context).brightness == Brightness.light)
                              ? wsBoxShadow()
                              : null,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        TextEditingRow(
                            heading: appTranslations.trans(context, "Email"),
                            controller: _tfEmailController,
                            keyboardType: TextInputType.emailAddress),
                        TextEditingRow(
                            heading:
                                appTranslations.trans(context, "Password"),
                            controller: _tfPasswordController,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true),
                        PrimaryButton(
                          title: appTranslations.trans(context, "Login"),
                          isLoading: isLocked('login_button'),
                          action: _loginUser,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.account_circle,
                    color: (Theme.of(context).brightness == Brightness.light)
                        ? Colors.black38
                        : Colors.white70,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      appTranslations.trans(context, "Create an account"),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                ],
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, "/account-register"),
            ),
            LinkButton(
                title: appTranslations.trans(context, "Forgot Password"),
                action: () {
                  String? forgotPasswordUrl =
                      AppHelper.instance.appConfig!.wpLoginForgotPasswordUrl;
                  if (forgotPasswordUrl != null) {
                   openBrowserTab(url: forgotPasswordUrl);
                  } else {
                    SparcLogger().info(
                        "No URL found for \"forgot password\".\nAdd your forgot password URL here https://woosignal.com/dashboard/apps");
                  }
                }),
            widget.showBackButton
                ? Column(
                    children: [
                      const Divider(),
                      LinkButton(
                        title: appTranslations.trans(context, "Back"),
                        action: () => Navigator.pop(context),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                  )
          ],
        ),
      ),
    );
  }

  _loginUser() async {
    String email = _tfEmailController.text;
    String password = _tfPasswordController.text;

    if (email.isNotEmpty) {
      email = email.trim();
    }

    if (email == "" || password == "") {
      ToastHelper().showToastNotification(context,
          title: appTranslations.trans(context, "Invalid details"),
          description: AppTranslations()
              .trans(context, "The email and password field cannot be empty"),
          style: ToastNotificationStyleType.DANGER);
      return;
    }

    if (!isEmail(email)) {
      ToastHelper().showToastNotification(context,
          title: appTranslations.trans(context, "Oops"),
          description: AppTranslations()
              .trans(context, "That email address is not valid"),
          style: ToastNotificationStyleType.DANGER);
      return;
    }

    await lockRelease('login_button', perform: () async {
      WPUserLoginResponse? wpUserLoginResponse;
      try {
        wpUserLoginResponse = await WPJsonAPI.instance.api(
            (request) => request.wpLogin(email: email, password: password));
      } on InvalidNonceException catch (_) {
        if (mounted) {
          ToastHelper().showToastNotification(context,
              title: appTranslations.trans(context, "Invalid details"),
              description: appTranslations.trans(
                  context, "Something went wrong, please contact our store"),
              style: ToastNotificationStyleType.DANGER);
        }
      } on InvalidEmailException catch (_) {
        if (mounted) {
          ToastHelper().showToastNotification(context,
              title: appTranslations.trans(context, "Invalid details"),
              description: AppTranslations()
                  .trans(context, "That email does not match our records"),
              style: ToastNotificationStyleType.DANGER);
        }
      } on InvalidUsernameException catch (_) {
        if (mounted) {
          ToastHelper().showToastNotification(context,
              title: appTranslations.trans(context, "Invalid details"),
              description: AppTranslations()
                  .trans(context, "That username does not match our records"),
              style: ToastNotificationStyleType.DANGER);
        }
      } on IncorrectPasswordException catch (_) {
        if (mounted) {
          ToastHelper().showToastNotification(context,
              title: appTranslations.trans(context, "Invalid details"),
              description: AppTranslations()
                  .trans(context, "That password does not match our records"),
              style: ToastNotificationStyleType.DANGER);
        }
      } on Exception catch (_) {
        if (mounted) {
          ToastHelper().showToastNotification(context,
              title: appTranslations.trans(context, "Oops!"),
              description:
                  appTranslations.trans(context, "Invalid login credentials"),
              style: ToastNotificationStyleType.DANGER,
              icon: Icons.account_circle);
        }
      }

      if (wpUserLoginResponse == null) {
        return;
      }

      if (wpUserLoginResponse.status != 200) {
        return;
      }
      String? token = wpUserLoginResponse.data!.userToken;
      String userId = wpUserLoginResponse.data!.userId.toString();
      User user = User.fromUserAuthResponse(token: token, userId: userId);
      //await user.save(SharedKey.authUser);

      if (mounted) {
        ToastHelper().showToastNotification(context,
            title: appTranslations.trans(context, "Hello"),
            description: appTranslations.trans(context, "Welcome back"),
            style: ToastNotificationStyleType.SUCCESS,
            icon: Icons.account_circle);
        navigatorPush(context,
            routeName: UserAuth.instance.redirect, forgetLast: 1);
      }
    });
  }
}
