-- ============================================================
-- CRÉATION DES TABLES
-- ============================================================

-- =============
-- TABLE: users
-- =============
CREATE TABLE IF NOT EXISTS users (
                                     id BIGSERIAL PRIMARY KEY,
                                     username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    role VARCHAR(50) NOT NULL
    );

-- =============
-- TABLE: plats
-- =============
CREATE TABLE IF NOT EXISTS plats (
                                     id BIGSERIAL PRIMARY KEY,
                                     nom VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    prix DECIMAL(10, 2) CHECK (prix > 0),
    categorie VARCHAR(50),
    image_url VARCHAR(255),
    disponible BOOLEAN DEFAULT TRUE
    );

-- ===================
-- TABLE: reservations
-- ===================
CREATE TABLE IF NOT EXISTS reservations (
                                            id BIGSERIAL PRIMARY KEY,
                                            user_id BIGINT,
                                            email VARCHAR(255) NOT NULL,
    telephone VARCHAR(50) NOT NULL,
    date_reservation TIMESTAMP NOT NULL,
    nombre_personnes INTEGER CHECK (nombre_personnes >= 1 AND nombre_personnes <= 20),
    statut VARCHAR(50) DEFAULT 'EN_ATTENTE',
    commentaire VARCHAR(500),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
    );

-- ============================
-- TABLE: reservation_plats
-- ============================
CREATE TABLE IF NOT EXISTS reservation_plats (
                                                 reservation_id BIGINT NOT NULL,
                                                 plat_id BIGINT NOT NULL,
                                                 PRIMARY KEY (reservation_id, plat_id),
    FOREIGN KEY (reservation_id) REFERENCES reservations(id) ON DELETE CASCADE,
    FOREIGN KEY (plat_id) REFERENCES plats(id) ON DELETE CASCADE
    );

-- ============================================================
-- INSERTION DES DONNÉES
-- ============================================================

-- =======================================
-- TABLE: users
-- ⚠️ Les mots de passe doivent être hashés en production (BCrypt)
-- =======================================
INSERT INTO users (username, password, email, role) VALUES
                                                        ('admin', '$2a$10$B6o7NkVRPP8nUvqZFVxgy.VEgxryMj84eSeBPwMMDomrZCNBveEG6', 'admin@example.com', 'ADMIN'),
                                                        ('user', '$2a$10$B6o7NkVRPP8nUvqZFVxgy.VEgxryMj84eSeBPwMMDomrZCNBveEG6', 'user@example.com', 'USER'),
                                                        ('user2', '$2a$10$DEF...', 'user2@vdk.fr', 'USER')
    ON CONFLICT (username) DO NOTHING;

-- =============
-- TABLE: plats
-- =============
INSERT INTO plats (nom, description, prix, categorie, image_url, disponible) VALUES
                                                                                 ('Salade César', 'Salade romaine, poulet, parmesan et croûtons maison', 8.50, 'ENTREE', 'https://picsum.photos/200?salade', TRUE),
                                                                                 ('Soupe à l''oignon', 'Soupe traditionnelle gratinée avec du fromage', 6.00, 'ENTREE', 'https://picsum.photos/200?soupe', TRUE),
                                                                                 ('Burger maison', 'Bœuf, cheddar, salade, tomate, sauce spéciale', 13.90, 'PLAT_PRINCIPAL', 'https://picsum.photos/200?burger', TRUE),
                                                                                 ('Pâtes carbonara', 'Crème, œuf, lardons et parmesan', 12.00, 'PLAT_PRINCIPAL', 'https://picsum.photos/200?pates', TRUE),
                                                                                 ('Tarte Tatin', 'Tarte aux pommes caramélisées', 6.50, 'DESSERT', 'https://picsum.photos/200?tatin', TRUE),
                                                                                 ('Mousse au chocolat', 'Chocolat noir, légère et aérienne', 5.50, 'DESSERT', 'https://picsum.photos/200?mousse', TRUE),
                                                                                 ('Coca-Cola', 'Boisson gazeuse rafraîchissante', 2.50, 'BOISSON', 'https://picsum.photos/200?coca', TRUE),
                                                                                 ('Eau minérale', 'Bouteille 50cl', 1.80, 'BOISSON', 'https://picsum.photos/200?eau', TRUE)
    ON CONFLICT DO NOTHING;

-- =========================================
-- TABLE: reservations (avec user_id)
-- ⚠️ Les dates doivent être dans le futur
-- =========================================
INSERT INTO reservations (
    user_id, email, telephone, date_reservation, nombre_personnes,
    statut, commentaire, date_creation
) VALUES
      (2, 'user1@vdk.fr', '0601020304', NOW() + INTERVAL '1 day', 2, 'EN_ATTENTE', 'Table près de la fenêtre', NOW()),
      (2, 'user1@vdk.fr', '0605060708', NOW() + INTERVAL '2 day', 4, 'CONFIRMEE', 'Allergique aux noix', NOW()),
      (3, 'user2@vdk.fr', '0611121314', NOW() + INTERVAL '3 day', 3, 'ANNULEE', 'A annulé par téléphone', NOW()),
      (3, 'user2@vdk.fr', '0615161718', NOW() + INTERVAL '4 day', 5, 'TERMINEE', 'Anniversaire', NOW())
    ON CONFLICT DO NOTHING;

-- =========================================
-- TABLE: reservation_plats (relation ManyToMany)
-- =========================================
INSERT INTO reservation_plats (reservation_id, plat_id) VALUES
                                                            (1, 3), -- user1 -> Burger maison
                                                            (1, 7), -- user1 -> Coca-Cola
                                                            (2, 4), -- user1 -> Pâtes carbonara
                                                            (2, 6), -- user1 -> Mousse au chocolat
                                                            (3, 2), -- user2 -> Soupe à l'oignon
                                                            (4, 3), -- user2 -> Burger maison
                                                            (4, 5)  -- user2 -> Tarte Tatin
    ON CONFLICT DO NOTHING;