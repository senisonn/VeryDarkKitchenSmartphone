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

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PlatService {

    private final PlatRepository platRepository;

    public List<PlatDTO> getAllPlats() {
        return platRepository.findAll().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public PlatDTO getPlatById(Long id) {
        Plat plat = platRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Plat non trouvé"));
        return convertToDTO(plat);
    }

    public List<PlatDTO> getPlatsByCategorie(CategoriePlat categorie) {
        return platRepository.findByCategorie(categorie).stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

    public List<PlatDTO> getPlatsDisponibles() {
        return platRepository.findByDisponibleTrue().stream()
                .map(this::convertToDTO)
                .collect(Collectors.toList());
    }

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
