package fr.esgi.api.verydarkkitchensmartphone.dto;

import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class ReservationRequest {

    @NotNull(message = "L'ID client est obligatoire")  
    private Long idClient;

    @NotBlank(message = "L'email est obligatoire")
    @Email(message = "L'email doit être valide")
    private String email;

    @NotBlank(message = "Le téléphone est obligatoire")
    private String telephone;

    @NotNull(message = "La date de réservation est obligatoire")
    @Future(message = "La date doit être dans le futur")
    private LocalDateTime dateReservation;

    @NotNull(message = "Le nombre de personnes est obligatoire")  
    @Min(value = 1, message = "Minimum 1 personne")
    @Max(value = 20, message = "Maximum 20 personnes")
    private Integer nombrePersonnes;

    private List<Long> platIds;

    private String commentaire;
}