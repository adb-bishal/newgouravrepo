import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

class AllBatchesModal {
  bool? status;
  int? totalSubBatches;
  List<BatchData>? data;

  AllBatchesModal({this.status, this.totalSubBatches, this.data});

  AllBatchesModal.fromJson(Map<String, dynamic> json, bool isPast) {
    status = json['status'];
    totalSubBatches = json['total_subbatch'];
    if (json['data'] != null) {
      data = <BatchData>[];
      json['data'].forEach((v) {
        final batch = BatchData.fromJson(v);
        if (!isPast) {
          data!.add(batch);
        } else {
          logPrint("Checking batch ${batch.id}: hasRecording=${batch.hasRecording}");
          if (batch.hasRecording == 1) {
            data!.add(batch);
          }
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['total_subbatch'] = totalSubBatches;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BatchData {
  int? id;
  String? title;
  int? index;
  String? batchDetailFirst;
  String? batchDetailSecond;
  String? courseOfferTitle;
  String? shortDescription;
  int? discountPrice;
  String? discountText;
  String? discountTextTwo;
  String? live_start_datetime;
  String? live_end_datetime;
  int? actualPrice;
  int? addCourseOffer;
  String? batchVideo;
  String? image;
  String? descImage;
  String? totalStudentsEnrolled;
  String? batchStartDate;
  int? isActive;
  int? hasRecording;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  int? teacherId;
  String? startDate;
  String? startDatetime;
  List<int>? teachers;
  List<SubBatch>? subBatch;

  BatchData(
      {this.id,
      this.title,
      this.index,
      this.batchDetailFirst,
      this.batchDetailSecond,
      this.courseOfferTitle,
      this.shortDescription,
      this.discountPrice,
      this.startDatetime,
      this.discountText,
      this.discountTextTwo,
      this.live_start_datetime,
      this.live_end_datetime,
      this.actualPrice,
      this.addCourseOffer,
      this.batchVideo,
      this.image,
      this.hasRecording,
      this.descImage,
      this.totalStudentsEnrolled,
      this.batchStartDate,
      this.isActive,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.teacherId,
      this.startDate,
      this.teachers,
      this.subBatch});

  BatchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    index = json['index'];
    startDatetime = json['start_datetime'];

    batchDetailFirst = json['batch_detail_first'];
    batchDetailSecond = json['batch_detail_second'];
    courseOfferTitle = json['course_offer_title'];
    shortDescription = json['short_description'];
    live_start_datetime = json['live_start_datetime'];
    live_end_datetime = json['live_end_datetime'];
    discountPrice = json['discount_price'];
    discountText = json['discount_text'];
    discountTextTwo = json['discount_text_two'];
    actualPrice = json['actual_price'];
    addCourseOffer = json['add_course_offer'];
    batchVideo = json['batch_video'];
    image = json['image'];
    hasRecording = json['has_recording'];
    descImage = json['desc_image'];
    totalStudentsEnrolled = json['total_students_enrolled'];
    batchStartDate = json['batch_start_date'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    teacherId = json['teacher_id'];
    startDate = json['start_date'];
    teachers = json['teachers']?.cast<int>();
    if (json['sub_batch'] != null) {
      subBatch = <SubBatch>[];
      json['sub_batch'].forEach((v) {
        subBatch!.add(SubBatch.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['index'] = index;
    data['batch_detail_first'] = batchDetailFirst;
    data['batch_detail_second'] = batchDetailSecond;
    data['course_offer_title'] = courseOfferTitle;
    data['short_description'] = shortDescription;
    data['discount_price'] = discountPrice;
    data['discount_text'] = discountText;
    data['discount_text_two'] = discountTextTwo;
    data['live_start_datetime'] = live_start_datetime;
    data['live_end_datetime'] = live_end_datetime;
    data['actual_price'] = actualPrice;
    data['add_course_offer'] = addCourseOffer;
    data['batch_video'] = batchVideo;
    data['image'] = image;
    data['hasRecording'] = hasRecording;
    data['desc_image'] = descImage;
    data['total_students_enrolled'] = totalStudentsEnrolled;
    data['batch_start_date'] = batchStartDate;
    data['is_active'] = isActive;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['teacher_id'] = teacherId;
    data['start_date'] = startDate;
    data['teachers'] = teachers;
    data['sub_batch'] = subBatch?.map((v) => v.toJson()).toList();
    return data;
  }
}

class SubBatch {
  int? id;
  String? startDate;

  SubBatch({this.id, this.startDate});

  SubBatch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    return data;
  }
}
