package fr.esgi.api.verydarkkitchensmartphone.service;

import fr.esgi.api.verydarkkitchensmartphone.dto.PlatDTO;
import fr.esgi.api.verydarkkitchensmartphone.models.CategoriePlat;
import fr.esgi.api.verydarkkitchensmartphone.models.Plat;
import fr.esgi.api.verydarkkitchensmartphone.repository.PlatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

/**
 * Service gérant les opérations métier liées aux plats.
 * Fournit des méthodes pour récupérer et manipuler les informations des plats.
 */
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PlatService {

    private final PlatRepository platRepository;

    /**
     * Récupère la liste de tous les plats disponibles dans le système.
     *
     * @return Liste des plats sous forme de DTO
     */
    public List<PlatDTO> getAllPlats() {
        return platRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    /**
     * Récupère un plat spécifique par son identifiant.
     *
     * @param id Identifiant du plat
     * @return DTO du plat correspondant
     * @throws RuntimeException si le plat n'est pas trouvé
     */
    public PlatDTO getPlatById(Long id) {
        Plat plat = platRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Plat non trouvé"));
        return convertToDTO(plat);
    }

    /**
     * Récupère tous les plats appartenant à une catégorie spécifique.
     *
     * @param categorie Catégorie des plats recherchés
     * @return Liste des plats de la catégorie
     */
    public List<PlatDTO> getPlatsByCategorie(CategoriePlat categorie) {
        return platRepository.findByCategorie(categorie).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    /**
     * Récupère uniquement les plats marqués comme disponibles.
     *
     * @return Liste des plats disponibles
     */
    public List<PlatDTO> getPlatsDisponibles() {
        return platRepository.findByDisponibleTrue().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    /**
     * Convertit une entité Plat en DTO pour l'exposition à l'API.
     *
     * @param plat Entité Plat à convertir
     * @return DTO contenant les informations du plat
     */
    private PlatDTO convertToDTO(Plat plat) {
        return PlatDTO.builder()
                .id(plat.getId())
                .nom(plat.getNom())
                .description(plat.getDescription())
                .prix(plat.getPrix())
                .categorie(plat.getCategorie().name())
                .imageUrl(plat.getImageUrl())
                .disponible(plat.getDisponible())
                .build();
    }
}