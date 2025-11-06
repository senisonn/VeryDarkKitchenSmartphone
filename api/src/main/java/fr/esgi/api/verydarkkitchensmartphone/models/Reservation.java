package fr.esgi.api.verydarkkitchensmartphone.models;


import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "reservations")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Reservation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Le nom du client est obligatoire")
    private String nomClient;

    @NotBlank(message = "L'email est obligatoire")
    @Email(message = "Format d'email invalide")
    private String email;

    @NotBlank(message = "Le téléphone est obligatoire")
    private String telephone;

    @NotNull(message = "La date de réservation est obligatoire")
    @Future(message = "La date doit être dans le futur")
    private LocalDateTime dateReservation;

    @Min(value = 1, message = "Le nombre de personnes doit être au moins 1")
    @Max(value = 20, message = "Maximum 20 personnes par réservation")
    private Integer nombrePersonnes;

    @ManyToMany
    @JoinTable(
            name = "reservation_plats",
            joinColumns = @JoinColumn(name = "reservation_id"),
            inverseJoinColumns = @JoinColumn(name = "plat_id")
    )
    private List<Plat> plats = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    private StatutReservation statut = StatutReservation.EN_ATTENTE;

    @Column(length = 500)
    private String commentaire;

    @Column(name = "date_creation")
    private LocalDateTime dateCreation = LocalDateTime.now();
}