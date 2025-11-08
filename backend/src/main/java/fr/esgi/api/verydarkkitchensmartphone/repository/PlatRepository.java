package fr.esgi.api.verydarkkitchensmartphone.repository;

import fr.esgi.api.verydarkkitchensmartphone.models.CategoriePlat;
import fr.esgi.api.verydarkkitchensmartphone.models.Plat;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface PlatRepository extends JpaRepository<Plat, Long> {

    List<Plat> findByCategorie(CategoriePlat categorie);

    List<Plat> findByDisponibleTrue();

    List<Plat> findByNomContainingIgnoreCase(String nom);
}