
-- Table: users
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    email VARCHAR(100) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('learner', 'expert', 'admin') DEFAULT 'learner',
    status ENUM('active', 'inactive'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL
);

-- Table: user_profiles
CREATE TABLE user_profiles (
    profile_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    bio TEXT,
    dob DATE NOT NULL,
    phone_number VARCHAR(15) UNIQUE,
    profile_picture VARCHAR(255),
    gender CHAR(1) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Table: skills
CREATE TABLE skills (
    skill_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    expert_id INT,
    title VARCHAR(100) NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    is_approved BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (expert_id) REFERENCES users(user_id)
);

-- Table: schedule
CREATE TABLE schedule (
    schedule_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    skill_id INT,
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

-- Table: registration
CREATE TABLE registration (
    registration_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    learner_id INT,
    skill_id INT,
    schedule_id INT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    registered_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (learner_id) REFERENCES users(user_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id),
    FOREIGN KEY (schedule_id) REFERENCES schedule(schedule_id)
);

-- Table: reviews
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    learner_id INT,
    skill_id INT,
    rating INT NOT NULL,
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (learner_id) REFERENCES users(user_id),
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id)
);

-- Table: expert_skill_requests
CREATE TABLE expert_skill_requests (
    request_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    expert_id INT,
    proposed_title VARCHAR(100) NOT NULL,
    proposed_description TEXT NOT NULL,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (expert_id) REFERENCES users(user_id)
);

-- Table: activity_log
CREATE TABLE activity_log (
    log_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT,
    action VARCHAR(255) NOT NULL,
    details TEXT NOT NULL,
    performed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Table: chatrooms
CREATE TABLE chatrooms (
    chat_room_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    participant_one_id INT,
    participant_two_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (participant_one_id) REFERENCES users(user_id),
    FOREIGN KEY (participant_two_id) REFERENCES users(user_id)
);

-- Table: messages
CREATE TABLE messages (
    message_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    chat_room_id INT,
    sender_id INT,
    message_text TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_read BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (chat_room_id) REFERENCES chatrooms(chat_room_id),
    FOREIGN KEY (sender_id) REFERENCES users(user_id)
);

-- Table: notifications
CREATE TABLE notifications (
    notification_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT,
    type ENUM('info', 'alert', 'message', 'reminder') NOT NULL,
    message TEXT NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
