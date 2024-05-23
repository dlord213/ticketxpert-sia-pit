-- Database name: ticketxpert (For SIA PIT)
/* ************** */
/* TABLE CREATION */
/* ************** */
CREATE TABLE
  users (
    user_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT,
    address TEXT,
    contact_number VARCHAR(12),
    username TEXT,
    password TEXT
  );

CREATE TABLE
  attendee (
    user_id BIGINT NOT NULL PRIMARY KEY REFERENCES users (user_id)
  );

CREATE TABLE
  venue (
    venue_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name text,
    address text,
    capacity int
  );

CREATE TABLE
  customer_support (
    customer_support_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name text,
    contact_number varchar(12)
  );

CREATE TABLE
  logistic (
    logistic_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name text,
    contact_number varchar(12)
  );

CREATE TABLE
  event (
    event_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name TEXT,
    description TEXT,
    _date DATE,
    category TEXT,
    portrait_image_url TEXT,
    cover_image_url TEXT,
    seat_plan_image_url TEXT,
    venue_id BIGINT NOT NULL,
    customer_support_id BIGINT NOT NULL,
    logistic_id BIGINT NOT NULL,
    CONSTRAINT fk_venue FOREIGN KEY (venue_id) REFERENCES venue (venue_id) ON DELETE CASCADE,
    CONSTRAINT fk_customer_support FOREIGN KEY (customer_support_id) REFERENCES customer_support (customer_support_id) ON DELETE CASCADE,
    CONSTRAINT fk_logistics FOREIGN KEY (logistic_id) REFERENCES logistic (logistic_id)
  );

CREATE TABLE
  ticket_promo (
    promo_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    code varchar(16),
    discount_amount decimal(10, 2),
    expiration_date date,
    usage_limit int
  );

CREATE TABLE
  ticket (
    ticket_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    quantity int,
    price decimal(10, 2),
    location text,
    event_id BIGINT NOT NULL REFERENCES event (event_id)
  );

CREATE TABLE
  transaction (
    transaction_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    attendee_id BIGINT NOT NULL REFERENCES attendee (user_id),
    ticket_id BIGINT NOT NULL REFERENCES ticket (ticket_id),
    promo_id BIGINT DEFAULT NULL REFERENCES ticket_promo (promo_id),
    transaction_date TIMESTAMP,
    amount int,
    status text
  );

CREATE TABLE
  ticket_delivery (
    ticket_delivery_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    transaction_id BIGINT NOT NULL REFERENCES transaction (transaction_id),
    is_delivered bool,
    ticket_type text
  );

CREATE TABLE
  seat (
    seat_id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    ticket_delivery_id BIGINT NOT NULL REFERENCES ticket_delivery (ticket_delivery_id),
    seat_number int
  );

/* ************** */
/* INDEX CREATION */
/* ************** */
CREATE INDEX idx_event ON event (event_id);

CREATE INDEX idx_venue ON venue (venue_id);

CREATE INDEX idx_user ON users (user_id);

/* ************** */
/* ROLES CREATION */
/* ************** */
CREATE ROLE administrator
WITH
  LOGIN PASSWORD 'admin' SUPERUSER;

CREATE ROLE public_user
WITH
  LOGIN PASSWORD 'public_user';

-- Grant privileges on public schema
GRANT
SELECT
  ON ticket_delivery TO public_user;

GRANT
SELECT
  ON seat TO public_user;

GRANT
SELECT
  ON ticket TO public_user;

GRANT
SELECT
,
UPDATE ON ticket_promo TO public_user;

-- Grant privileges on events schema
GRANT
SELECT
  ON event TO public_user;

GRANT
SELECT
  ON venue TO public_user;

GRANT
SELECT
  ON customer_support TO public_user;

GRANT
SELECT
  ON attendee TO public_user;

-- Grant privileges on payments schema
GRANT
SELECT
,
UPDATE ON payment_method TO public_user;

GRANT INSERT,
SELECT
,
UPDATE ON transaction TO public_user;

/* ******************* */
/* POPULATE THE TABLES */
/* ******************* */
INSERT INTO
  venue (name, address, capacity)
VALUES
  (
    'SM Mall Of Asia Arena',
    'Complex, SM Mall of Asia Arena, J.W. Diokno Boulevard, Mall of Asia - Cavite City, Pasay, 1300 Metro Manila',
    20000
  ),
  (
    'Samsung Hall, SM Aura Premier',
    '6/F SM Aura Premier, 26th Street, corner McKinley Pkwy, Taguig, Metro Manila',
    1000
  );

INSERT INTO
  customer_support (name, contact_number)
VALUES
  ('SM Online', '09673948765');

INSERT INTO
  logistic (name, contact_number)
VALUES
  ('SM Online', '09673948765');

INSERT INTO
  event (
    name,
    description,
    _date,
    category,
    portrait_image_url,
    cover_image_url,
    seat_plan_image_url,
    venue_id,
    customer_support_id,
    logistic_id
  )
VALUES
  (
    '2024 NCT DREAM WORLD TOUR',
    '2024 NCT DREAM WORLD TOUR',
    '2024-08-10',
    'Music',
    'https://images1.smtickets.com/images/portrait_07052024121212.jpg',
    'https://images1.smtickets.com/images/carousel_09052024103727.jpg',
    'https://images1.smtickets.com/images/seatplan_07052024121255.jpg',
    1,
    1,
    1
  ),
  (
    'LAUFEY 2024 BEWITCHED THE GODDESS TOUR',
    'Laufey (pronounced lay-vay) is a 24-year-old, Los Angeles-based singer, composer, producer and multi-instrumentalist whose jazz songs are about young love and self-discovery. Raised between Reykjavík and Washington, D.C. with annual visits to Beijing, the Icelandic-Chinese artist grew up playing cello as well as piano and became hooked on the jazz standards of Ella Fitzgerald after digging through her father’s record collection.',
    '2024-09-02',
    'Music',
    'https://images1.smtickets.com/images/portrait_11042024164540.jpg',
    'https://images1.smtickets.com/images/carousel_11042024164540.jpg',
    'https://images1.smtickets.com/images/seatplan_11042024164554.jpg',
    1,
    1,
    1
  ),
  (
    'TWICE X OISHI SNACKTACULAR FAN MEET',
    'KPOP group TWICE is returning to the Philippines for the Twice x Oishi Snacktacular Fan Meet. An O, Wow! O, Wow! fusion of flavor, fun, and fandom.',
    '2024-05-01',
    'Music',
    'https://images1.smtickets.com/images/portrait_23042024162627.jpg',
    'https://images1.smtickets.com/images/carousel_23042024162627.jpg',
    'https://images1.smtickets.com/images/seatplan_05052024130650.jpg',
    1,
    1,
    1
  ),
  (
    'ITZY 2ND WORLD TOUR BORN TO BE',
    'ITZY 2ND WORLD TOUR BORN TO BE',
    '2024-08-03',
    'Music',
    'https://images1.smtickets.com/images/portrait_05042024142732.jpg',
    'https://images1.smtickets.com/images/carousel_05042024142653.jpg',
    'https://images1.smtickets.com/images/seatplan_05042024142750.jpg',
    1,
    1,
    1
  ),
  (
    'MISS UNIVERSE PHILIPPINES 2024',
    'MISS UNIVERSE PHILIPPINES 2024',
    '2024-04-22',
    'Others',
    'https://images1.smtickets.com/images/portrait_05042024173719.jpg',
    'https://images1.smtickets.com/images/carousel_05042024173719.jpg',
    'https://images1.smtickets.com/images/seatplan_05042024173729.jpg',
    1,
    1,
    1
  );

-- NCT Tickets
INSERT INTO
  ticket (quantity, price, location, event_id)
VALUES
  (1, 15800, 'VIP SOUNDCHECK PACKAGE', 1),
  (1, 14250, 'FLOOR STANDING', 1),
  (16, 13500, 'LBA', 1),
  (10, 12500, 'LBB', 1),
  (16, 7500, 'UBB', 1),
  (16, 3500, 'GEN AD', 1)
  -- Laufey Tickets
INSERT INTO
  ticket (quantity, price, location, event_id)
VALUES
  (1, 9250, 'FLOOR FRONT', 2),
  (1, 8750, 'FLOOR BACK', 2),
  (1, 9250, 'FLOOR FRONT', 2),
  (8, 8250, 'PATRON', 2),
  (4, 7750, 'LBA PREMIUM', 2),
  (10, 7250, 'LBA REGULAR', 2),
  (4, 6750, 'LBB PREMIUM', 2),
  (6, 6250, 'LBB REGULAR', 2),
  (4, 4250, 'UB PREMIUM', 2),
  (12, 3250, 'UB REGULAR', 2),
  (16, 2250, 'GEN AD', 2);

-- TWICE Tickets
INSERT INTO
  ticket (quantity, price, location, event_id)
VALUES
  (3, 30, 'SVIP', 3),
  (3, 30, 'VIP', 3),
  (14, 30, 'LOWER BOX', 3),
  (16, 30, 'UPPER BOX', 3),
  (16, 30, 'GEN AD', 3);

-- ITZY Tickets
INSERT INTO
  ticket (quantity, price, location, event_id)
VALUES
  (5, 16500, 'VIP 1', 4),
  (6, 16000, 'VIP 2', 4),
  (8, 13000, 'LBA', 4),
  (6, 12500, 'LBB PREMIUM', 4),
  (4, 11750, 'LBB REGULAR', 4),
  (6, 7250, 'UB PREMIUM', 4),
  (10, 6500, 'UB REGULAR', 4),
  (16, 3000, 'GEN AD', 4)