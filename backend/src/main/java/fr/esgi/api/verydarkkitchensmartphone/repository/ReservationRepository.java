package fr.esgi.api.verydarkkitchensmartphone.repository;

import fr.esgi.api.verydarkkitchensmartphone.models.Reservation;
import fr.esgi.api.verydarkkitchensmartphone.models.StatutReservation;
import fr.esgi.api.verydarkkitchensmartphone.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface ReservationRepository extends JpaRepository<Reservation, Long> {

    List<Reservation> findByEmail(String email);

    List<Reservation> findByStatut(StatutReservation statut);

    List<Reservation> findByDateReservationBetween(LocalDateTime debut, LocalDateTime fin);

    List<Reservation> findByUser(User user);
}