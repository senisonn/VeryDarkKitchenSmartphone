package fr.esgi.api.verydarkkitchensmartphone.controller;


import fr.esgi.api.verydarkkitchensmartphone.dto.PlatDTO;
import fr.esgi.api.verydarkkitchensmartphone.models.CategoriePlat;
import fr.esgi.api.verydarkkitchensmartphone.service.PlatService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/plats")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // À configurer selon votre front
public class PlatController {

    private final PlatService platService;

    @GetMapping
    public ResponseEntity<List<PlatDTO>> getAllPlats() {
        return ResponseEntity.ok(platService.getAllPlats());
    }

    @GetMapping("/{id}")
    public ResponseEntity<PlatDTO> getPlatById(@PathVariable Long id) {
        return ResponseEntity.ok(platService.getPlatById(id));
    }

    @GetMapping("/categorie/{categorie}")
    public ResponseEntity<List<PlatDTO>> getPlatsByCategorie(
            @PathVariable CategoriePlat categorie) {
        return ResponseEntity.ok(platService.getPlatsByCategorie(categorie));
    }

    @GetMapping("/disponibles")
    public ResponseEntity<List<PlatDTO>> getPlatsDisponibles() {
        return ResponseEntity.ok(platService.getPlatsDisponibles());
    }
}