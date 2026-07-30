import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../theme/app_colors.dart';

class NoInternetBanner extends StatefulWidget {
  final Widget child;

  const NoInternetBanner({super.key, required this.child});

  @override
  State<NoInternetBanner> createState() => _NoInternetBannerState();
}

class _NoInternetBannerState extends State<NoInternetBanner> {
  bool isOffline = false;
  StreamSubscription? subscription;

  @override
  void initState() {
    super.initState();
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() => isOffline = result.contains(ConnectivityResult.none));
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (isOffline)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Container(
                width: double.infinity,
                color: context.colors.error,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'No Internet Connection',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: context.colors.white, fontSize: 13),
                ),
              ),
            ),
          ),
      ],
    );
  }
}