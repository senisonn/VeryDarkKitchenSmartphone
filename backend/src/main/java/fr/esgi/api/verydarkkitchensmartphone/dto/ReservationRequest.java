package fr.esgi.api.verydarkkitchensmartphone.dto;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class ReservationRequest {

    @NotBlank
    private Long idClient;

    @NotBlank
    @Email
    private String email;

    @NotBlank
    private String telephone;

    @NotNull
    @Future
    private LocalDateTime dateReservation;

    @Min(1)
    @Max(20)
    private Integer nombrePersonnes;

    private List<Long> platIds;

    private String commentaire;
}

