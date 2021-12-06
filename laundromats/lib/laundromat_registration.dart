// Class for the page to register for a time at a laundromat

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'theme.dart';

// ignore: must_be_immutable
class LaundromatRegistration extends StatefulWidget {
  String address;
  String price;
  String name;
  LaundromatRegistration(
      {Key? key,
      required this.name,
      required this.address,
      required this.price})
      : super(key: key);

  @override
  State<LaundromatRegistration> createState() => _LaundromatRegistrationState();
}

class _LaundromatRegistrationState extends State<LaundromatRegistration> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2021, 12),
        lastDate: DateTime(2101));

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registration"),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Resgister at ${widget.name}?",
                style: heading2.copyWith(color: textBlack),
              ),
              const SizedBox(
                height: 20,
              ),
              Image.asset(
                'assets/images/accent.png',
                width: 99,
                height: 4,
              ),
              const SizedBox(
                height: 48,
              ),
              Text("Address: ${widget.address}",
                  style: heading5.copyWith(color: textBlack)),
              Text(
                "Price: \$${widget.price}",
                style: heading5.copyWith(color: textBlack),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text("Select Date"),
                  ),
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: heading5.copyWith(color: textBlack),
                  ),
                ],
              )),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancel")),
                  ElevatedButton(
                      onPressed: () {
                        LaundromatNotification(context)
                            .selectNotification("Test");
                        LaundromatNotification(context)
                            .showScheduledNotification(
                                selectedDate, widget.address);
                      },
                      child: const Text("Confirm")),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

class LaundromatNotification {
  BuildContext context;
  late FlutterLocalNotificationsPlugin notification;

  LaundromatNotification(this.context) {
    initNotification();
  }

  initNotification() {
    notification = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    IOSInitializationSettings iosInitializationSettings =
        const IOSInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        iOS: iosInitializationSettings, android: androidInitializationSettings);

    notification.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    tz.initializeTimeZones();
  }

  Future<String?> selectNotification(String? payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: const Text("Registered for Laundromat"),
            content: Container(
              height: 120,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("You successfully booked"),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Back"))
                ],
              ),
            )));
  }

  Future showNotification() async {
    var android = const AndroidNotificationDetails("channelId", "channelName",
        priority: Priority.high, importance: Importance.max);

    var platformDetails = NotificationDetails(android: android);

    await notification.show(100, "Simple Notification", "body", platformDetails,
        payload: "Demo payload");
  }

  Future showScheduledNotification(
      DateTime scheduledTime, String address) async {
    var android = const AndroidNotificationDetails("channelId", "channelName",
        priority: Priority.high, importance: Importance.max);
    var platformDetails = NotificationDetails(android: android);
    await notification.zonedSchedule(
        101,
        "Laundromat booked for today",
        "Reminder that you have a laundromat appointment today at ${address}",
        tz.TZDateTime.from(scheduledTime, tz.local)
            .add(const Duration(seconds: 5)),
        platformDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
