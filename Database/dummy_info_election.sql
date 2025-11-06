USE virtual_elec_booth;

INSERT INTO Citizen_list (National_ID, Phone_no, DOB)
VALUES
    ('1101402304533', '0874929151', '2005-02-23'),
    ('1234567890123', '0877867766', '2000-02-12')
    ;
    
INSERT INTO Candidate_list (name, img_path, party)
VALUES
    ('Prayat MakMak', 'akgbrviongveimg.png', 'Moving Backward'),
	('Pitak Salanghe', 'osjaokegneauevi.png', 'Sleeping In Class')
    ;
    

UPDATE result
SET number_voted = number_voted + 30
WHERE CandidateID = '2';

DELETE FROM Citizen_list;

UPDATE Citizen_list
SET has_regis = 'N'
WHERE User_ID = 1;