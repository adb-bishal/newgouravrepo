import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/screens/mentor/mentor_slot_model.dart'
    hide Mentor;
import 'package:stockpathshala_beta/view/screens/root_view/home_view/mentor_model.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/progress_dialog.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../home/mentor_shimmer.dart';
import '../mentor/mentor_controller.dart';
import 'package:confetti/confetti.dart';

class MentorScreen extends GetView<MentorController> {
  const MentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Get.put(MentorController());

    return Obx(() {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            title: Text(
              'Choose Your Mentor',
              style: const TextStyle(
                  fontSize: 14,
                  color: ColorResource.white,
                  fontWeight: FontWeight.w600),
            ),
            backgroundColor: ColorResource.primaryColor,
          ),
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: controller.confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  numberOfParticles: 40,
                  maxBlastForce: 30,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  // createParticlePath: drawStar, // define a custom shape/path.
                ),
              ),
              RefreshIndicator(
                  onRefresh: controller.onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: controller.isLoading.value &&
                            controller.onRefreshLoading.value == false
                        ? MediaQuery.of(context).size.width < 600
                            ? MentorShimmer.mentorList()
                            : ShimmerEffect.instance
                                .upcomingLiveWebinarClassLoaderForTab()
                        : controller.categoriesData.value.mentors.isEmpty
                            ? const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(StringResource.noMentor),
                                ),
                              )
                            : categoryList(
                                controller,
                                controller.filteredCategoriesData1.value.mentors
                                            .isNotEmpty ==
                                        true
                                    ? controller
                                        .filteredCategoriesData1.value.mentors
                                    : controller.categoriesData.value.mentors,
                              ),
                  )),
              controller.isLoading.value
                  ? const SizedBox.shrink()
                  : controller.categoriesData.value.counsellingPrice.isEmpty
                      ? const Text(StringResource.noMentor)
                      : Align(
                          alignment: Alignment.bottomCenter,
                          child: GestureDetector(
                            onTap: () {
                              initiateCounsellingPayment(
                                onPaymentCallBack: (response, orderId) async {
                                  try {
                                    await controller.verifyPayment(
                                      response,
                                      orderId,
                                      (data) {
                                        print(
                                            "Payment verification success: $data");
                                        showBookingConfirmationDialog(
                                          successMessage: data?.message,
                                          Get.context!,
                                          isSuccess: true,
                                          onConfirm: () =>
                                              Navigator.pop(context),
                                        );
                                        controller.confettiController.play();
                                      },
                                      (error) {
                                        print(
                                            "Payment verification failed: $error");
                                        showBookingConfirmationDialog(
                                          Get.context!,
                                          isSuccess: false,
                                          onConfirm: () =>
                                              Navigator.pop(context),
                                        );
                                      },
                                    );
                                  } catch (e, stack) {
                                    print(
                                        "🚨 Exception in payment verification: $e");
                                    print(stack);

                                    showDialog(
                                      context: Get.context!,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                            "Payment Verification Error"),
                                        content: const Text(
                                            "An unexpected error occurred while verifying payment. Please contact support."),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                },
                                controller,
                                slotId: '',
                                categoryId: controller.categoryId,
                                amount: (int.parse(controller.categoriesData
                                            .value.counsellingPrice) *
                                        100)
                                    .toString(),
                                onSuccess: () {
                                  print(" Payment Successful");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Payment successful!")),
                                  );
                                },
                                onError: (message) {
                                  print(" Payment Failed: $message");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                },
                                onCancel: () {
                                  print(" Payment Cancelled");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Payment cancelled")),
                                  );
                                },
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: ColorResource.lineGrey2Color,
                                    width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorResource.lineGrey2Color
                                        .withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: MediaQuery.of(context).size.height * 0.11,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                        constraints: BoxConstraints(
                                          minWidth:
                                              MediaQuery.of(context).size.width,
                                        ),
                                        decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                ColorResource.lightYellowColor,
                                                ColorResource.errorColor
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0.0, vertical: 12),
                                          child: Text(
                                            // "Skip & Book Counselling / ₹${controller.categoriesData.value.counsellingPrice} only",
                                            "Skip & Book Counselling",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: ColorResource.white,
                                                fontSize: 15),
                                            textAlign: TextAlign.center,
                                          ),
                                        ))),
                              ),
                            ),
                          )),
              controller.isBuyLoading.value == true
                  ? Container(
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 1,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                          Text(
                            StringResource.paymentInProgress,
                            style: TextStyle(color: ColorResource.white),
                          )
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    });
  }
}

void showBookingConfirmationDialog(
  BuildContext context, {
  String? successMessage,
  String? failureMessage,
  bool isSuccess = true,
  VoidCallback? onConfirm,
  String? message,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        actionsPadding: const EdgeInsets.only(bottom: 20, left: 24, right: 24),
        title: Container(
          padding: const EdgeInsets.only(top: 30, bottom: 10),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSuccess
                  ? Image.asset(
                      ImageResource.instance.paymentSuccessImg,
                    )
                  : Image.asset(
                      ImageResource.instance.paymentFailureImg,
                      width: 150,
                      height: 150,
                    ),
              const SizedBox(height: 20),
              Text(
                isSuccess
                    ? (successMessage ?? "Booking Confirmed!")
                    : (failureMessage ?? "Booking Failed!"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: isSuccess ? Colors.black : Colors.red,
                ),
              ),
              const SizedBox(height: 12),
              // Subtitle message
              Text(
                isSuccess
                    ? "Your mentorship counselling session has been\nsuccessfully scheduled."
                    : "There was an issue processing your request.\nPlease try again.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Action button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFF4A6CF7), // Blue color like in screenshot
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (isSuccess) {
                  Get.back(result: 'payment');
                }
              },
              child: Text(
                isSuccess ? "View Details" : "Try Again",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

// Usage examples:
void showSuccessDialog(BuildContext context) {
  showBookingConfirmationDialog(
    context,
    isSuccess: true,
    successMessage: "Booking Confirmed!",
    onConfirm: () {
      // Navigate to details page or home
      print("Navigate to booking details");
    },
  );
}

void showFailureDialog(BuildContext context) {
  showBookingConfirmationDialog(
    context,
    isSuccess: false,
    failureMessage: "Payment Failed!",
    onConfirm: () {
      // Retry payment or go back
      print("Retry payment");
    },
  );
}
// void showPaymentConfirmationDialog(BuildContext context, String? message) {
//   final bool isSuccess = message != null && message.isNotEmpty;
//
//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (_) => WillPopScope(
//       onWillPop: () async => false,
//       child: AlertDialog(
//         backgroundColor: ColorResource.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         titlePadding: EdgeInsets.zero,
//         contentPadding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
//         actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
//         title: Container(
//           padding: const EdgeInsets.only(top: 20),
//           alignment: Alignment.center,
//           child: Column(
//             children: [
//               Image.asset(
//                 isSuccess
//                     ? "assets/svg/success.gif"
//                     : "assets/svg/payment_failed.gif",
//                 width: 60,
//                 height: 60,
//               ),
//               const SizedBox(height: 12),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   isSuccess ? message! : "Payment Failed",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           Center(
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: ColorResource.white,
//                 foregroundColor: Colors.black,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 if (isSuccess) {
//                   Get.offAllNamed(Routes.rootView);
//                 }
//               },
//               child: const Padding(
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: Text("OK"),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }

Future<void> initiateCounsellingPayment(
  MentorController controller, {
  String? slotId,
  required String amount,
      int? categoryId,
  required VoidCallback onSuccess,
  required void Function(
          PaymentSuccessResponse response, String razorpayOrderId)
      onPaymentCallBack,
  VoidCallback? onCancel,
  Function(String error)? onError,
}) async {
  controller.onBuyCounselling(
    slotId,
    amount,
      categoryId,
    onPaymentSuccess: (paymentSuccessResponse, razorpayOrderId) {
      onPaymentCallBack(paymentSuccessResponse, razorpayOrderId);
    },
  );
}

void showAppointmentBottomSheet(
  BuildContext context,
  Data data,
  controller,
) {
  showModalBottomSheet(
    backgroundColor: ColorResource.white,
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: AppointmentBookingContent(data, controller),
        ),
      ),
    ),
  );
}

class AppointmentBookingContent extends StatefulWidget {
  const AppointmentBookingContent(this.data, this.controller, {super.key});
  final Data data;
  final MentorController controller;

  @override
  AppointmentBookingContentState createState() =>
      AppointmentBookingContentState();
}

class AppointmentBookingContentState extends State<AppointmentBookingContent> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlot;
  late List<String> dates;
  late List<DateTime> weekDates;
  late List<Slot> timeSlots;
  int? slotId = 0;
  List<String> timeSlot = [];

  bool _hasAvailableSlots(DateTime date) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    return widget.data.slots.containsKey(formattedDate) &&
        widget.data.slots[formattedDate]!.isNotEmpty;
  }

  List<DateTime> getWeekDates() {
    DateTime normalizedDate =
        DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    print("cdkcdlcmdl $normalizedDate");

    DateTime lastDayOfMonth = DateTime(
      normalizedDate.month == 12
          ? normalizedDate.year + 1
          : normalizedDate.year,
      normalizedDate.month == 12 ? 1 : normalizedDate.month + 1,
      0,
    );

    List<DateTime> dateList = [];
    DateTime currentDate = normalizedDate;

    while (!currentDate.isAfter(lastDayOfMonth)) {
      dateList.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dateList;
  }

  List<DateTime> getSlots() {
    return dates.map((dateStr) => DateTime.parse(dateStr)).toList();
  }

  void getTimeSlot(DateTime selectedDate) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    timeSlots = widget.data.slots[formattedDate] ?? [];
    _selectedSlot = null;

    if (kDebugMode) {
      print("Original UTC: $selectedDate");
      print("Formatted Date Key: $formattedDate");
      print("Fetched Time Slots (${timeSlots.length}):");
      for (var slot in timeSlots) {
        print("Slot Start: ${slot.slotStart}, Slot End: ${slot.slotEnd}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    dates = widget.data.slots.keys.toList();
    timeSlots = widget.data.slots.values
        .map((e) => e.map((item) => item).toList())
        .expand((e) => e)
        .toList();
    // _selectedSlot = timeSlots[0].slotStart;
    print("timeSlots ${timeSlots[0].slotStart}");
    weekDates = getWeekDates();
    print("server time ${widget.controller.categoriesData.value.serverTime}");
    _selectedDate =
        DateTime.parse(widget.controller.categoriesData.value.serverTime);
    getTimeSlot(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Choose Counselling Slots",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 16),
            SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weekDates.length,
                  itemBuilder: (context, index) {
                    final date = weekDates[index];
                    final isSelected = _isSameDay(date, _selectedDate);
                    final hasSlots = _hasAvailableSlots(
                        date); // Check if date has available slots
                    final isDisabled = !hasSlots;

                    return GestureDetector(
                      onTap: isDisabled
                          ? null
                          : () {
                              setState(() {
                                _selectedDate = date;
                                getTimeSlot(date);
                              });
                            },
                      child: Container(
                        width: 50,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDisabled
                                ? Colors.grey.shade300
                                : isSelected
                                    ? ColorResource.primaryColor
                                    : Colors.grey.shade200,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: isDisabled
                              ? Colors.grey.shade50
                              : Colors.transparent,
                        ),
                        child: Opacity(
                          opacity: isDisabled ? 0.5 : 1.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                DateFormat.E().format(date),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color:
                                      isDisabled ? Colors.grey : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                date.day.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      isDisabled ? Colors.grey : Colors.black,
                                ),
                              ),
                              if (isDisabled) const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3.5,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              children: timeSlots.map((slot) {
                // Convert slotStart from UTC to local
                final slotStartLocal = DateTime.parse(slot.slotStart).toLocal();

                // Format slotSart to string for comparison
                final formattedSlotStart =
                    DateFormat('yyyy-MM-dd HH:mm:ss').format(slotStartLocal);

                final isSelected = formattedSlotStart == _selectedSlot;

                return GestureDetector(
                  onTap: () => setState(() {
                    slotId = slot.id;

                    _selectedSlot = formattedSlotStart;
                  }),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ColorResource.primaryColor
                          : Colors.white,
                      border: Border.all(
                        color: isSelected
                            ? ColorResource.primaryColor
                            : Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      DateFormat('hh:mm a')
                          .format(slotStartLocal), // Use local time for display
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isSelected ? ColorResource.white : Colors.black,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                if (_selectedSlot != null && _selectedDate != null) {
                  print("slotId $slotId");
                  Navigator.pop(context);
                  initiateCounsellingPayment(
                    onPaymentCallBack: (response, orderId) async {
                      try {
                        await widget.controller.verifyPayment(
                          response,
                          orderId,
                          (data) {
                            print("Payment verification success: $data");
                            showBookingConfirmationDialog(
                              successMessage: data?.message,
                              Get.context!,
                              isSuccess: true,
                              onConfirm: () => Navigator.pop(context),
                            );
                            widget.controller.confettiController.play();
                          },
                          (error) {
                            print("Payment verification failed: $error");
                            showBookingConfirmationDialog(
                              Get.context!,
                              isSuccess: false,
                              onConfirm: () => Navigator.pop(context),
                            );
                          },
                        );
                      } catch (e, stack) {
                        print("🚨 Exception in payment verification: $e");
                        print(stack);

                        showDialog(
                          context: Get.context!,
                          builder: (context) => AlertDialog(
                            title: const Text("Payment Verification Error"),
                            content: const Text(
                                "An unexpected error occurred while verifying payment. Please contact support."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } finally {}
                    },
                    widget.controller,
                    slotId: slotId.toString() ?? '',
                    categoryId:widget.controller.categoryId,
                    amount: (int.parse(widget.controller.categoriesData.value
                                .counsellingPrice) *
                            100)
                        .toString(),
                    onSuccess: () {
                      print(" Payment Successful");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment successful!")),
                      );
                    },
                    onError: (message) {
                      print(" Payment Failed: $message");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(message)),
                      );
                    },
                    onCancel: () {
                      print(" Payment Cancelled");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Payment cancelled")),
                      );
                    },
                  );
                }
              },
              child: SizedBox(
                width: double.infinity,
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _selectedSlot != null && _selectedDate != null
                          ? [
                              ColorResource.lightYellowColor,
                              ColorResource.errorColor
                            ]
                          : [ColorResource.grey_2, ColorResource.grey_2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Book Counselling',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color:
                                _selectedSlot != null && _selectedDate != null
                                    ? ColorResource.white
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

Widget categoryList(controller, List<Mentors> mentors) {
  return Container(
    margin: const EdgeInsets.only(bottom: 80),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        ListView.builder(
          itemCount: mentors.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            var mentorData = mentors[index];
            return Container(
              padding: const EdgeInsets.only(top: 16),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorResource.primaryColor.withOpacity(0.01),
                border: Border.all(
                    color: ColorResource.primaryColor.withOpacity(0.2),
                    width: 1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color:
                                    ColorResource.primaryColor.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  mentorData.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Center(
                                    child: Icon(Icons.person,
                                        color: Colors.grey.shade400, size: 40),
                                  ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                        strokeWidth: 2,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mentorData.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                ),
                              ),
                              // const SizedBox(height: 4),
                              // Text(
                              //   mentorData.expertise.title,
                              //   style: TextStyle(
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                              const SizedBox(width: 16),
                              RatingBarIndicator(
                                rating: mentorData.ratings,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 24.0,
                                direction: Axis.horizontal,
                              ),
                              const SizedBox(height: 4),
                              if (mentorData.certification != '')
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Image.asset(
                                        ImageResource.instance.mentorCheckIcon,
                                        width: 14,
                                        height: 14,
                                        color: ColorResource.grey,
                                      ),
                                    ),
                                    Text(
                                      mentorData.certification,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Image.asset(
                                      ImageResource.instance.mentorCheckIcon,
                                      width: 14,
                                      height: 14,
                                      color: ColorResource.grey,
                                    ),
                                  ),
                                  Text(
                                    'PnL Verified',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(
                                      FontAwesomeIcons.graduationCap,
                                      size: 12,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    mentorData.experience == 1
                                        ? '${mentorData.experience} Year Experience'
                                        : '${mentorData.experience} Years Experience',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Icon(
                                        size: 14,
                                        Icons.videocam_outlined,
                                        color: Colors.black),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${mentorData.liveClasses}+ SP Live Classes',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
                                      child: Image.asset(
                                        ImageResource.instance.mentorCheckIcon,
                                        width: 14,
                                        height: 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    mentorData.availability != ""
                                        ? "Available ${mentorData.availability}"
                                        : 'Available',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // showBookingConfirmationDialog(
                      //   context,
                      //   isSuccess: true,
                      //   onConfirm: () => Navigator.pop(context),
                      // );
                      // controller.confettiController?.play();

                      // Get.offAllNamed(Routes.rootView);
                      // Get.find<RootViewController>().onRedirectHome(0);
                      // Get.back(result: 'payment');

                      //
                      if (Get.find<AuthService>().isGuestUser.value) {
                        ProgressDialog().showFlipDialog(isForPro: false);
                        return;
                      }
                      MentorSlotModel? response =
                          await controller.getMentorSlot(mentorData.id);

                      if (response != null && response.data.slots.isNotEmpty) {
                        showAppointmentBottomSheet(
                            context, response.data, controller);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("No slots available for this mentor.")),
                        );
                      }
                    },
                    child: Obx(() {
                      final isLoading =
                          controller.mentorLoadingMap[mentorData.id]?.value ??
                              false;

                      if (isLoading) {
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          decoration: BoxDecoration(
                            // color: ColorResource.primaryDark,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: SizedBox(
                                height: 28,
                                width: 28,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: ColorResource.primaryDark,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          decoration: BoxDecoration(
                            color: ColorResource.primaryDark,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                          ),
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: ColorResource.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Choose Slot",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: ColorResource.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
                  ),
                  SizedBox(height: 12),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}

class UserGreetingWidget extends StatelessWidget {
  final String? title;
  final double titleFontSize;
  final double subTitleFontSize;

  UserGreetingWidget({
    this.title,
    this.titleFontSize = DimensionResource.fontSizeSmall - 1,
    this.subTitleFontSize = DimensionResource.fontSizeExtraLarge - 1,
    super.key,
  });

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? greeting(),
                style: StyleResource.instance.styleLight(
                    color: hexToColor(homeController
                        .homeData.value.homepageUi?.userGreetingColor),
                    fontSize: screenWidth < 500
                        ? titleFontSize
                        : DimensionResource.fontSizeLarge),
              ),
              Text(
                Get.find<AuthService>().user.value.name == null
                    ? "User"
                    : Get.find<AuthService>()
                        .user
                        .value
                        .name
                        .toString()
                        .capitalize!,
                style: StyleResource.instance.styleMedium(
                    color: hexToColor(homeController
                        .homeData.value.homepageUi?.userNameColor),
                    fontSize: screenWidth < 500
                        ? subTitleFontSize
                        : DimensionResource.fontSizeOverLarge),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              if (!Get.find<AuthService>().isGuestUser.value) {
                Get.toNamed(Routes.profileScreen);
              } else {
                ProgressDialog().showFlipDialog(isForPro: false);
              }
            },
            child: imageCircleContainer(
                radius: screenWidth < 500 ? 19 : 25,
                url: Get.find<AuthService>().user.value.profileImage ?? ""),
          ),
        ],
      );
    });
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return StringResource.goodMorning;
    }
    if (hour < 17) {
      return StringResource.goodAfternoon;
    }
    return StringResource.goodEvening;
  }
}

Color hexToColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return Colors.white; // Default fallback color
  }
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor"; // Add alpha value if not provided
  }
  try {
    return Color(int.parse("0x$hexColor"));
  } catch (e) {
    print("Invalid hex color: $hexColor");
    return Colors.transparent; // Default fallback color
  }
}

CachedNetworkImage cachedNetworkImage(String url,
    {BoxFit fit = BoxFit.cover,
    Color? color,
    bool imageLoader = false,
    Alignment? alignment}) {
  return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      placeholder: (context, url) => imageLoader
          ? const CommonCircularIndicator()
          : ShimmerEffect.instance.imageLoader(color: color),
      errorWidget: (context, url, error) {
        if (kDebugMode) {
          logPrint('network image error: $error');
        }
        return imageLoader
            ? const CommonCircularIndicator()
            : Container(
                color: color ?? ColorResource.imageBackground,
                padding: const EdgeInsets.all(22.0),
                child: Image.asset(
                  ImageResource.instance.errorImage,
                  fit: BoxFit.contain,
                ),
              );
      });
}

Widget imageCircleContainer({
  required double radius,
  String url = ImageResource.defaultUser,
  bool showDot = false,
}) {
  return Stack(
    children: [
      CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(url),
        onBackgroundImageError: (e, s) {},
      ),
      if (showDot)
        const Positioned(
          bottom: 0,
          right: 0,
          child: Icon(
            Icons.circle,
            color: ColorResource.greenColor,
            size: 11,
          ),
        ),
    ],
  );
}
