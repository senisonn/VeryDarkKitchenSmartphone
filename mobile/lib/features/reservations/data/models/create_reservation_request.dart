import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_reservation_request.freezed.dart';
part 'create_reservation_request.g.dart';

@freezed
class CreateReservationRequest with _$CreateReservationRequest {
  const factory CreateReservationRequest({
    required DateTime date,
    required String timeSlotId,
    required int guests,
    String? name,
    String? phone,
    String? email,
    String? notes,
  }) = _CreateReservationRequest;

  factory CreateReservationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateReservationRequestFromJson(json);
}
