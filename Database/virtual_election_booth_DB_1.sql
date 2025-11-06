CREATE DATABASE virtual_elec_booth;
USE virtual_elec_booth;

CREATE TABLE Citizen_list(
	User_ID INT NOT NULL AUTO_INCREMENT,
    National_ID CHAR(13) NOT NULL,
    Phone_no CHAR(10) NOT NULL,
    DOB DATE NOT NULL,  
    has_regis CHAR(1) DEFAULT 'N' CHECK(has_regis IN ('Y', 'N')) NOT NULL,
    PRIMARY KEY (User_ID)
);

CREATE TABLE Candidate_list(
    Candidate_ID INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    img_path VARCHAR(255) NOT NULL,
    party VARCHAR(100) NOT NULL,  
    PRIMARY KEY (Candidate_ID)
);

CREATE TABLE Registered_voters(
	voter_ID INT NOT NULL AUTO_INCREMENT,
    username varchar(100) NOT NULL,
    encrypted_pass VARCHAR(255) NOT NULL,
    DOB DATE NOT NULL,  
    UserID INT NOT NULL,
    has_voted Char(1) DEFAULT 'N' CHECK(has_voted IN ('Y', 'N')),
    voting_token VARCHAR(100),
    PRIMARY KEY (voter_ID),
    FOREIGN KEY(UserID) REFERENCES Citizen_list(User_ID)
);

CREATE TABLE Result(
    CandidateID INT NOT NULL,
    number_voted INT NOT NULL DEFAULT 0,
    PRIMARY KEY (CandidateID),
    FOREIGN KEY(CandidateID) REFERENCES Candidate_list(Candidate_ID)
);

CREATE TABLE hasvoted_auditlog(
    log_ID INT NOT NULL AUTO_INCREMENT,
    time_stamp DATETIME NOT NULL,
    voter_ID INT NOT NULL,  
    old_has_voted CHAR(1),
    new_has_voted CHAR(1),
    changed_by VARCHAR(50),
    PRIMARY KEY (log_ID)
);

DELIMITER //
CREATE TRIGGER log_voter_update
AFTER UPDATE ON Registered_voters
FOR EACH ROW
BEGIN
    IF OLD.has_voted <> NEW.has_voted THEN
        INSERT INTO hasvoted_auditlog (time_stamp, voter_ID, old_has_voted, new_has_voted, changed_by)
        VALUES (NOW(), OLD.voter_ID, OLD.has_voted, NEW.has_voted, CURRENT_USER());
    END IF;
END //
DELIMITER ;

DELIMITER //

CREATE TRIGGER auto_insert_result
AFTER INSERT ON Candidate_list
FOR EACH ROW
BEGIN
    INSERT INTO Result (CandidateID)
    VALUES (NEW.Candidate_ID);
END //

DELIMITER ;