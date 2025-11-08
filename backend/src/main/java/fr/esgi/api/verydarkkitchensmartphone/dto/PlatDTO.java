package fr.esgi.api.verydarkkitchensmartphone.dto;

import lombok.Builder;
import lombok.Data;

import java.math.BigDecimal;

@Data
@Builder
public class PlatDTO {
    private Long id;
    private String nom;
    private String description;
    private BigDecimal prix;
    private String categorie;
    private String imageUrl;
    private Boolean disponible;
}
