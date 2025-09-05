// class MentorshipModel {
//   final bool status;
//   final MentorshipData? data;
//
//   MentorshipModel({required this.status, this.data});
//
//   factory MentorshipModel.fromJson(Map<String, dynamic> json) {
//     return MentorshipModel(
//       status: json['status'] as bool,
//       data: json['data'] != null ? MentorshipData.fromJson(json['data']) : null,
//     );
//   }
// }
//
// class MentorshipData {
//   final List<String> certification;
//   final String screenBgColor;
//   final String seperatorColor;
//   final String mentorListTitle;
//   final String detailButtonText;
//   final String detailButtonColor;
//   final String mentorListBgColor;
//   final String monthStripBgColor;
//   final String mentorshipInfoColor;
//   final String certificationIconUrl;
//   final String mentorshipTitleColor;
//   final String monthStripTextColor;
//   final String mentorListTitleColor;
//   final String detailButtonTextColor;
//   final String seatsLeftStripBgColor;
//   final String mentorshipCardBgColor1;
//   final String mentorshipCardBgColor2;
//   final String seatsLeftStripTextColor;
//   final String mentorshipInfoTitle1;
//   final String mentorshipInfoTitle2;
//   final String mentorshipInfoTitle3;
//
//   // Previously added fields
//   final String mentorshipPlusCardBgColor1;
//   final String mentorshipPlusCardBgColor2;
//   final String mentorshipPlusLabel;
//   final String mentorshipInfoIcon1Url;
//   final String mentorshipInfoIcon2Url;
//   final String mentorshipInfoIcon3Url;
//
//   // **Newly Added Fields**
//   final String mentorshipCardAnimationColor1;
//   final String mentorshipCardAnimationColor2;
//   final String mentorshipPlusLabelTextColor1;
//   final String mentorshipPlusLabelTextColor2;
//   final String mentorshipPlusLabelBgColor;
//   final String mentorshipPlusStripText;
//   final String mentorshipPlusStripTextColor;
//   final String mentorshipPlusStripBgColor;
//   final String seatLeftLabel;
//
//   MentorshipData({
//     required this.certification,
//     required this.screenBgColor,
//     required this.seperatorColor,
//     required this.mentorListTitle,
//     required this.detailButtonText,
//     required this.detailButtonColor,
//     required this.mentorListBgColor,
//     required this.monthStripBgColor,
//     required this.mentorshipInfoColor,
//     required this.certificationIconUrl,
//     required this.mentorshipTitleColor,
//     required this.monthStripTextColor,
//     required this.mentorListTitleColor,
//     required this.detailButtonTextColor,
//     required this.seatsLeftStripBgColor,
//     required this.mentorshipCardBgColor1,
//     required this.mentorshipCardBgColor2,
//     required this.seatsLeftStripTextColor,
//     required this.mentorshipInfoTitle1,
//     required this.mentorshipInfoTitle2,
//     required this.mentorshipInfoTitle3,
//
//     // Previously added fields
//     required this.mentorshipPlusCardBgColor1,
//     required this.mentorshipPlusCardBgColor2,
//     required this.mentorshipPlusLabel,
//     required this.mentorshipInfoIcon1Url,
//     required this.mentorshipInfoIcon2Url,
//     required this.mentorshipInfoIcon3Url,
//
//     // **New Fields**
//     required this.mentorshipCardAnimationColor1,
//     required this.mentorshipCardAnimationColor2,
//     required this.mentorshipPlusLabelTextColor1,
//     required this.mentorshipPlusLabelTextColor2,
//     required this.mentorshipPlusLabelBgColor,
//     required this.mentorshipPlusStripText,
//     required this.mentorshipPlusStripTextColor,
//     required this.mentorshipPlusStripBgColor,
//     required this.seatLeftLabel,
//   });
//
//   factory MentorshipData.fromJson(Map<String, dynamic> json) {
//     return MentorshipData(
//       certification: List<String>.from(json['certification'] ?? []),
//       screenBgColor: json['screen_bg_color'] ?? '',
//       seperatorColor: json['seperator_color'] ?? '',
//       mentorListTitle: json['mentor_list_title'] ?? '',
//       detailButtonText: json['detail_button_text'] ?? '',
//       detailButtonColor: json['detail_button_color'] ?? '',
//       mentorListBgColor: json['mentor_list_bg_color'] ?? '',
//       monthStripBgColor: json['month_strip_bg_color'] ?? '',
//       mentorshipInfoColor: json['mentorship_info_color'] ?? '',
//       certificationIconUrl: json['certification_icon_url'] ?? '',
//       mentorshipTitleColor: json['mentorship_title_color'] ?? '',
//       monthStripTextColor: json['month_strip_text_color'] ?? '',
//       mentorListTitleColor: json['mentor_list_title_color'] ?? '',
//       detailButtonTextColor: json['detail_button_text_color'] ?? '',
//       seatsLeftStripBgColor: json['seats_left_strip_bg_color'] ?? '',
//       mentorshipCardBgColor1: json['mentorship_card_bg_color_1'] ?? '',
//       mentorshipCardBgColor2: json['mentorship_card_bg_color_2'] ?? '',
//       seatsLeftStripTextColor: json['seats_left_strip_text_color'] ?? '',
//       mentorshipInfoTitle1: json['mentorship_info_title_1'] ?? '',
//       mentorshipInfoTitle2: json['mentorship_info_title_2'] ?? '',
//       mentorshipInfoTitle3: json['mentorship_info_title_3'] ?? '',
//
//       // Previously added fields
//       mentorshipPlusCardBgColor1: json['mentorship_plus_card_bg_color_1'] ?? '',
//       mentorshipPlusCardBgColor2: json['mentorship_plus_card_bg_color_2'] ?? '',
//       mentorshipPlusLabel: json['mentorship_plus_label'] ?? '',
//       mentorshipInfoIcon1Url: json['mentorship_info_icon_1_url'] ?? '',
//       mentorshipInfoIcon2Url: json['mentorship_info_icon_2_url'] ?? '',
//       mentorshipInfoIcon3Url: json['mentorship_info_icon_3_url'] ?? '',
//
//       // **New Fields**
//       mentorshipCardAnimationColor1:
//           json['mentorship_card_animation_color_1'] ?? '',
//       mentorshipCardAnimationColor2:
//           json['mentorship_card_animation_color_2'] ?? '',
//       mentorshipPlusLabelTextColor1:
//           json['mentorship_plus_label_text_color_1'] ?? '',
//       mentorshipPlusLabelTextColor2:
//           json['mentorship_plus_label_text_color_2'] ?? '',
//       mentorshipPlusLabelBgColor: json['mentorship_plus_label_bg_color'] ?? '',
//       mentorshipPlusStripText: json['mentorship_plus_strip_text'] ?? '',
//       mentorshipPlusStripTextColor:
//                             json['mentorship_plus_strip_text_color'] ?? '',
//       mentorshipPlusStripBgColor: json['mentorship_plus_strip_bg_color'] ?? '',
//       seatLeftLabel: json['seat_left_label'] ?? '',
//     );
//   }
// }
class MentorshipModel {
  final bool status;
  final MentorshipData? data;

  MentorshipModel({required this.status, this.data});

  factory MentorshipModel.fromJson(Map<String, dynamic> json) {
    return MentorshipModel(
      status: json['status'] as bool,
      data: json['data'] != null ? MentorshipData.fromJson(json['data']) : null,
    );
  }
}

class MentorshipData {
  final List<String> certification;
  final String screenBgColor;
  final String seperatorColor;
  final String mentorListTitle;
  final String detailButtonText;
  final String detailButtonColor;
  final String mentorListBgColor;
  final String monthStripBgColor;
  final String mentorshipInfoColor;
  final String certificationIconUrl;
  final String mentorshipTitleColor;
  final String monthStripTextColor;
  final String mentorListTitleColor;
  final String detailButtonTextColor;
  final String seatsLeftStripBgColor;
  final String mentorshipCardBgColor1;
  final String mentorshipCardBgColor2;
  final String seatsLeftStripTextColor;
  final String mentorshipInfoTitle1;
  final String mentorshipInfoTitle2;
  final String mentorshipInfoTitle3;

  // PLUS fields
  final String mentorshipPlusCardBgColor1;
  final String mentorshipPlusCardBgColor2;
  final String mentorshipPlusLabel;
  final String mentorshipInfoIcon1Url;
  final String mentorshipInfoIcon2Url;
  final String mentorshipInfoIcon3Url;

  // PLUS animated fields
  final String mentorshipCardAnimationColor1;
  final String mentorshipCardAnimationColor2;
  final String mentorshipPlusLabelTextColor1;
  final String mentorshipPlusLabelTextColor2;
  final String mentorshipPlusLabelBgColor;
  final String mentorshipPlusStripText;
  final String mentorshipPlusStripTextColor;
  final String mentorshipPlusStripBgColor;
  final String seatLeftLabel;

  // **🎯 Micro Mentorship Fields**
  final String mentorshipMicroCardBgColor1;
  final String mentorshipMicroCardBgColor2;
  final String mentorshipMicroLabel;
  final String mentorshipMicroLabelTextColor1;
  final String mentorshipMicroLabelTextColor2;
  final String mentorshipMicroLabelBgColor;
  final String mentorshipMicroStripText;
  final String mentorshipMicroStripTextColor;
  final String mentorshipMicroStripBgColor;


  // **🎯 Micro Mentorship Fields**
  final String mentorshipNewCardBgColor1;
  final String mentorshipNewCardBgColor2;
  final String mentorshipNewCardAnimationColor1;
  final String mentorshipNewCardAnimationColor2;



  MentorshipData({
    required this.certification,
    required this.screenBgColor,
    required this.seperatorColor,
    required this.mentorListTitle,
    required this.detailButtonText,
    required this.detailButtonColor,
    required this.mentorListBgColor,
    required this.monthStripBgColor,
    required this.mentorshipInfoColor,
    required this.certificationIconUrl,
    required this.mentorshipTitleColor,
    required this.monthStripTextColor,
    required this.mentorListTitleColor,
    required this.detailButtonTextColor,
    required this.seatsLeftStripBgColor,
    required this.mentorshipCardBgColor1,
    required this.mentorshipCardBgColor2,
    required this.seatsLeftStripTextColor,
    required this.mentorshipInfoTitle1,
    required this.mentorshipInfoTitle2,
    required this.mentorshipInfoTitle3,
    required this.mentorshipPlusCardBgColor1,
    required this.mentorshipPlusCardBgColor2,
    required this.mentorshipPlusLabel,
    required this.mentorshipInfoIcon1Url,
    required this.mentorshipInfoIcon2Url,
    required this.mentorshipInfoIcon3Url,
    required this.mentorshipCardAnimationColor1,
    required this.mentorshipCardAnimationColor2,
    required this.mentorshipPlusLabelTextColor1,
    required this.mentorshipPlusLabelTextColor2,
    required this.mentorshipPlusLabelBgColor,
    required this.mentorshipPlusStripText,
    required this.mentorshipPlusStripTextColor,
    required this.mentorshipPlusStripBgColor,
    required this.seatLeftLabel,

    // micro mentorship
    required this.mentorshipMicroCardBgColor1,
    required this.mentorshipMicroCardBgColor2,
    required this.mentorshipMicroLabel,
    required this.mentorshipMicroLabelTextColor1,
    required this.mentorshipMicroLabelTextColor2,
    required this.mentorshipMicroLabelBgColor,
    required this.mentorshipMicroStripText,
    required this.mentorshipMicroStripTextColor,
    required this.mentorshipMicroStripBgColor,
    required this.mentorshipNewCardBgColor1,
    required this.mentorshipNewCardBgColor2,
    required this.mentorshipNewCardAnimationColor1,
    required this.mentorshipNewCardAnimationColor2,
  });

  factory MentorshipData.fromJson(Map<String, dynamic> json) {
    return MentorshipData(
      certification: List<String>.from(json['certification'] ?? []),
      screenBgColor: json['screen_bg_color'] ?? '',
      seperatorColor: json['seperator_color'] ?? '',
      mentorListTitle: json['mentor_list_title'] ?? '',
      detailButtonText: json['detail_button_text'] ?? '',
      detailButtonColor: json['detail_button_color'] ?? '',
      mentorListBgColor: json['mentor_list_bg_color'] ?? '',
      monthStripBgColor: json['month_strip_bg_color'] ?? '',
      mentorshipInfoColor: json['mentorship_info_color'] ?? '',
      certificationIconUrl: json['certification_icon_url'] ?? '',
      mentorshipTitleColor: json['mentorship_title_color'] ?? '',
      monthStripTextColor: json['month_strip_text_color'] ?? '',
      mentorListTitleColor: json['mentor_list_title_color'] ?? '',
      detailButtonTextColor: json['detail_button_text_color'] ?? '',
      seatsLeftStripBgColor: json['seats_left_strip_bg_color'] ?? '',
      mentorshipCardBgColor1: json['mentorship_card_bg_color_1'] ?? '',
      mentorshipCardBgColor2: json['mentorship_card_bg_color_2'] ?? '',
      seatsLeftStripTextColor: json['seats_left_strip_text_color'] ?? '',
      mentorshipInfoTitle1: json['mentorship_info_title_1'] ?? '',
      mentorshipInfoTitle2: json['mentorship_info_title_2'] ?? '',
      mentorshipInfoTitle3: json['mentorship_info_title_3'] ?? '',
      mentorshipPlusCardBgColor1: json['mentorship_plus_card_bg_color_1'] ?? '',
      mentorshipPlusCardBgColor2: json['mentorship_plus_card_bg_color_2'] ?? '',
      mentorshipPlusLabel: json['mentorship_plus_label'] ?? '',
      mentorshipInfoIcon1Url: json['mentorship_info_icon_1_url'] ?? '',
      mentorshipInfoIcon2Url: json['mentorship_info_icon_2_url'] ?? '',
      mentorshipInfoIcon3Url: json['mentorship_info_icon_3_url'] ?? '',
      mentorshipCardAnimationColor1:
      json['mentorship_card_animation_color_1'] ?? '',

      mentorshipCardAnimationColor2:
      json['mentorship_card_animation_color_2'] ?? '',
      mentorshipPlusLabelTextColor1:
      json['mentorship_plus_label_text_color_1'] ?? '',
      mentorshipPlusLabelTextColor2:
      json['mentorship_plus_label_text_color_2'] ?? '',
      mentorshipPlusLabelBgColor: json['mentorship_plus_label_bg_color'] ?? '',
      mentorshipPlusStripText: json['mentorship_plus_strip_text'] ?? '',
      mentorshipPlusStripTextColor:
      json['mentorship_plus_strip_text_color'] ?? '',
      mentorshipPlusStripBgColor: json['mentorship_plus_strip_bg_color'] ?? '',
      seatLeftLabel: json['seat_left_label'] ?? '',

      // Micro fields
      mentorshipMicroCardBgColor1: json['mentorship_micro_card_bg_color_1'] ?? '',
      mentorshipMicroCardBgColor2: json['mentorship_micro_card_bg_color_2'] ?? '',
      mentorshipMicroLabel: json['mentorship_micro_label'] ?? '',
      mentorshipMicroLabelTextColor1: json['mentorship_micro_label_text_color_1'] ?? '',
      mentorshipMicroLabelTextColor2: json['mentorship_micro_label_text_color_2'] ?? '',
      mentorshipMicroLabelBgColor: json['mentorship_micro_label_bg_color'] ?? '',
      mentorshipMicroStripText: json['mentorship_micro_strip_text'] ?? '',
      mentorshipMicroStripTextColor: json['mentorship_micro_strip_text_color'] ?? '',
      mentorshipMicroStripBgColor: json['mentorship_micro_strip_bg_color'] ?? '',
      mentorshipNewCardBgColor1: json['mentorship_new_card_bg_color_1'] ?? '',
      mentorshipNewCardBgColor2: json['mentorship_new_card_bg_color_2'] ?? '',
      mentorshipNewCardAnimationColor1: json['mentorship_new_card_animation_color_1'] ?? '#000000',
      mentorshipNewCardAnimationColor2: json['mentorship_new_card_animation_color_2'] ?? '#000000',
    );
  }
}
