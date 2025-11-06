package fr.esgi.api.verydarkkitchensmartphone.models;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "plats")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Plat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Le nom du plat est obligatoire")
    @Size(max = 100)
    private String nom;

    @Column(length = 500)
    private String description;

    @DecimalMin(value = "0.0", inclusive = false)
    private BigDecimal prix;

    @Enumerated(EnumType.STRING)
    private CategoriePlat categorie;

    private String imageUrl;

    @Column(name = "disponible")
    private Boolean disponible = true;
}