import 'package:cas/cas.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';

class CasInitBuilder extends StatefulWidget {
  final Widget Function(BuildContext context) builder;

  CasInitBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  _CasInitBuilderState createState() => _CasInitBuilderState();
}

class _CasInitBuilderState extends State<CasInitBuilder> {
  late Future<dartz.Unit> casInitFuture;

  @override
  void initState() {
    casInitFuture = Cas.initialize(
      isTestBuild: true,
      userId: null,
      onInitializationListener: (bool success, String? error) {
      },
      logger: (String eventName) {
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: casInitFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return SizedBox.shrink();

        return widget.builder(context);
      },
    );
  }
}
