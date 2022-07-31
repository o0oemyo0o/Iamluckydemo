import 'package:flutter/material.dart';
import '../../Constants/app_constants.dart';

class OfferTimerWidget extends StatefulWidget {
const OfferTimerWidget({
Key? key,
required this.secondsRemaining,
required this.whenTimeExpires,
this.bgColor = AppConstants.mainColor,
this.textColor = Colors.white,
this.isOfferDetails = false,
this.countDownFormatter,
this.countDownTimerStyle,
}) : super(key: key);

final int secondsRemaining;
final VoidCallback whenTimeExpires;
final TextStyle? countDownTimerStyle;
final Color textColor;
final Color bgColor;
final bool isOfferDetails;
final Function(int seconds)? countDownFormatter;

@override
State createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<OfferTimerWidget>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Duration duration;

  double secondsOpacity = 0.0;

  String secondsString = 0.toString();
  String minutesString = 0.toString();
  String hoursString = 0.toString();
  String daysString = 0.toString();

  /// Seconds
  String get secondsInString {
    final duration = _controller.duration! * _controller.value;
    secondsOpacity = _controller.value;
    if (widget.countDownFormatter != null) {
      return widget.countDownFormatter!(duration.inSeconds) as String;
    } else {
      return formatToSeconds(duration.inSeconds);
    }
  }

  String formatToSeconds(int seconds) {
    seconds = (seconds % 3600).truncate();
    final secondsStr = (seconds % 60).toString().padLeft(2, '0');
    return secondsStr;
  }

  /// Minutes
  String get minutesInString {
    final duration = _controller.duration! * _controller.value;
    if (widget.countDownFormatter != null) {
      return widget.countDownFormatter!(duration.inMinutes) as String;
    } else {
      return formatToSeconds(duration.inMinutes);
    }
  }

  String formatToMinutes(int seconds) {
    final minutes = (seconds / 60).truncate();
    final minutesStr = (minutes).toString().padLeft(2, '0');
    return minutesStr;
  }

  /// Hours
  String get hoursInString {
    final duration = _controller.duration! * _controller.value;
    if (widget.countDownFormatter != null) {
      return widget.countDownFormatter!(duration.inHours) as String;
    } else {
      return formatToSeconds(duration.inHours);
    }
  }

  String formatToHours(int seconds) {
    final hours = (seconds / 3600).truncate();
    final hoursStr = (hours).toString().padLeft(2, '0');
    return hoursStr;
  }

  /// Days
  String get daysInString {
    final duration = _controller.duration! * _controller.value;
    if (widget.countDownFormatter != null) {
      return widget.countDownFormatter!(duration.inDays) as String;
    } else {
      return formatToDays(duration.inDays);
    }
  }

  String formatToDays(int seconds) {
    final days = (seconds / (24)).truncate();
    daysString = (days % 60).toString().padLeft(2, '0');
    return daysString;
  }

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.secondsRemaining);
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller
      ..reverse(from: widget.secondsRemaining.toDouble())
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          widget.whenTimeExpires();
        }
      });
  }

  @override
  void didUpdateWidget(OfferTimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.secondsRemaining != oldWidget.secondsRemaining) {
      setState(() {
        duration = Duration(seconds: widget.secondsRemaining);
        _controller.dispose();
        _controller = AnimationController(
          vsync: this,
          duration: duration,
        );
        _controller
          ..reverse(from: widget.secondsRemaining.toDouble())
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              widget.whenTimeExpires();
            }
          });
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Days
          timerContainer(
            AnimatedBuilder(
              animation: _controller,
              builder: (_, Widget? child) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: Text(
                  daysInString,
                  key: ValueKey<String>(daysInString),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
            'day',
            widget.bgColor,
          ),
          if (widget.isOfferDetails)
            FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    " : ",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: widget.textColor,
                    ),
                  ),
                ],
              ),
            ),

          /// Hours
          timerContainer(
            AnimatedBuilder(
              animation: _controller,
              builder: (_, Widget? child) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: Text(
                  hoursInString,
                  key: ValueKey<String>(hoursInString),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
            'hour',
            widget.bgColor,
          ),
          if (widget.isOfferDetails)
            FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    " : ",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: widget.textColor,
                    ),
                  ),
                ],
              ),
            ),

          /// Minutes
          timerContainer(
            AnimatedBuilder(
              animation: _controller,
              builder: (_, Widget? child) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: Text(
                  minutesInString,
                  key: ValueKey<String>(minutesInString),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
            'minute',
            widget.bgColor,
          ),

          if (widget.isOfferDetails)
            FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 2),
                  Text(
                    " : ",
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: widget.textColor,
                    ),
                  ),
                ],
              ),
            ),

          /// Seconds
          timerContainer(
            AnimatedBuilder(
              animation: _controller,
              builder: (_, Widget? child) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: Text(
                  secondsInString,
                  key: ValueKey<String>(secondsInString),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: widget.textColor,
                  ),
                ),
              ),
            ),
            'second',
            widget.bgColor,
          ),
        ],
      ),
    );
  }

  Widget timerContainer(
      Widget timerWidget,
      String title,
      Color bgColor,
      ) {
    return Column(
      children: [
        Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
                color: bgColor, borderRadius: BorderRadius.circular(5.0)),
            child: timerWidget),
        const SizedBox(height: 5),
        Text(title, style: const TextStyle(color: Colors.black)),
      ],
    );
  }
}
