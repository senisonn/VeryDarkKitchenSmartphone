package fr.esgi.api.verydarkkitchensmartphone.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AvailabilityResponse {
    private LocalDateTime dateReservation;
    private Integer totalCapacity;
    private Integer reservedSeats;
    private Integer availableSeats;
    private Boolean available;
}
