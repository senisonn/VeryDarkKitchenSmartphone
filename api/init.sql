-- Table USERS
CREATE TABLE IF NOT EXISTS users
(
    id
    BIGSERIAL
    PRIMARY
    KEY,
    username
    VARCHAR
(
    255
) UNIQUE NOT NULL,
    password VARCHAR
(
    255
) NOT NULL,
    email VARCHAR
(
    255
) UNIQUE NOT NULL,
    role VARCHAR
(
    50
) NOT NULL,
    account_non_expired BOOLEAN DEFAULT TRUE,
    account_non_locked BOOLEAN DEFAULT TRUE,
    credentials_non_expired BOOLEAN DEFAULT TRUE,
    enabled BOOLEAN DEFAULT TRUE
    );

-- Table PLATS
CREATE TABLE IF NOT EXISTS plats
(
    id
    BIGSERIAL
    PRIMARY
    KEY,
    nom
    VARCHAR
(
    255
) NOT NULL,
    description TEXT,
    prix DECIMAL
(
    10,
    2
) NOT NULL,
    categorie VARCHAR
(
    100
),
    image_url VARCHAR
(
    500
),
    disponible BOOLEAN DEFAULT TRUE
    );

-- Table RESERVATIONS
CREATE TABLE IF NOT EXISTS reservations
(
    id
    BIGSERIAL
    PRIMARY
    KEY,
    user_id
    BIGINT
    NOT
    NULL,
    nom_client
    VARCHAR
(
    100
) NOT NULL,
    email VARCHAR
(
    255
) NOT NULL,
    telephone VARCHAR
(
    20
),
    date_reservation TIMESTAMP NOT NULL,
    nombre_personnes INT NOT NULL,
    statut VARCHAR
(
    50
) NOT NULL,
    commentaire TEXT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY
(
    user_id
) REFERENCES users
(
    id
) ON DELETE CASCADE
    );

-- Table RESERVATION_PLATS
CREATE TABLE IF NOT EXISTS reservation_plats
(
    reservation_id
    BIGINT
    NOT
    NULL,
    plat_id
    BIGINT
    NOT
    NULL,
    PRIMARY
    KEY
(
    reservation_id,
    plat_id
),
    CONSTRAINT fk_reservation FOREIGN KEY
(
    reservation_id
) REFERENCES reservations
(
    id
) ON DELETE CASCADE,
    CONSTRAINT fk_plat FOREIGN KEY
(
    plat_id
) REFERENCES plats
(
    id
)
  ON DELETE CASCADE
    );

-- Index
CREATE INDEX IF NOT EXISTS idx_reservations_user_id ON reservations(user_id);
CREATE INDEX IF NOT EXISTS idx_reservations_date ON reservations(date_reservation);
CREATE INDEX IF NOT EXISTS idx_reservations_statut ON reservations(statut);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Données de test (mot de passe: password123)
INSERT INTO users (username, password, email, role)
VALUES ('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMye7I73TIeREq.tfpkQdZTJLgqCk6UM4jG', 'admin@restaurant.fr', 'ADMIN'),
       ('client1', '$2a$10$N9qo8uLOickgx2ZMRZoMye7I73TIeREq.tfpkQdZTJLgqCk6UM4jG', 'client1@email.fr', 'USER'),
       ('client2', '$2a$10$N9qo8uLOickgx2ZMRZoMye7I73TIeREq.tfpkQdZTJLgqCk6UM4jG', 'client2@email.fr',
        'USER') ON CONFLICT (username) DO NOTHING;

INSERT INTO plats (nom, description, prix, categorie, image_url, disponible)
VALUES ('Salade César', 'Salade fraîche avec poulet grillé', 12.50, 'ENTREE', 'https://exemple.com/salade.jpg', TRUE),
       ('Burger Maison', 'Burger avec steak haché et cheddar', 15.90, 'PLAT', 'https://exemple.com/burger.jpg', TRUE),
       ('Saumon Grillé', 'Pavé de saumon avec légumes', 18.50, 'PLAT', 'https://exemple.com/saumon.jpg', TRUE),
       ('Tiramisu', 'Tiramisu traditionnel', 7.50, 'DESSERT', 'https://exemple.com/tiramisu.jpg',
        TRUE) ON CONFLICT DO NOTHING;
