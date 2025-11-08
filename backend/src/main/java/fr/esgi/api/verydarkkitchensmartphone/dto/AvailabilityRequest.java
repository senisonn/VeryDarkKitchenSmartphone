package fr.esgi.api.verydarkkitchensmartphone.dto;

import jakarta.validation.constraints.Future;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AvailabilityRequest {
    @NotNull
    @Future
    private LocalDateTime dateReservation;

    @NotNull
    @Min(1)
    @Max(20)
    private Integer nombrePersonnes;
}
