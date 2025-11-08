package fr.esgi.api.verydarkkitchensmartphone.dto;

import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Data
@Builder
public class ReservationResponse {
    private Long id;
    private Long idClient;
    private String email;
    private String telephone;
    private LocalDateTime dateReservation;
    private Integer nombrePersonnes;
    private List<PlatDTO> plats;
    private String statut;
    private String commentaire;
    private LocalDateTime dateCreation;
}