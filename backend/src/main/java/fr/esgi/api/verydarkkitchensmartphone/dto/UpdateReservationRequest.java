package fr.esgi.api.verydarkkitchensmartphone.dto;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UpdateReservationRequest {
    @Email
    private String email;

    private String telephone;

    @Future
    private LocalDateTime dateReservation;

    @Min(1)
    @Max(20)
    private Integer nombrePersonnes;

    private List<Long> platIds;

    @Size(max = 500)
    private String commentaire;
}
